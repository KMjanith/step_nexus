import 'package:flutter/material.dart';
import 'database_helper.dart';

class UserMenu extends StatefulWidget {
  @override
  _UserMenuState createState() => _UserMenuState();
}

class _UserMenuState extends State<UserMenu> {
  List<Map<String, dynamic>> users = [];

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    final data = await DatabaseHelper.instance.getUsers();
    setState(() {
      users = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('User Menu'),
      ),
      body: ListView.builder(
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return ListTile(
            title: Text(user['name']),
            subtitle: Text(user['email']),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                await DatabaseHelper.instance.deleteUser(user['id']);
                _loadUsers(); // Refresh the list
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newUser = {
            'name': 'New User',
            'email': 'new.user@example.com',
          };
          await DatabaseHelper.instance.insertUser(newUser);
          _loadUsers(); // Refresh the list
        },
        child: Icon(Icons.add),
      ),
    );
  }
}