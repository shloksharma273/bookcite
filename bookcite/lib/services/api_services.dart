import 'dart:convert';
import 'package:bookcite/services/models/book_model.dart';
import 'package:http/http.dart' as http;
import 'package:bookcite/services/models/auth_response.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  ApiService({required this.baseUrl});

  Future<AuthResponse> login({required String email,required String password}) async {
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
        final String? storedToken = await _secureStorage.read(key: 'access token');
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
  
  Future<bool> signUp({required String name, required String email, required String password}) async{
    final url = Uri.parse("$baseUrl/user/signup/");
    final response = await http.post(url, headers: {'Content-Type': 'application/json'}, body: json.encode(
        {
          "email": email,
          "password" : password,
          "name" : name
        }));
    if(response.statusCode == 201){
      return true;
    } else {
    throw Exception('Failed to Sign Up: $response.statusCode');
    }
  }

  Future<bool> isLoggedIn() async{
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
  final url = Uri.parse('$baseUrl/book/list-book-genre/?genre_name=$encodedGenre');

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
  } else if (response.statusCode == 401) {
    // Unauthorized → maybe token expired
    throw Exception("Unauthorized. Please login again.");
  } else {
    throw Exception('Failed to load books for $genreName. Status ${response.statusCode}');
  }
}


}
