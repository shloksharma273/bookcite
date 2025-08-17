from django.contrib import admin
from Books.models import Book, BookReport,Genre

@admin.register(Genre)
class GenreAdmin(admin.ModelAdmin):
    list_display = ['name']

@admin.register(Book)
class BooksAdmin(admin.ModelAdmin):
    # 'genres_list' is a custom method we'll create to display the genres.
    list_display = ['id', 'name', 'author', 'genres_list', 'summary', 'number_of_likes', 'cover', 'document']

    def genres_list(self, obj):
        # The `genre` field is a ManyToManyField, so we need to iterate
        # through its related objects and get their names.
        return ", ".join([genre.name for genre in obj.genre.all()])
    
    # Give the custom method a user-friendly column header
    genres_list.short_description = 'Genres'


@admin.register(BookReport)
class BookReportAdmin(admin.ModelAdmin):
    list_display = ['user', 'book', 'reason', 'reported_at']
    list_filter = ['reported_at']