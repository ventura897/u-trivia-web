import 'package:flutter/material.dart';

import 'facultydashboard.dart';
import 'student.dart';

class SettingsFacultyPage extends StatelessWidget {
  const SettingsFacultyPage({super.key});

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Center(
            child:
                Text('LOG OUT', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
          content:
              const Text('Are you sure you want to log out of your account?'),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('YES'),
                ),
                const SizedBox(width: 15),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepOrange,
                      foregroundColor: Colors.white),
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('NO'),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Row(
        children: [
          Container(
            width: 240,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: const [
                      Icon(Icons.school, color: Colors.blue, size: 32),
                      SizedBox(width: 10),
                      Text('U-TRIVIA',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sidebarItem(context, Icons.dashboard, 'Dashboard', 0),
                _sidebarItem(context, Icons.people, 'Students', 1),
                _sidebarItem(context, Icons.settings, 'Settings', 2, true),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: const [
                      Icon(Icons.notifications_none, size: 24),
                      SizedBox(width: 20),
                      CircleAvatar(
                          backgroundColor: Colors.green,
                          child:
                              Text('I', style: TextStyle(color: Colors.white))),
                      SizedBox(width: 10),
                      Text('Ivana Cruz',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Settings',
                                style: TextStyle(
                                    fontSize: 28, fontWeight: FontWeight.bold)),
                            const Text(
                                'Customize your preferences ang manage your account .',
                                style: TextStyle(color: Colors.grey)),
                            const SizedBox(height: 25),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 200,
                                  height: 300,
                                  padding: const EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 8),
                                    decoration: BoxDecoration(
                                        color: Colors.blue[50],
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Row(
                                      children: const [
                                        Icon(Icons.person_outline,
                                            color: Colors.blue, size: 18),
                                        SizedBox(width: 8),
                                        Text('Account setting',
                                            style: TextStyle(
                                                color: Colors.blue,
                                                fontWeight: FontWeight.bold)),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 20),
                                Expanded(
                                  child: Container(
                                    padding: const EdgeInsets.all(25),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text('Account setting',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16)),
                                        const SizedBox(height: 20),
                                        _buildTextField(
                                            'Full Name', 'Ivana Cruz'),
                                        const SizedBox(height: 15),
                                        _buildTextField(
                                            'Email', 'Example@gmail.com'),
                                        const SizedBox(height: 15),
                                        _buildTextField(
                                            'Teacher ID', '20243813'),
                                        const SizedBox(height: 15),
                                        const Text('Password',
                                            style: TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey)),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text('***********',
                                                style: TextStyle(fontSize: 16)),
                                            OutlinedButton(
                                                onPressed: () {},
                                                child: const Text('Change')),
                                          ],
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Positioned(
                          bottom: 20,
                          right: 0,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.deepOrange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                            ),
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(Icons.logout),
                            label: const Text('LOG OUT'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _sidebarItem(
      BuildContext context, IconData icon, String title, int index,
      [bool selected = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.black54),
        title: Text(title,
            style: TextStyle(
                color: selected ? Colors.blue : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        onTap: () {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FacultyDashboard()));
          } else if (index == 1) {
            Navigator.pushReplacement(context,
                MaterialPageRoute(builder: (context) => const StudentPage()));
          }
        },
      ),
    );
  }

  Widget _buildTextField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(value, style: const TextStyle(fontSize: 16)),
            OutlinedButton(onPressed: () {}, child: const Text('Edit')),
          ],
        ),
        const Divider(),
      ],
    );
  }
}
