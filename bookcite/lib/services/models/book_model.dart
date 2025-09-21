class Book {
  final String id;
  final String name;
  final String author;
  final List<String> genres;
  final String summary;
  final String? cover;
  final int likes;
  final String document;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.genres,
    required this.summary,
    required this.likes,
    required this.document,
    this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    // Handle genre as List<Map> or List<String> or String
    List<String> parsedGenres = [];
    if (json['genre'] is List) {
      if ((json['genre'] as List).isNotEmpty && (json['genre'] as List).first is Map) {
        parsedGenres = (json['genre'] as List)
            .map((g) => g['name'] as String)
            .toList();
      } else {
        parsedGenres = List<String>.from(json['genre']);
      }
    } else if (json['genre'] is String) {
      parsedGenres = [json['genre']];
    }

    return Book(
      id: json['id'],
      name: json['name'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      genres: parsedGenres,
      summary: json['summary'] ?? '',
      likes: json['likes'] ?? 0,
      cover: json['cover'],
      document: json['document'] ?? '',
    );
  }
}
