import 'package:flutter/material.dart';

import '../services/auth_service.dart'; // Firebase logout / change password
import '../services/user_service.dart'; // Firebase profile data
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
  // (Napupunan ng data galing Firebase pagka-load ng screen)
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();

  // Controllers para sa Security (Change Password)
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  // Firebase
  final UserService _userService = UserService();
  final AuthService _authService = AuthService();
  UserProfile? _profile; // Data ng naka-login na user galing Firebase
  bool _isLoading = true;
  String? _loadError;
  bool _isSaving = false;
  bool _isChangingPassword = false;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _birthdateController.dispose();
    _courseController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  // Kinukuha ang bagong data mula sa Firebase tuwing bubuksan ang Settings
  Future<void> _loadProfile() async {
    try {
      final profile = await _userService.loadProfile();
      if (!mounted) return;
      setState(() {
        _profile = profile;
        _nameController.text = profile.name;
        _emailController.text = profile.email;
        _phoneController.text = profile.phone;
        _birthdateController.text = profile.birthdate;
        _courseController.text = profile.course;
        _loadError = null;
        _isLoading = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _loadError =
            'Could not load your settings. Please check your connection and try again.';
        _isLoading = false;
      });
    }
  }

  void _retryLoad() {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    _loadProfile();
  }

  void _showMessage(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : null,
      ),
    );
  }

  // I-save ang Account Settings sa Firebase (users/{uid})
  Future<void> _saveAccountSettings() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final phone = _phoneController.text.trim();
    final birthdate = _birthdateController.text.trim();
    final course = _courseController.text.trim();

    if (name.isEmpty) {
      _showMessage('Please enter your full name.', isError: true);
      return;
    }
    if (email.isNotEmpty &&
        !RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showMessage('Please enter a valid email address.', isError: true);
      return;
    }
    if (phone.isNotEmpty &&
        !RegExp(r'^\+?[0-9][0-9\s\-()]{6,}$').hasMatch(phone)) {
      _showMessage('Please enter a valid phone number.', isError: true);
      return;
    }
    if (course.isEmpty) {
      _showMessage('Please enter your course.', isError: true);
      return;
    }

    setState(() => _isSaving = true);
    try {
      await _userService.updateAccountInfo(
        name: name,
        email: email,
        phone: phone,
        birthdate: birthdate,
        course: course,
      );
      if (!mounted) return;
      setState(() {
        _profile = _profile!.copyWith(
          name: name,
          email: email,
          phone: phone,
          birthdate: birthdate,
          course: course,
        );
      });
      _showMessage('Account settings updated successfully!');
    } catch (_) {
      _showMessage('Could not save your changes. Please try again.',
          isError: true);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  // I-save agad ang Notification switches
  Future<void> _toggleNotification({bool? email, bool? device}) async {
    final previous = _profile!;
    setState(() {
      _profile = previous.copyWith(
        emailNotifications: email,
        deviceNotifications: device,
      );
    });
    try {
      await _userService.updateNotificationSettings(
          email: email, device: device);
    } catch (_) {
      if (!mounted) return;
      setState(() => _profile = previous); // ibalik kung hindi na-save
      _showMessage('Could not save your notification setting.', isError: true);
    }
  }

  // Change Password (Firebase Authentication)
  Future<void> _changePassword() async {
    final current = _currentPasswordController.text;
    final newPassword = _newPasswordController.text;
    final confirm = _confirmPasswordController.text;

    if (current.isEmpty || newPassword.isEmpty || confirm.isEmpty) {
      _showMessage('Please fill in all password fields.', isError: true);
      return;
    }
    if (newPassword.length < 6) {
      _showMessage('New password must be at least 6 characters long.',
          isError: true);
      return;
    }
    if (newPassword != confirm) {
      _showMessage('New password and confirmation do not match.',
          isError: true);
      return;
    }
    if (newPassword == current) {
      _showMessage('New password must be different from your current one.',
          isError: true);
      return;
    }

    setState(() => _isChangingPassword = true);
    try {
      await _authService.changePassword(
        currentPassword: current,
        newPassword: newPassword,
      );
      _currentPasswordController.clear();
      _newPasswordController.clear();
      _confirmPasswordController.clear();
      _showMessage('Password changed successfully!');
    } on AuthException catch (e) {
      _showMessage(e.message, isError: true);
    } catch (_) {
      _showMessage('Could not change your password. Please try again.',
          isError: true);
    } finally {
      if (mounted) setState(() => _isChangingPassword = false);
    }
  }

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
              onPressed: () async {
                Navigator.of(context).pop(); // Isara muna ang dialog
                // Mag-sign out muna sa Firebase
                try {
                  await _authService.logout();
                } catch (_) {
                  _showMessage('Could not log out. Please try again.',
                      isError: true);
                  return;
                }
                if (!mounted) return;
                // Pumunta sa Login Page at i-clear ang buong stack para hindi na makabalik sa dashboard nang walang login
                Navigator.pushAndRemoveUntil(
                  this.context,
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
    // Kung walang naka-login, ibalik sa Login page.
    if (!_userService.isLoggedIn) return const LoginPage();

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
    if (_isLoading) {
      return const Padding(
        padding: EdgeInsets.all(24),
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (_loadError != null || _profile == null) {
      return Column(
        children: [
          Text(
            _loadError ?? 'Could not load your settings.',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: _retryLoad, child: const Text('Retry')),
        ],
      );
    }

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
    final profile = _profile!;
    final initial =
        profile.name.isNotEmpty ? profile.name[0].toUpperCase() : '';
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
                CircleAvatar(
                  radius: 36,
                  backgroundColor: const Color(0xFF047857),
                  child: Text(
                    initial,
                    style: const TextStyle(
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
                  children: [
                    Text(
                      profile.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      profile.department,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  profile.email.isNotEmpty
                      ? profile.email
                      : 'No email added yet',
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
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
                  child: Text(
                    'Level ${profile.level} ${profile.levelTitle}',
                    style: const TextStyle(
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
                '${profile.points}',
                Icons.star,
                Colors.amber,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Quizzes Completed',
                '${profile.quizzesCompleted}',
                Icons.assignment,
                Colors.blue,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildInfoCard(
                'Campus Rank',
                profile.rank == null ? '#-' : '#${profile.rank}',
                Icons.emoji_events,
                Colors.orange,
                sub: 'Top ${profile.topPercent ?? '-'}% of students',
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
            onPressed: _isSaving ? null : _saveAccountSettings,
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
          value: _profile!.emailNotifications,
          activeColor: const Color(0xFF2563EB),
          onChanged: (val) => _toggleNotification(email: val),
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Device Notification',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          subtitle: const Text('Receive Notification from your device.',
              style: TextStyle(fontSize: 11, color: Colors.grey)),
          value: _profile!.deviceNotifications,
          activeColor: const Color(0xFF2563EB),
          onChanged: (val) => _toggleNotification(device: val),
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
        TextField(
          controller: _currentPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
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
        TextField(
          controller: _newPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
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
        TextField(
          controller: _confirmPasswordController,
          obscureText: true,
          decoration: const InputDecoration(
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
          onPressed: _isChangingPassword ? null : _changePassword,
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
