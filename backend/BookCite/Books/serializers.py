from rest_framework import serializers
from .models import Book,BookReport,Genre
from django.shortcuts import get_object_or_404
from django.http import Http404


class GenreSerializer(serializers.ModelSerializer):
    class Meta:
        model = Genre
        fields = ['name']

class BookUploadSerializer(serializers.ModelSerializer):
    genre_names = serializers.ListField(
        child=serializers.CharField(max_length=50),
        write_only=True,
        required=False,
        allow_empty=True
    )
    
    # For response, show genre details
    genre = GenreSerializer(many=True, read_only=True)
    
    class Meta:
        model = Book
        fields = ['id', 'name', 'author', 'genre_names', 'genre', 'summary', 'cover', 'document']
        
    def validate_cover(self, value):
        if value:
            valid_image_types = ['image/jpeg', 'image/jpg', 'image/png']
            if value.content_type not in valid_image_types:
                raise serializers.ValidationError("Cover image must be JPG/JPEG or PNG format.")
            
            if value.size > 5 * 1024 * 1024:  # 5MB limit
                raise serializers.ValidationError("Cover image size must be less than 5MB.")
        return value

    def validate_document(self, value):
        if value:
            if value.content_type != 'application/pdf':
                raise serializers.ValidationError("Document must be a PDF file.")
            
            if value.size > 50 * 1024 * 1024:  # 50MB limit
                raise serializers.ValidationError("Document size must be less than 50MB.")
        else:
            raise serializers.ValidationError("Document file is required") 
        return value
    
    def validate_genre_names(self, value):
        """Validate and clean genre names"""
        if not value:
            return value
        
        # Clean and validate each genre name
        cleaned_names = []
        for name in value:
            cleaned_name = name.strip().lower()
            if not cleaned_name:
                raise serializers.ValidationError("Genre names cannot be empty.")
            if len(cleaned_name) > 50:
                raise serializers.ValidationError(f"Genre name '{name}' is too long (max 50 characters).")
            cleaned_names.append(cleaned_name)
        
        # Remove duplicates while preserving order
        return list(dict.fromkeys(cleaned_names))
    
    def create(self, validated_data):
        genre_names = validated_data.pop('genre_names', [])
        
        # Create the book first
        book = Book.objects.create(**validated_data)
        
        # Handle genres
        if genre_names:
            genres = []
            for name in genre_names:
                genre, created = Genre.objects.get_or_create(name=name)
                genres.append(genre)
            
            # Set the genres for the book
            book.genre.set(genres)
        
        return book

    
class BookListSerializer(serializers.ModelSerializer):
    genre=GenreSerializer(many=True)

    class Meta:
        model = Book
        fields=['id','name','author','genre','summary','cover','document']


class BookReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = BookReport
        fields = ['book', 'reason']
        
    def validate(self, data):
        # Check if user already reported this book
        user = self.context['request'].user
        book = data['book']
        
        if BookReport.objects.filter(user=user, book=book).exists():
            raise serializers.ValidationError("You have already reported this book.")
        
        return data