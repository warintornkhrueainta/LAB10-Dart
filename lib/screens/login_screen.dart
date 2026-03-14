import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import '../models/user_model.dart';
import 'product_list_screen.dart';
import 'user_list_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final usernameCtrl = TextEditingController();
  final passwordCtrl = TextEditingController();

  bool _isPasswordVisible = false; // สำหรับเปิด-ปิดตาดูพาสเวิร์ด

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  void _handleLogin() {
    if (!_formKey.currentState!.validate()) return;

    final provider = context.read<UserProvider>();

    final username = usernameCtrl.text.trim();
    final password = passwordCtrl.text.trim();

    UserModel? foundUser;

    try {
      foundUser = provider.users.firstWhere(
        (u) =>
            (u.username ?? '').trim().toLowerCase() == username.toLowerCase() &&
            (u.password ?? '').trim() == password,
      );
    } catch (_) {
      foundUser = null;
    }

    if (foundUser != null) {
      provider.currentUser = foundUser;
      debugPrint('LOGIN USER: ${foundUser.username}');

      if ((foundUser.username ?? '').trim().toLowerCase() == 'johnd') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const UserListScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ProductListScreen()),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.error_outline, color: Colors.white),
              SizedBox(width: 8),
              Text('ชื่อผู้ใช้หรือรหัสผ่านไม่ถูกต้อง!'),
            ],
          ),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        // พื้นหลังแบบไล่เฉดสี (Gradient)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue.shade900, Colors.purple.shade700],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // โลโก้หรือไอคอนด้านบน
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.5),
                        width: 2,
                      ),
                    ),
                    child: const Icon(
                      Icons.shopping_cart_outlined,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 30),

                  // ข้อความต้อนรับ
                  const Text(
                    'FakeStore API',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'กรุณาเข้าสู่ระบบเพื่อดำเนินการต่อ',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white.withOpacity(0.8),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // กล่องฟอร์มกรอกข้อมูล
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          // ช่องกรอก Username
                          TextFormField(
                            controller: usernameCtrl,
                            decoration: InputDecoration(
                              labelText: 'ชื่อผู้ใช้งาน (Username)',
                              prefixIcon: const Icon(
                                Icons.person,
                                color: Colors.blue,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'กรุณากรอกชื่อผู้ใช้งาน'
                                : null,
                          ),
                          const SizedBox(height: 16),

                          // ช่องกรอก Password
                          TextFormField(
                            controller: passwordCtrl,
                            obscureText: !_isPasswordVisible,
                            decoration: InputDecoration(
                              labelText: 'รหัสผ่าน (Password)',
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: Colors.blue,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _isPasswordVisible
                                      ? Icons.visibility
                                      : Icons.visibility_off,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isPasswordVisible = !_isPasswordVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: const BorderSide(
                                  color: Colors.blue,
                                  width: 2,
                                ),
                              ),
                              filled: true,
                              fillColor: Colors.grey.shade50,
                            ),
                            validator: (v) => v == null || v.isEmpty
                                ? 'กรุณากรอกรหัสผ่าน'
                                : null,
                          ),
                          const SizedBox(height: 30),

                          // ปุ่ม Login
                          provider.isLoading
                              ? const CircularProgressIndicator()
                              : SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue.shade700,
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 3,
                                    ),
                                    onPressed: _handleLogin,
                                    child: const Text(
                                      'เข้าสู่ระบบ',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1,
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
