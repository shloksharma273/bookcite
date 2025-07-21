from django.contrib import admin
from Books.models import Book,UserBookLike,BookReport

@admin.register(Book)
class BooksAdmin(admin.ModelAdmin):
    list_display=['id','name','author','genre','like','summary','number_of_likes','cover','document']

@admin.register(UserBookLike)
class UserBookLikeAdmin(admin.ModelAdmin):
    list_display=['user','book']

@admin.register(BookReport)
class BookReportAdmin(admin.ModelAdmin):
    list_display=['user','book','reason','reported_at']
    list_filter = ['reported_at']