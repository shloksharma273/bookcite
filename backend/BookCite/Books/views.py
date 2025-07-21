from rest_framework.views import APIView
from rest_framework import status
from django.db import transaction
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework.permissions import AllowAny,IsAuthenticated 
from .serializers import BookUploadSerializer,BookListSerializer
from .models import Book, UserBookLike
from django.http import FileResponse
from django.db.models import F
from .drive_service import download_file_from_drive
from rest_framework.pagination import PageNumberPagination
from asgiref.sync import sync_to_async


class BookUploadView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    async def post(self, request):
        serializer = BookUploadSerializer(data=request.data)

        await sync_to_async(serializer.is_valid, thread_sensitive=True)(raise_exception=True)

        @sync_to_async
        @transaction.atomic
        def validate_and_save():
            serializer.is_valid(raise_exception=True)
            return serializer.save()

        book = await validate_and_save()
        
        @sync_to_async
        def get_urls():
            return {
                'cover_url': book.cover.url if book.cover else None,
                'document_url': book.document.url if book.document else None
            }

        urls = await get_urls()

        return Response({
            'message': "Book created successfully!",
            'book_id': book.id,
            'book_name': book.name,
            'book_author': book.author,
            'book_genre': book.genre,
            **urls
        }, status=status.HTTP_201_CREATED)


class BookPagination(PageNumberPagination):
    page_size = 10


class BookListView(APIView):
    permission_classes=[AllowAny]
    pagination_class = BookPagination

    def get(self,request):
        genre=request.GET.get('genre')
        author=request.GET.get('author')
        name=request.GET.get('name')
        books=None
        try:
            filters={}
            if genre:
                filters['genre__iexact']=genre
            if author:
                filters['author__iexact']=author
            if name:
                filters['name__icontains']=name

            if filters:
                books=Book.objects.filter(**filters)
                if not books.exists():
                    return Response(
                        {"error":f" No books found matching the given filters,"},
                        status=status.HTTP_404_NOT_FOUND
                    )
            else:
                books=Book.objects.all()
            book_serializer=BookListSerializer(books,many=True,context={'request':request})
            return Response(book_serializer.data,status=status.HTTP_200_OK)
        
        except Exception as e:
           
            print(f"An unexpected error occurred in BookListView: {e}")
            return Response(
                {'error': 'An internal server error occurred.', 'details': str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )

class BookDownloadView(APIView):
    permission_classes = [AllowAny]

    async def get(self, request, pk):
        try:
            book = await sync_to_async(Book.objects.get)(pk=pk)
        except Book.DoesNotExist:
            return Response({'error': 'Book not found'}, status=404)

        if not book.document:
            return Response({'error': 'No document for this book'}, status=404)

        file_content = await sync_to_async(download_file_from_drive)(book.document.name)  

        if not file_content:
            return Response({'error': 'Failed to download file'}, status=500)

        response = FileResponse(file_content, content_type='application/pdf')
        response['Content-Disposition'] = f'attachment; filename="{book.name}.pdf"'
        return response
    

class BookLikeToggleView(APIView):
    
    permission_classes=[IsAuthenticated]

    @transaction.atomic
    def post(self,request,pk):
        try:
            book=Book.objects.get(id=pk)
        except Book.DoesNotExist:
            return Response(
                {'detail':'Book not found.'},
                status=status.HTTP_404_NOT_FOUND
            )
        
        user=request.user

        try:
            like_instance=UserBookLike.objects.get(user=user,book=book)
            like_instance.delete()
            book.number_of_likes=F('number_of_likes')-1
            message="Book unliked."
            print(f"Debug: User {user.username} unliked book {book.name}.")
        except UserBookLike.DoesNotExist:
            UserBookLike.objects.create(user=user,book=book)
            book.number_of_likes=F("number_of_likes")+1
            message="Book liked."
            print(f"DEBUG: User {user.username} liked book {book.name}.")
        except Exception as e:
            print(f"DEBUG: Error during like toggle for book {book.id} by user {user.username}: {e}")
            return Response(
                {'error':'An error occured while toggling like status.', 'details':str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )
        
        book.save(update_fields=['number_of_likes'])
        book.refresh_from_db(fields=['number_of_likes'])

        return Response(
            {
             "message": message,
            "book_id": book.id,
            "current_likes": book.number_of_likes   
            },status=status.HTTP_200_OK
        )