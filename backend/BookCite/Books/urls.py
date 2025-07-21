from django.urls import path
from .views import (BookUploadView, BookListView, BookGenreListView,BookNameListView,
                    BookAuthorListView,BookDownloadView, BookLikeToggleView,UserLikedBooksView,
                    ReportBookView
)
urlpatterns = [
    path('upload-book/',BookUploadView.as_view()),
    path('list-books/',BookListView.as_view()),
    path('list-book-genre/', BookGenreListView.as_view()),
    path('list-book-name/', BookNameListView.as_view()),
    path('list-book-author/', BookAuthorListView.as_view()),
    path('liked-books/', UserLikedBooksView.as_view()),
    path('report-book/', ReportBookView.as_view()),
    path('download/', BookDownloadView.as_view()),
    path('toggle_like/', BookLikeToggleView.as_view(), name='book_toggle_like'),

]
