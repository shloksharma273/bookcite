from django.db import models
import uuid
from django.conf import settings 
from .storage import GoogleDriveStorage
from django.contrib.postgres.fields import ArrayField

class Book(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255, null=False, blank=False)
    author = models.CharField(max_length=255, null=False, blank=False)
    summary = models.TextField(null=False, blank=False,default="Book Summary")
    cover = models.ImageField(upload_to="cover_photo/", blank=True, storage=GoogleDriveStorage) 
    genre = ArrayField(models.CharField(max_length=50), blank=True, default=list)
    document = models.FileField(upload_to='book_pdf/', blank=True, storage=GoogleDriveStorage) 
    like = models.BooleanField(default=False)
    number_of_likes = models.PositiveIntegerField(default=0)


    def __str__(self):
        return f"{self.name}"
    

class UserBookLike(models.Model):
    user=models.ForeignKey(settings.AUTH_USER_MODEL,on_delete=models.CASCADE)
    book=models.ForeignKey(Book,on_delete=models.CASCADE)

    class Meta:
        unique_together=('user','book')
        verbose_name="User Book Like"
        verbose_name_plural="User Book Likes"
    
    def __str__(self):
        return f"{self.user.username} likes {self.book.name}"
    

class BookReport(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    reason = models.TextField(blank=True)
    reported_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.email} reported '{self.book.name}'"
