class Book {
  final String id;
  final String name;
  final String author;
  final List<String> genres;
  final String summary;
  final String? cover;
  final int likes;

  Book({
    required this.id,
    required this.name,
    required this.author,
    required this.genres,
    required this.summary,
    required this.likes,
    this.cover,
  });

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(
      id: json['id'],
      name: json['name'] ?? 'Unknown Title',
      author: json['author'] ?? 'Unknown Author',
      genres: (json['genre'] as List<dynamic>)
          .map((g) => g['name'] as String)
          .toList(),
      summary: json['summary'] ?? '',
      likes: json['likes'] ?? 0,
      cover: json['cover'], // null if missing
    );
  }
}
