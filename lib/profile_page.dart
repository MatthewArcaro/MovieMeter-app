import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'LoginPage.dart';

class ProfilePage extends StatefulWidget {
  final bool isDarkTheme;
  final Function toggleTheme;
  final Function onLogout;

  const ProfilePage({
    super.key,
    required this.isDarkTheme,
    required this.toggleTheme,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Theme Toggle Button
            ElevatedButton(
              onPressed: () {
                widget.toggleTheme();
              },
              child: Text(
                widget.isDarkTheme
                    ? 'Switch to Light Theme'
                    : 'Switch to Dark Theme',
              ),
            ),
            const SizedBox(height: 10),

            // Log Out Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: () {
                widget.onLogout(); // Reset app state and navigate to login page
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LoginPage(
                      onLogin: (userId) {
                        print('Logged in with userId: $userId');
                      },
                    ),
                  ),
                  (route) => false,
                );
              },
              child: const Text('Log Out'),
            ),
          ],
        ),
      ),
    );
  }
}
