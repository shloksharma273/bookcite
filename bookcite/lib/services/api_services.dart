import 'dart:convert';
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
    print(response.body);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final authResponse = AuthResponse.fromJSON(json: data);
      await _secureStorage.write(
          key: 'access token', value: authResponse.accessToken);
      await _secureStorage.write(
          key: 'refresh token', value: authResponse.refreshToken);
      print("login successful");
      //TODO : remove this in production
      print(authResponse);
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
    return await _secureStorage.read(key: 'access') != null;
  }
}
