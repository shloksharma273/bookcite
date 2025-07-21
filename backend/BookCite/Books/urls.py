from django.urls import path
from .views import BookUploadView, BookListView, BookDownloadView, BookLikeToggleView

urlpatterns = [
    path('upload-book/',BookUploadView.as_view()),
    path('list-books/',BookListView.as_view()),
    path('<uuid:pk>/download/',BookDownloadView.as_view()),
    path('<uuid:pk>/toggle_like/', BookLikeToggleView.as_view(), name='book_toggle_like'),

]
