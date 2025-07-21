from django.contrib import admin
from Books.models import Book,UserBookLike

@admin.register(Book)
class BooksAdmin(admin.ModelAdmin):
    list_display=['id','name','author','genre','like','number_of_likes','cover','document']

@admin.register(UserBookLike)
class UserBookLikeAdmin(admin.ModelAdmin):
    list_display=['user','book']