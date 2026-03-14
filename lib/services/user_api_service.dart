import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

class UserApiService {
  final String baseUrl = "https://fakestoreapi.com/users";

  // GET all
  Future<List<UserModel>> fetchUsers() async {
    final res = await http.get(Uri.parse(baseUrl));

    if (res.statusCode == 200) {
      final List data = json.decode(res.body);
      return data.map((e) => UserModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  // POST
  Future<UserModel> createUser(UserModel user) async {
    final res = await http.post(
      Uri.parse(baseUrl),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 200 || res.statusCode == 201) {
      return UserModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  // PUT
  Future<UserModel> updateUser(int id, UserModel user) async {
    final res = await http.put(
      Uri.parse('$baseUrl/$id'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(user.toJson()),
    );

    if (res.statusCode == 200) {
      return UserModel.fromJson(json.decode(res.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  // DELETE
  Future<void> deleteUser(int id) async {
    final res = await http.delete(Uri.parse('$baseUrl/$id'));

    if (res.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}