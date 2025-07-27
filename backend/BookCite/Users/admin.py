from django.contrib import admin
from .models import CustomUser

@admin.register(CustomUser)
class CustomUserAdmin(admin.ModelAdmin):
    list_display=['email','liked_books_list','is_active','is_staff']

    def liked_books_list(self, obj):
        return ", ".join([book.name for book in obj.liked_books.all()]) if obj.liked_books.exists() else "No liked books"
    liked_books_list.short_description = 'Liked Books'