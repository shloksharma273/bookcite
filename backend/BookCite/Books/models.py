from django.db import models
import uuid
from django.conf import settings 
from .storage import GoogleDriveStorage
from django.contrib.postgres.fields import ArrayField

class Genre(models.Model):
    name= models.CharField(max_length=50)

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        self.name = self.name.lower().strip()  # Added strip() to remove whitespace
        super().save(*args, **kwargs)

class Book(models.Model):
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)
    name = models.CharField(max_length=255, null=False, blank=False)
    author = models.CharField(max_length=255, null=False, blank=False)
    summary = models.TextField(null=False, blank=False,default="Book Summary")
    cover = models.ImageField(upload_to="cover_photo/", blank=True, storage=GoogleDriveStorage) 
    genre = models.ManyToManyField(Genre, blank=True)
    document = models.FileField(upload_to='book_pdf/', blank=True, storage=GoogleDriveStorage) 
    number_of_likes = models.PositiveIntegerField(default=0)


    def __str__(self):
        return f"{self.name}"
    


class BookReport(models.Model):
    user = models.ForeignKey(settings.AUTH_USER_MODEL, on_delete=models.CASCADE)
    book = models.ForeignKey(Book, on_delete=models.CASCADE)
    reason = models.TextField(blank=True)
    reported_at = models.DateTimeField(auto_now_add=True)

    class Meta:
        unique_together = ['user', 'book']

    def __str__(self):
        return f"{self.user.email} reported '{self.book.name}'"
