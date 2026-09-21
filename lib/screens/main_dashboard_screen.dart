import 'package:flutter/material.dart';

import 'login_screen.dart';

class MainDashboardScreen extends StatefulWidget {
  const MainDashboardScreen({super.key});

  @override
  State<MainDashboardScreen> createState() => _MainDashboardScreenState();
}

class _MainDashboardScreenState extends State<MainDashboardScreen> {
  final ScrollController _scrollController = ScrollController();

  // Keys para sa bawat section para malaman kung saan magse-scroll
  final GlobalKey _dashboardKey = GlobalKey();
  final GlobalKey _dailyTriviaKey = GlobalKey();
  final GlobalKey _myProgressKey = GlobalKey();
  final GlobalKey _leaderboardKey = GlobalKey();
  final GlobalKey _activityHistoryKey = GlobalKey();
  final GlobalKey _settingsKey = GlobalKey();

  int selectedIndex = 0;

  void _scrollToSection(GlobalKey key, int index) {
    setState(() {
      selectedIndex = index;
    });
    final context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // SIDEBAR NAVIGATION
          Container(
            width: 250,
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo & Header
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Container(
                        width: 35,
                        height: 35,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.blueAccent,
                        ),
                        child: const Center(
                          child: Text(
                            'U',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'U-TRIVIA',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),

                // Sidebar Menu Items
                _buildNavItem(
                  Icons.dashboard,
                  'Dashboard',
                  0,
                  () => _scrollToSection(_dashboardKey, 0),
                ),
                _buildNavItem(
                  Icons.calendar_today,
                  'Daily trivia',
                  1,
                  () => _scrollToSection(_dailyTriviaKey, 1),
                ),
                _buildNavItem(
                  Icons.trending_up,
                  'My Progress',
                  2,
                  () => _scrollToSection(_myProgressKey, 2),
                ),
                _buildNavItem(
                  Icons.leaderboard,
                  'Leaderboard',
                  3,
                  () => _scrollToSection(_leaderboardKey, 3),
                ),
                _buildNavItem(
                  Icons.history,
                  'Activity History',
                  4,
                  () => _scrollToSection(_activityHistoryKey, 4),
                ),
                _buildNavItem(
                  Icons.settings,
                  'Settings',
                  5,
                  () => _scrollToSection(_settingsKey, 5),
                ),

                const Spacer(),

                // Install App Box (Figma Design)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Install our app',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Add U-Trivia to your home screen for quick access!',
                          style: TextStyle(fontSize: 10, color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        SizedBox(
                          width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey.shade300,
                              elevation: 0,
                            ),
                            onPressed: () {},
                            child: const Text(
                              'Install Now',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.black87,
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

          const VerticalDivider(width: 1),

          // MAIN CONTENT AREA (Scrollable with multiple sections)
          Expanded(
            child: Column(
              children: [
                // Top Appbar Header
                Container(
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade300),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.search, size: 18, color: Colors.grey),
                              SizedBox(width: 8),
                              Text(
                                'Search quiz, events, or challenges ......',
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      const Icon(
                        Icons.notifications_none,
                        color: Colors.black87,
                      ),
                      const SizedBox(width: 20),
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 16,
                            backgroundColor: Colors.green.shade700,
                            child: const Text(
                              'P',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Patrick Marquez',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ],
                  ),
                ),

                const Divider(height: 1),

                // Scrollable Body containing all views/sections
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // SECTION 1: DASHBOARD
                        Container(
                          key: _dashboardKey,
                          child: _buildDashboardSection(),
                        ),
                        const SizedBox(height: 60),

                        // SECTION 2: DAILY TRIVIA
                        Container(
                          key: _dailyTriviaKey,
                          child: _buildDailyTriviaSection(),
                        ),
                        const SizedBox(height: 60),

                        // SECTION 3: MY PROGRESS
                        Container(
                          key: _myProgressKey,
                          child: _buildMyProgressSection(),
                        ),
                        const SizedBox(height: 60),

                        // SECTION 4: LEADERBOARD
                        Container(
                          key: _leaderboardKey,
                          child: _buildLeaderboardSection(),
                        ),
                        const SizedBox(height: 60),

                        // SECTION 5: ACTIVITY HISTORY
                        Container(
                          key: _activityHistoryKey,
                          child: _buildActivityHistorySection(),
                        ),
                        const SizedBox(height: 60),

                        // SECTION 6: SETTINGS
                        Container(
                          key: _settingsKey,
                          child: _buildSettingsSection(context),
                        ),
                        const SizedBox(height: 100),
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

  Widget _buildNavItem(
    IconData icon,
    String title,
    int index,
    VoidCallback onTap,
  ) {
    bool isSelected = selectedIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isSelected ? Colors.blue.shade700 : Colors.grey.shade700,
          size: 20,
        ),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.blue.shade900 : Colors.grey.shade800,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            fontSize: 13,
          ),
        ),
        onTap: onTap,
        dense: true,
      ),
    );
  }

  // UI Component para sa Dashboard
  Widget _buildDashboardSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Welcome, Patrick!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Ready to learn something new today?',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            _buildStatCard('Total Points', '150', Colors.blue.shade50),
            const SizedBox(width: 16),
            _buildStatCard(
              'Quick Play',
              'Random quiz to test knowledge',
              Colors.purple.shade50,
              isAction: true,
            ),
            const SizedBox(width: 16),
            _buildStatCard('Quizzes Completed', '3', Colors.orange.shade50),
            const SizedBox(width: 16),
            _buildStatCard(
              'Campus Rank',
              '#11',
              Colors.green.shade50,
              subtitle: 'Top 5% of students',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String title,
    String value,
    Color color, {
    bool isAction = false,
    String? subtitle,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: isAction ? 14 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // UI Component para sa Daily Trivia
  Widget _buildDailyTriviaSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.black87),
            SizedBox(width: 10),
            Text(
              'Daily Trivia',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        const Text(
          'Learn something new today',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 20),
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'What is the chemical symbol of water?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              _buildChoiceButton('A', 'O2', false),
              _buildChoiceButton('B', 'H2O', true),
              _buildChoiceButton('C', 'CO2', false),
              _buildChoiceButton('D', 'HO', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildChoiceButton(String letter, String text, bool isSelected) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isSelected ? Colors.green.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isSelected ? Colors.green : Colors.grey.shade300,
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 12,
            backgroundColor: isSelected ? Colors.green : Colors.grey.shade200,
            child: Text(
              letter,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? Colors.white : Colors.black87,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  // UI Component para sa My Progress
  Widget _buildMyProgressSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'My Progress',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Track your level status and earned points here.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  // UI Component para sa Leaderboard
  Widget _buildLeaderboardSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Leaderboard',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'See top performing students across campus.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      ],
    );
  }

  // UI Component para sa Activity History
  Widget _buildActivityHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          children: [
            Text(
              'Activity History',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(width: 8),
            Icon(Icons.history, size: 22),
          ],
        ),
        const Text(
          'Track your recent activities and quiz attempts.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: const ListTile(
            title: Text('August 1, 2026 - Completed Daily Trivia'),
            subtitle: Text('Score: 100%'),
            trailing: Text(
              '+150 pts',
              style: TextStyle(
                color: Colors.green,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // UI Component para sa Settings
  Widget _buildSettingsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Settings',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        const Text(
          'Customize your preferences ang manage your account.',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
        const SizedBox(height: 20),
        SizedBox(
          width: 150,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepOrange,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
            icon: const Icon(Icons.logout, size: 16),
            label: const Text('LOG OUT'),
          ),
        ),
      ],
    );
  }
}
