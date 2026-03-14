import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/user_model.dart';
import '../providers/user_provider.dart';

class UserFormScreen extends StatefulWidget {
  final UserModel? editUser; // ถ้าไม่ null = โหมดแก้ไข
  const UserFormScreen({super.key, this.editUser});
  @override
  State<UserFormScreen> createState() => _UserFormScreenState();
}

class _UserFormScreenState extends State<UserFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController emailCtrl;
  late final TextEditingController usernameCtrl;
  late final TextEditingController passwordCtrl;
  late final TextEditingController phoneCtrl;
  late final TextEditingController firstCtrl;
  late final TextEditingController lastCtrl;
  late final TextEditingController cityCtrl;
  late final TextEditingController streetCtrl;
  late final TextEditingController numberCtrl;
  late final TextEditingController zipCtrl;
  late final TextEditingController latCtrl;
  late final TextEditingController longCtrl;

  bool _isPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    final u = widget.editUser;
    emailCtrl = TextEditingController(text: u?.email ?? '');
    usernameCtrl = TextEditingController(text: u?.username ?? '');
    passwordCtrl = TextEditingController(text: u?.password ?? '');
    phoneCtrl = TextEditingController(text: u?.phone ?? '');
    firstCtrl = TextEditingController(text: u?.name.firstname ?? '');
    lastCtrl = TextEditingController(text: u?.name.lastname ?? '');
    cityCtrl = TextEditingController(text: u?.address.city ?? '');
    streetCtrl = TextEditingController(text: u?.address.street ?? '');
    numberCtrl = TextEditingController(
      text: (u?.address.number ?? 0).toString(),
    );
    zipCtrl = TextEditingController(text: u?.address.zipcode ?? '');
    latCtrl = TextEditingController(text: u?.address.geolocation.lat ?? '');
    longCtrl = TextEditingController(text: u?.address.geolocation.long ?? '');
  }

  @override
  void dispose() {
    emailCtrl.dispose();
    usernameCtrl.dispose();
    passwordCtrl.dispose();
    phoneCtrl.dispose();
    firstCtrl.dispose();
    lastCtrl.dispose();
    cityCtrl.dispose();
    streetCtrl.dispose();
    numberCtrl.dispose();
    zipCtrl.dispose();
    latCtrl.dispose();
    longCtrl.dispose();
    super.dispose();
  }

  UserModel _buildUser() {
    return UserModel(
      id: widget.editUser?.id,
      email: emailCtrl.text.trim(),
      username: usernameCtrl.text.trim(),
      password: passwordCtrl.text,
      phone: phoneCtrl.text.trim(),
      name: NameModel(
        firstname: firstCtrl.text.trim(),
        lastname: lastCtrl.text.trim(),
      ),
      address: AddressModel(
        city: cityCtrl.text.trim(),
        street: streetCtrl.text.trim(),
        number: int.tryParse(numberCtrl.text.trim()) ?? 0,
        zipcode: zipCtrl.text.trim(),
        geolocation: GeoLocationModel(
          lat: latCtrl.text.trim(),
          long: longCtrl.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.editUser != null;
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEdit ? 'Edit User' : 'Add User',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _sectionTitle('Account Information'),
              _textField(
                emailCtrl,
                'Email',
                validator: _required,
                icon: Icons.email_outlined,
              ),
              _textField(
                usernameCtrl,
                'Username',
                validator: _required,
                icon: Icons.person_outline,
              ),
              _textField(
                passwordCtrl,
                'Password',
                validator: _required,
                obscure: !_isPasswordVisible,
                icon: Icons.lock_outline,
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => _isPasswordVisible = !_isPasswordVisible),
                ),
              ),
              _textField(
                phoneCtrl,
                'Phone Number',
                validator: _required,
                icon: Icons.phone_outlined,
                keyboardType: TextInputType.phone,
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),

              _sectionTitle('Personal Name'),
              Row(
                children: [
                  Expanded(
                    child: _textField(
                      firstCtrl,
                      'First name',
                      validator: _required,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      lastCtrl,
                      'Last name',
                      validator: _required,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),

              _sectionTitle('Address Details'),
              _textField(
                cityCtrl,
                'City',
                validator: _required,
                icon: Icons.location_city_outlined,
              ),
              _textField(
                streetCtrl,
                'Street',
                validator: _required,
                icon: Icons.map_outlined,
              ),
              Row(
                children: [
                  Expanded(
                    child: _textField(
                      numberCtrl,
                      'House Number',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      zipCtrl,
                      'Zipcode',
                      keyboardType: TextInputType.number,
                    ),
                  ),
                ],
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: Divider(),
              ),

              _sectionTitle('Geolocation'),
              Row(
                children: [
                  Expanded(
                    child: _textField(
                      latCtrl,
                      'Latitude',
                      icon: Icons.explore_outlined,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _textField(
                      longCtrl,
                      'Longitude',
                      icon: Icons.explore_outlined,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              if (provider.error != null)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    provider.error!,
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                ),

              SizedBox(
                width: double.infinity,
                height: 54,
                child: FilledButton.icon(
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    backgroundColor: Colors.blue.shade700,
                  ),
                  onPressed: provider.isLoading
                      ? null
                      : () async {
                          if (!_formKey.currentState!.validate()) return;
                          final user = _buildUser();
                          final provider = context.read<UserProvider>();
                          if (isEdit) {
                            final id = widget.editUser!.id!;
                            await provider.editUser(id, user);
                          } else {
                            await provider.addUser(user);
                          }
                          if (!mounted) return;
                          final err = provider.error;
                          if (context.mounted) {
                            if (err == null) {
                              Navigator.pop(context);
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(err),
                                  backgroundColor: Colors.red,
                                ),
                              );
                            }
                          }
                        },
                  icon: provider.isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Icon(Icons.save_rounded),
                  label: Text(
                    isEdit ? 'Save Changes' : 'Create User',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  String? _required(String? v) =>
      (v == null || v.trim().isEmpty) ? 'Required' : null;

  Widget _sectionTitle(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 12, top: 4),
    child: Text(
      t,
      style: TextStyle(
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.blue.shade900,
      ),
    ),
  );

  Widget _textField(
    TextEditingController c,
    String label, {
    String? Function(String?)? validator,
    bool obscure = false,
    TextInputType? keyboardType,
    IconData? icon,
    Widget? suffixIcon,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: c,
        validator: validator,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: icon != null ? Icon(icon, size: 22) : null,
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: Colors.grey.shade50,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue.shade700, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
