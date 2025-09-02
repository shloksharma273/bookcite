from rest_framework.views import APIView
from rest_framework import status
from django.db import transaction
from rest_framework.parsers import MultiPartParser, FormParser
from rest_framework.response import Response
from rest_framework.permissions import IsAuthenticated 
from .serializers import BookUploadSerializer,BookListSerializer,BookReportSerializer
from .models import Book
from django.db.models import F
from rest_framework.pagination import PageNumberPagination
from django.http import FileResponse, Http404
from .storage import GoogleDriveStorage
from django.utils.decorators import method_decorator
from django.views.decorators.cache import cache_page
from rest_framework import generics
from .models import Genre
from rest_framework.decorators import api_view
import http.client
import json
from rest_framework import status


class BookUploadView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser, FormParser]

    # In BookUploadView
    def post(self, request):
        serializer = BookUploadSerializer(data=request.data)
        if serializer.is_valid():
            book = serializer.save()
            
            # Return the created book data
            response_serializer = BookListSerializer(book, context={'request': request})
            return Response(response_serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)



class BookPagination(PageNumberPagination):
    page_size = 10

@method_decorator(cache_page(60 * 2), name='dispatch')  
class BookListView(generics.ListAPIView):
    permission_classes = [IsAuthenticated]
    pagination_class = BookPagination
    queryset = Book.objects.select_related().prefetch_related('genre')
    serializer_class = BookListSerializer



@method_decorator(cache_page(60 * 2), name='dispatch')  
class BookGenreListView(APIView):
    permission_classes = [IsAuthenticated]
    pagination_class = BookPagination
    serializer_class = BookListSerializer

    def get(self, request):
        genre_name = request.GET.get('genre_name')
        
        if not genre_name:
            return Response(
                {"error": "Missing 'genre_name' query parameter."}, 
                status=status.HTTP_400_BAD_REQUEST
            )
        
        cleaned_genre_name = genre_name.strip().lower()
        
        try:
            genre = Genre.objects.get(name=cleaned_genre_name)
        except Genre.DoesNotExist:
            return Response(
                {"error": f"Genre '{genre_name}' does not exist."}, 
                status=status.HTTP_404_NOT_FOUND
            )
        
        books = Book.objects.filter(
            genre=genre
        ).select_related().prefetch_related('genre').distinct()
        
        if not books.exists():
            return Response(
                {"message": f"No books found for genre '{genre_name}'.", "data": []}, 
                status=status.HTTP_200_OK
            )
        
        paginator = BookPagination()
        paginated_books = paginator.paginate_queryset(books, request)
        
        serializer = BookListSerializer(paginated_books, many=True, context={'request': request})
        return paginator.get_paginated_response(serializer.data)




@method_decorator(cache_page(60 * 2), name='dispatch')  
class BookNameListView(APIView):
    def get(self, request):
        name = request.GET.get('name')
        if not name:
            return Response({"error": "Missing name query parameter."}, status=status.HTTP_400_BAD_REQUEST)
        
        books = Book.objects.filter(name__icontains=name)
        
        if not books.exists():
            return Response({"error": "No books found for this name."}, status=status.HTTP_404_NOT_FOUND)
        
        book_serializer = BookListSerializer(books, many=True, context={'request': request})
        return Response({"data": book_serializer.data}, status=status.HTTP_200_OK)


@method_decorator(cache_page(60 * 2), name='dispatch')  
class BookAuthorListView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        author = request.GET.get('author')
        if author:
            books = Book.objects.filter(author=author)
            serializer = BookListSerializer(books, many=True)
            return Response(serializer.data)
        else:
            return Response({'error': 'Author query parameter is required'})

class BookDownloadView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        book_id = request.GET.get('book_id')
        if not book_id:
            return Response({"error": "Missing book_id query parameter."}, status=status.HTTP_400_BAD_REQUEST)
        try:
            book = Book.objects.get(id=book_id)
        except Book.DoesNotExist:
            raise Http404("Book not found.")

        if not book.document:
            return Response({"error": "No document found for this book."}, status=status.HTTP_404_NOT_FOUND)

        storage = GoogleDriveStorage()

        try:
            file = storage.open(book.document.name, mode='rb')
        except FileNotFoundError:
            return Response({"error": "File not found on Google Drive."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        response = FileResponse(file, as_attachment=True, filename=f"{book.name}.pdf")
        response['Content-Type'] = 'application/pdf'
        return response
    

class BookLikeToggleView(APIView):
    permission_classes = [IsAuthenticated]

    @transaction.atomic
    def post(self, request):
        book_id = request.data.get('book_id')
        if not book_id:
            return Response({'error': 'Missing book_id'}, status=status.HTTP_400_BAD_REQUEST)

        try:
            book = Book.objects.select_for_update().get(id=book_id)
        except Book.DoesNotExist:
            return Response({'error': 'Book not found'}, status=status.HTTP_404_NOT_FOUND)

        user = request.user

        if book in user.liked_books.all():
            user.liked_books.remove(book)
            book.number_of_likes = F('number_of_likes') - 1
            message = "Book unliked."
        else:
            user.liked_books.add(book)
            book.number_of_likes = F('number_of_likes') + 1
            message = "Book liked."

        book.save(update_fields=['number_of_likes'])
        book.refresh_from_db(fields=['number_of_likes'])

        return Response({
            'message': message,
            'book_id': book.id,
            'current_likes': book.number_of_likes
        }, status=status.HTTP_200_OK)


@method_decorator(cache_page(60 * 2), name='dispatch')
class UserLikedBooksView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        liked_books = request.user.liked_books.only("id", "name").all()
        serializer = BookListSerializer(liked_books, many=True, context={'request': request})
        return Response(serializer.data, status=status.HTTP_200_OK)



class ReportBookView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        serializer = BookReportSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save(user=request.user)
            return Response({"message": "Book reported successfully."}, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


# def generate_quotes_from_title(title):
#     """
#     Calls the external API to perform a web search for quotes from a book title.
    
#     Args:
#         title (str): The title of the book to find quotes for.
        
#     Returns:
#         list: A list of quotes found for the book, or an error message.
#     """
#     try:
#         # Create a dynamic prompt to instruct the API to do a web search
#         prompt = f"Find 5 popular quotes from the book titled '{title}'."
        
#         payload_data = {
#             "messages": [{"role": "user", "content": prompt}],
#             "web_access": True, # <-- This is the key change
#             "context_info": f"Book Title: {title}"
#         }
#         payload = json.dumps(payload_data)

#         headers = {
#             'x-rapidapi-key': "f9a37c9e88msh2cf6f14cb2628e8p1b4644jsn1481e0db4996",
#             'x-rapidapi-host': "chatgpt-42.p.rapidapi.com",
#             'Content-Type': "application/json"
#         }
        
#         conn = http.client.HTTPSConnection("chatgpt-42.p.rapidapi.com")
#         conn.request("POST", "/gpt4o", payload, headers)
#         res = conn.getresponse()
#         data = res.read()
        
#         response_json = json.loads(data.decode("utf-8"))

#         if "error" in response_json:
#             return [f"API Error: {response_json['error']}"]
        
#         if "choices" in response_json and len(response_json["choices"]) > 0:
#             # The API will return a single block of text containing multiple quotes.
#             # We split the text by newlines to get a list of quotes.
#             quote_text = response_json["choices"][0]["message"]["content"]
#             quotes = [q.strip() for q in quote_text.split('\n') if q.strip()]
#             return quotes
#         else:
#             return ["Unexpected API response format."]

#     except Exception as e:
#         return [f"An error occurred: {e}"]

# @api_view(['POST'])
# def get_quotes_api(request):
#     """
#     API endpoint to receive a list of books via a POST request
#     and generate quotes for each one.
#     """
#     books_data = request.data.get('books', [])

#     if not books_data:
#         return Response(
#             {"error": "Please provide a list of books in the request body."},
#             status=status.HTTP_400_BAD_REQUEST
#         )
    
#     quotes_results = []
#     for book in books_data:
#         title = book.get('title')
#         if title:
#             # Call the helper function to get quotes by title
#             generated_quotes = generate_quotes_from_title(title)
#             quotes_results.append({
#                 'book_title': title,
#                 'quotes': generated_quotes
#             })
    
#     if not quotes_results:
#         return Response(
#             {"error": "No quotes could be generated. Ensure books have valid titles."},
#             status=status.HTTP_404_NOT_FOUND
#         )

#     return Response({"quotes_results": quotes_results}, status=status.HTTP_200_OK)