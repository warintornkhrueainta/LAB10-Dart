import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/user_api_service.dart';

class UserProvider extends ChangeNotifier {
  final UserApiService _api = UserApiService();

  List<UserModel> users = [];
  bool isLoading = false;
  String? error;

  UserModel? currentUser;

  /// ⭐ กำหนด johnd เป็น admin คนเดียว
  bool get isAdmin => currentUser?.username == 'johnd';

  Future<void> loadUsers() async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      users = await _api.fetchUsers();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addUser(UserModel user) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final newUser = await _api.createUser(user);
      users.add(newUser);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> editUser(int id, UserModel user) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      final updated = await _api.updateUser(id, user);
      final index = users.indexWhere((u) => u.id == id);
      if (index != -1) {
        users[index] = updated;
      }
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> removeUser(int id) async {
    try {
      isLoading = true;
      error = null;
      notifyListeners();

      await _api.deleteUser(id);
      users.removeWhere((u) => u.id == id);
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
