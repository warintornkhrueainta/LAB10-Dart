import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/user_provider.dart';
import 'user_form_screen.dart';
import 'product_list_screen.dart';

class UserListScreen extends StatefulWidget {
  const UserListScreen({super.key});

  @override
  State<UserListScreen> createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().loadUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<UserProvider>();

    return Scaffold(
      backgroundColor:
          Colors.grey.shade50, // พื้นหลังสีเทาอ่อนให้ Card ดูลอยขึ้น
      appBar: AppBar(
        title: const Text(
          'User Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.store_rounded, size: 28),
            tooltip: 'Go to Products',
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const ProductListScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const UserFormScreen()),
          );
        },
        backgroundColor: Colors.blue.shade700,
        icon: const Icon(Icons.person_add_alt_1_rounded),
        label: const Text('Add User'),
      ),
      body: provider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : provider.users.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                80,
              ), // เผื่อที่ให้ FAB
              itemCount: provider.users.length,
              itemBuilder: (_, i) {
                final u = provider.users[i];
                return _buildUserCard(context, u, provider);
              },
            ),
    );
  }

  // --- UI สำหรับกรณีไม่มีข้อมูลผู้ใช้ ---
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline, size: 100, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Text(
            'No users found',
            style: TextStyle(fontSize: 18, color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // --- UI สำหรับ Card ผู้ใช้แต่ละคน ---
  Widget _buildUserCard(
    BuildContext context,
    dynamic u,
    UserProvider provider,
  ) {
    return Card(
      elevation: 0,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade200),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          radius: 25,
          backgroundColor: Colors.blue.shade100,
          child: Text(
            u.name.firstname[0].toUpperCase(),
            style: TextStyle(
              color: Colors.blue.shade800,
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
        ),
        title: Text(
          '${u.name.firstname} ${u.name.lastname}',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(u.email, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
            Row(
              children: [
                Icon(
                  Icons.phone_android_outlined,
                  size: 14,
                  color: Colors.grey.shade600,
                ),
                const SizedBox(width: 4),
                Text(u.phone, style: TextStyle(color: Colors.grey.shade600)),
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ปุ่มแก้ไข
            _buildActionButton(
              icon: Icons.edit_note_rounded,
              color: Colors.orange.shade700,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => UserFormScreen(editUser: u),
                  ),
                );
              },
            ),
            const SizedBox(width: 8),
            // ปุ่มลบ
            _buildActionButton(
              icon: Icons.delete_forever_rounded,
              color: Colors.red.shade700,
              onTap: () => _confirmDelete(context, u, provider),
            ),
          ],
        ),
      ),
    );
  }

  // --- Widget สำหรับปุ่ม Edit/Delete เล็กๆ ---
  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  // --- ฟังก์ชันยืนยันการลบ ---
  void _confirmDelete(BuildContext context, dynamic u, UserProvider provider) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${u.name.firstname}?'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              provider.removeUser(u.id!);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${u.name.firstname} has been deleted')),
              );
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
