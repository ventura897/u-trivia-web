import 'package:flutter/material.dart';

import 'login_page.dart'; // I-import ang iyong login.dart file

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  int _selectedSettingIndex =
      0; // 0: Profile, 1: Account, 2: Notification, 3: Security

  // Controllers para sa Account Setting inputs
  final TextEditingController _fullNameController =
      TextEditingController(text: 'Patrick Marquez');
  final TextEditingController _studentIdController =
      TextEditingController(text: '2023-01428');
  final TextEditingController _infoController = TextEditingController(
      text: 'CITE - Bachelor of Science in Information Technology');

  // Notification toggles
  bool _emailNotif = true;
  bool _deviceNotif = true;

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'LOG OUT',
            textAlign: TextAlign.center,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          content: const Text(
            'Are you sure you want to log out of your account?',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey, fontSize: 14),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // 1. Isara muna ang dialog
                Navigator.pop(dialogContext);

                // 2. Pumunta sa LoginPage at linisin ang buong route stack
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginPage()),
                  (route) => false,
                );
              },
              child: const Text('YES',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(width: 12),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('NO',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Row(
        children: [
          // Left Sidebar kasama ang Log Out button sa ibaba
          if (isDesktop)
            Container(
              width: 260,
              color: Colors.white,
              child: _buildSidebarContent(context),
            ),

          // Main Content Area
          Expanded(
            child: Column(
              children: [
                _buildHeader(context, isDesktop),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Settings',
                          style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Customize your preferences and manage your account.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        Expanded(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Settings Navigation Menu (Left Box)
                              Container(
                                width: 220,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border:
                                      Border.all(color: Colors.grey.shade200),
                                ),
                                child: Column(
                                  children: [
                                    _settingMenuButton(
                                        0, Icons.person, 'Profile'),
                                    _settingMenuButton(1, Icons.manage_accounts,
                                        'Account setting'),
                                    _settingMenuButton(
                                        2, Icons.notifications, 'Notification'),
                                    _settingMenuButton(
                                        3, Icons.security, 'Security'),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 24),
                              // Settings Dynamic Content (Right Box)
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(24),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border:
                                        Border.all(color: Colors.grey.shade200),
                                  ),
                                  child: _buildSelectedSettingContent(),
                                ),
                              ),
                            ],
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
      drawer: isDesktop
          ? null
          : Drawer(
              child: _buildSidebarContent(context),
            ),
    );
  }

  // Sidebar Content kasama ang Log Out Button sa ibaba
  Widget _buildSidebarContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(24.0),
          child: Row(
            children: const [
              Icon(Icons.school, color: Colors.blue, size: 32),
              SizedBox(width: 12),
              Text(
                'U-TRIVIA',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87),
              ),
            ],
          ),
        ),
        const Divider(height: 1),
        Expanded(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              _sidebarItem(context, Icons.dashboard, 'Dashboard', false),
              _sidebarItem(
                  context, Icons.calendar_today, 'Daily trivia', false),
              _sidebarItem(context, Icons.trending_up, 'My Progress', false),
              _sidebarItem(context, Icons.leaderboard, 'Leaderboard', false),
              _sidebarItem(context, Icons.history, 'Activity History', false),
              _sidebarItem(context, Icons.settings, 'Settings', true),
            ],
          ),
        ),
        // Log Out Button sa ibaba ng Sidebar
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () => _showLogoutDialog(context),
              icon: const Icon(Icons.logout, size: 18),
              label: const Text('LOG OUT',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ),
        ),
      ],
    );
  }

  Widget _sidebarItem(
      BuildContext context, IconData icon, String title, bool isSelected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading:
            Icon(icon, color: isSelected ? Colors.blue[800] : Colors.grey[700]),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue[800] : Colors.grey[800],
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () {
          if (title == 'Dashboard' ||
              title == 'Daily trivia' ||
              title == 'My Progress' ||
              title == 'Leaderboard' ||
              title == 'Activity History') {
            Navigator.pop(context); // Bumalik sa DashboardScreen
          }
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          Expanded(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search quiz, events, or challenges ......',
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
                  prefixIcon:
                      const Icon(Icons.search, size: 20, color: Colors.grey),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none, size: 24, color: Colors.black87),
          const SizedBox(width: 20),
          Row(
            children: const [
              CircleAvatar(
                backgroundColor: Colors.green,
                child: Text('P', style: TextStyle(color: Colors.white)),
              ),
              SizedBox(width: 8),
              Text('Patrick Marquez',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87)),
              Icon(Icons.arrow_drop_down, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }

  Widget _settingMenuButton(int index, IconData icon, String title) {
    bool isSelected = _selectedSettingIndex == index;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedSettingIndex = index;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? Colors.blue[50] : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(icon,
                size: 20,
                color: isSelected ? Colors.blue[800] : Colors.grey[700]),
            const SizedBox(width: 12),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.blue[800] : Colors.grey[800],
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedSettingContent() {
    switch (_selectedSettingIndex) {
      case 0:
        return _buildProfileView();
      case 1:
        return _buildAccountSettingView();
      case 2:
        return _buildNotificationView();
      case 3:
        return _buildSecurityView();
      default:
        return Container();
    }
  }

  Widget _buildProfileView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Profile',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        Row(
          children: [
            Stack(
              children: [
                const CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.green,
                  child: Text('P',
                      style: TextStyle(fontSize: 32, color: Colors.white)),
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    radius: 14,
                    backgroundColor: Colors.white,
                    child: const Icon(Icons.camera_alt,
                        size: 14, color: Colors.black87),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(_fullNameController.text,
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(width: 16),
                    Text('CITE',
                        style: TextStyle(
                            color: Colors.grey[700],
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                const SizedBox(height: 4),
                const Text('example@gmail.com',
                    style: TextStyle(color: Colors.grey)),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text('Level 1 Beginner',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 12,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 30),
        Row(
          children: [
            _statCard('Total Points', '150', Icons.star, Colors.orange),
            const SizedBox(width: 16),
            _statCard('Quizzes Completed', '3', Icons.book, Colors.blue),
            const SizedBox(width: 16),
            _statCard('Campus Rank', '#11', Icons.emoji_events, Colors.amber,
                subtitle: 'Top 5% of students'),
          ],
        ),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon, Color color,
      {String? subtitle}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: const TextStyle(fontSize: 12, color: Colors.grey)),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 8),
            Text(value,
                style:
                    const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(subtitle,
                  style: const TextStyle(fontSize: 10, color: Colors.grey)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildAccountSettingView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Account setting',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        _buildTextFieldRow('Full Name', _fullNameController),
        const SizedBox(height: 16),
        _buildTextFieldRow('Student ID', _studentIdController),
        const SizedBox(height: 16),
        _buildTextFieldRow('Info / Course', _infoController),
        const SizedBox(height: 24),
        Align(
          alignment: Alignment.centerLeft,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue[800],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () {
              setState(() {});
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Account details updated successfully!')),
              );
            },
            child: const Text('Save Changes'),
          ),
        ),
      ],
    );
  }

  Widget _buildTextFieldRow(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black87)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildNotificationView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Notification Preferences',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 20),
        SwitchListTile(
          title: const Text('Email Notification',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Receive update about quizzes and event.',
              style: TextStyle(fontSize: 12)),
          value: _emailNotif,
          activeThumbColor: Colors.blue,
          onChanged: (val) => setState(() => _emailNotif = val),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Device Notification',
              style: TextStyle(fontWeight: FontWeight.bold)),
          subtitle: const Text('Receive Notification from your device.',
              style: TextStyle(fontSize: 12)),
          value: _deviceNotif,
          activeThumbColor: Colors.blue,
          onChanged: (val) => setState(() => _deviceNotif = val),
        ),
      ],
    );
  }

  Widget _buildSecurityView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Change Password',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        _buildPasswordField('Current Password'),
        const SizedBox(height: 12),
        _buildPasswordField('New Password'),
        const SizedBox(height: 12),
        _buildPasswordField('Confirm New Password'),
        const SizedBox(height: 16),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green[700],
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {},
          child: const Text('Change Password'),
        ),
      ],
    );
  }

  Widget _buildPasswordField(String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        const SizedBox(height: 4),
        TextField(
          obscureText: true,
          decoration: InputDecoration(
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
      ],
    );
  }
}
