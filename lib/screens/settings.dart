import 'package:flutter/material.dart';

import 'dashboard.dart';
import 'login_page.dart'; // Palitan ito depende sa tamang path ng login page mo

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // 0: Profile, 1: Account setting, 2: Notification, 3: Security
  int _selectedMenuIndex = 1;

  // Controllers para sa Account Settings
  final TextEditingController _nameController =
      TextEditingController(text: 'Patrick Marquez');
  final TextEditingController _emailController =
      TextEditingController(text: 'example@gmail.com');
  final TextEditingController _phoneController =
      TextEditingController(text: '+63 912 345 6789');
  final TextEditingController _birthdateController =
      TextEditingController(text: 'October 15, 2005');
  final TextEditingController _courseController = TextEditingController(
      text: 'Bachelor of Science in Information Technology');

  // Function para sa Log Out Confirmation Dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: const Text(
            'Log Out',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Are you sure you want to log out?',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Isara ang dialog (No)
              },
              child: const Text(
                'No',
                style:
                    TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF97316),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop(); // Isara muna ang dialog
                // Pumunta sa Login Page at i-clear ang buong stack para hindi na makabalik sa dashboard nang walang login
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text(
                'Yes',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentIndex: 5),
          Expanded(
            child: Column(
              children: [
                const TopHeader(),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Header
                        const Text(
                          'Settings',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text(
                          'Customize your preferences and manage your account.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 24),

                        // Settings Content Layout
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left Sub-navigation Menu
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  children: [
                                    _buildSettingsMenuItem(
                                      Icons.person,
                                      'Profile',
                                      0,
                                    ),
                                    _buildSettingsMenuItem(
                                      Icons.manage_accounts,
                                      'Account setting',
                                      1,
                                    ),
                                    _buildSettingsMenuItem(
                                      Icons.notifications,
                                      'Notification',
                                      2,
                                    ),
                                    _buildSettingsMenuItem(
                                      Icons.security,
                                      'Security',
                                      3,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),

                            // Right Dynamic Content Panel
                            Expanded(
                              flex: 5,
                              child: Container(
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: _buildRightContentPanel(),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 40),

                        // Logout Button at Bottom Right
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFF97316),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 12,
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: () => _showLogoutDialog(context),
                            icon: const Icon(Icons.logout, size: 18),
                            label: const Text(
                              'LOG OUT',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
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
        ],
      ),
    );
  }

  // Piliin ang ipapakita sa kanan batay sa piniling menu item
  Widget _buildRightContentPanel() {
    switch (_selectedMenuIndex) {
      case 0:
        return _buildProfileView();
      case 1:
        return _buildAccountSettingsView();
      case 2:
        return _buildNotificationView();
      case 3:
        return _buildSecurityView();
      default:
        return _buildProfileView();
    }
  }

  // 1. Profile View
  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Color(0xFF047857),
                  child: Text(
                    'P',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.camera_alt,
                      size: 14,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Text(
                      'Patrick Marquez',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text(
                      'CITE',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'example@gmail.com',
                  style: TextStyle(color: Colors.grey, fontSize: 13),
                ),
                const SizedBox(height: 6),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Level 1 Beginner',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            Expanded(
              child: _buildInfoCard(
                'Total Points',
                '150',
                Icons.star,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Quizzes Completed',
                '3',
                Icons.assignment,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Campus Rank',
                '#11',
                Icons.emoji_events,
                Colors.orange,
                sub: 'Top 5% of students',
              ),
            ),
          ],
        ),
      ],
    );
  }

  // 2. Account Settings View
  Widget _buildAccountSettingsView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Account Setting',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 6),
        const Text(
          'Update your personal information and account details.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 24),

        // Change Name
        _buildTextFieldLabel('Change Name'),
        const SizedBox(height: 6),
        TextField(
          controller: _nameController,
          decoration:
              _inputDecoration('Enter your full name', Icons.person_outline),
        ),
        const SizedBox(height: 16),

        // Email & Phone Number
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldLabel('Email Address'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _emailController,
                    decoration: _inputDecoration(
                        'Enter your email', Icons.email_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldLabel('Phone / Number'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _phoneController,
                    decoration: _inputDecoration(
                        'Enter mobile number', Icons.phone_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Birthdate & Course
        Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldLabel('Birthdate'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _birthdateController,
                    decoration: _inputDecoration(
                        'Select birthdate', Icons.calendar_today_outlined),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTextFieldLabel('Change Course'),
                  const SizedBox(height: 6),
                  TextField(
                    controller: _courseController,
                    decoration: _inputDecoration(
                        'Enter your course', Icons.school_outlined),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 30),

        // Save Changes Button
        Align(
          alignment: Alignment.centerRight,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF047857),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account settings updated successfully!')),
              );
            },
            child: const Text(
              'Save Changes',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ),
      ],
    );
  }

  // 3. Notification View
  Widget _buildNotificationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Notification Preferences',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text('Email Notification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text('Receive update about quizzes and event.',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
          value: true,
          activeColor: const Color(0xFF2563EB),
          onChanged: (val) {},
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Device Notification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text('Receive Notification from your device.',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
          value: true,
          activeColor: const Color(0xFF2563EB),
          onChanged: (val) {},
        ),
      ],
    );
  }

  // 4. Security View
  Widget _buildSecurityView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Change Password',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 16),
        _buildTextFieldLabel('Current Password'),
        const SizedBox(height: 6),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter Current Password',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextFieldLabel('New Password'),
        const SizedBox(height: 6),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Enter New Password',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 12),
        _buildTextFieldLabel('Confirm New Password'),
        const SizedBox(height: 6),
        const TextField(
          obscureText: true,
          decoration: InputDecoration(
            hintText: 'Confirm New Password',
            hintStyle: TextStyle(fontSize: 12, color: Colors.grey),
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.all(12),
          ),
        ),
        const SizedBox(height: 20),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF047857),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          ),
          onPressed: () {},
          child: const Text('Change Password',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        ),
      ],
    );
  }

  Widget _buildTextFieldLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontWeight: FontWeight.bold,
        fontSize: 12,
        color: Colors.black87,
      ),
    );
  }

  InputDecoration _inputDecoration(String hint, IconData icon) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(fontSize: 12, color: Colors.grey),
      prefixIcon: Icon(icon, size: 18, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
    );
  }

  Widget _buildSettingsMenuItem(IconData icon, String title, int menuIndex) {
    bool isSelected = _selectedMenuIndex == menuIndex;
    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFDBEAFE) : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? const Color(0xFF2563EB) : Colors.black87,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF2563EB) : Colors.black87,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        dense: true,
        onTap: () {
          setState(() {
            _selectedMenuIndex = menuIndex;
          });
        },
      ),
    );
  }

  Widget _buildInfoCard(
    String title,
    String value,
    IconData icon,
    Color color, {
    String sub = '',
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          if (sub.isNotEmpty)
            Text(sub, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
