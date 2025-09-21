import 'dart:convert';
import 'package:bookcite/services/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:bookcite/services/models/auth_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService({required this.baseUrl});

  Future<AuthResponse> login(
      {required String email, required String password}) async {
    final url = Uri.parse('$baseUrl/user/login/');
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'email': email, 'password': password}));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final authResponse = AuthResponse.fromJSON(json: data);
      await _secureStorage.write(
          key: 'access token', value: authResponse.accessToken);
      await _secureStorage.write(
          key: 'refresh token', value: authResponse.refreshToken);

      //TODO: Remove this print command before production
      final String? storedToken =
          await _secureStorage.read(key: 'access token');
      if (storedToken != null) {
        print('Stored Access Token: $storedToken');
      } else {
        print('No access token stored.');
      }

      return authResponse;
    } else {
      throw Exception('Failed to Login. Status ${response.statusCode}');
    }
  }

  Future<bool> signUp(
      {required String name,
      required String email,
      required String password}) async {
    final url = Uri.parse("$baseUrl/user/signup/");
    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body:
            json.encode({"email": email, "password": password, "name": name}));
    if (response.statusCode == 201) {
      return true;
    } else {
      throw Exception('Failed to Sign Up: $response.statusCode');
    }
  }

  Future<bool> isLoggedIn() async {
    return await _secureStorage.read(key: 'access token') != null;
  }

  Future<List<Book>> fetchBooksByGenre(String genreName) async {
    // Read the access token from secure storage (your "cookie" equivalent here)
    final String? token = await _secureStorage.read(key: 'access token');
    if (token == null) {
      throw Exception("No access token found. Please login again.");
    }

    // Encode the genre to be URL safe
    final encodedGenre = Uri.encodeComponent(genreName);
    final url =
        Uri.parse('$baseUrl/book/list-book-genre/?genre_name=$encodedGenre');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // attach token from cookies
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['results'];
      return results.map((book) => Book.fromJson(book)).toList();
    } else if (response.statusCode == 404) {
      //No books found
      return [];
    } else if (response.statusCode == 401) {
      // Unauthorized → maybe token expired
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception(
          'Failed to load books for $genreName. Status ${response.statusCode}');
    }
  }

  Future<Book?> fetchBookByName(String bookName) async {
    // Read the access token from secure storage (your "cookie" equivalent here)
    final String? token = await _secureStorage.read(key: 'access token');
    if (token == null) {
      throw Exception("No access token found. Please login again.");
    }

    // Encode the genre to be URL safe
    final encodedGenre = Uri.encodeComponent(bookName);
    final url =
    Uri.parse('$baseUrl/book/list-book-genre/?name=$encodedGenre');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // attach token from cookies
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'];
      if (results.isNotEmpty) {
        return Book.fromJson(results[0]);
      } else {
        throw Exception("No book found in response");
      }
    } else if (response.statusCode == 404){
      return null;
    } else {
      throw Exception('Failed to load book. Status ${response.statusCode}');
    }
  }

  Future<List<Book>> fetchLikedBooks() async {
    // 1. Get access token from secure storage
    final String? token = await _secureStorage.read(key: 'access token');
    if (token == null) {
      throw Exception("No access token found. Please login again.");
    }

    // 2. Prepare the API endpoint
    final url = Uri.parse('https://bookcite.onrender.com/book/liked-books/');

    // 3. Make the GET request with Authorization header
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // 4. Handle the response
    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((book) => Book.fromJson(book)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception('Failed to load liked books. Status ${response.statusCode}');
    }
  }

  Future<List<Book>> fetchBooksByName(String bookName) async {
    // 1. Get access token from secure storage
    final String? token = await _secureStorage.read(key: 'access token');
    if (token == null) {
      throw Exception("No access token found. Please login again.");
    }

    // 2. Prepare the API endpoint
    final encodedName = Uri.encodeComponent(bookName);
    final url = Uri.parse('https://bookcite.onrender.com/book/list-book-name/?name=$encodedName');

    // 3. Make the GET request with Authorization header
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    // 4. Handle the response
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> results = data['data'];
      return results.map((book) => Book.fromJson(book)).toList();
    } else if (response.statusCode == 401) {
      throw Exception("Unauthorized. Please login again.");
    } else {
      throw Exception('Failed to load books by name. Status ${response.statusCode}');
    }
  }
}
