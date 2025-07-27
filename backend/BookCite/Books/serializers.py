from rest_framework import serializers
from .models import Book,BookReport

class BookUploadSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields=['id','name','author','genre','summary','cover','document']

        
        def validate_cover(self,value):
            if value:
                valid_image_types=['image/jpeg','image/jpg','image/png']
                if value.content_type not in valid_image_types:
                    raise serializers.ValidationError("Cover image must be JPG/JPEG or PNG format.")
            return value

        def validate_document(self,value):
            if value:
                if value.content_type!='application/pdf':
                    raise serializers.ValidationError("Document must be a pdf file.")
            else:
                raise serializers.ValidationError("Document file is required") 
            return value

class BookListSerializer(serializers.ModelSerializer):
    class Meta:
        model = Book
        fields=['id','name','author','genre','summary','cover','document']


class BookReportSerializer(serializers.ModelSerializer):
    class Meta:
        model = BookReport
        fields = ['book', 'reason']  