from django.contrib import admin
from Books.models import Book,BookReport

@admin.register(Book)
class BooksAdmin(admin.ModelAdmin):
    list_display=['id','name','author','genre','summary','number_of_likes','cover','document']


@admin.register(BookReport)
class BookReportAdmin(admin.ModelAdmin):
    list_display=['user','book','reason','reported_at']
    list_filter = ['reported_at']