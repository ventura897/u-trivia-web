import 'package:flutter/material.dart';

import 'settings.dart'; // I-import ang iyong settings.dart file

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedIndex = 0;

  // Controller para kontrolin ang pag-scroll ng buong pahina
  final ScrollController _scrollController = ScrollController();

  // Function para i-scroll ang screen o buksan ang Settings screen
  void _scrollToSection(int index, BuildContext context) {
    // Kapag Settings ang pinindot (Index 5)
    if (index == 5) {
      // Isara muna ang drawer kung nasa mobile view
      if (MediaQuery.of(context).size.width <= 900 &&
          Navigator.canPop(context)) {
        Navigator.pop(context);
      }

      // Pumunta sa Settings screen mula sa settings.dart
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                const SettingsScreen()), // Palitan ang 'SettingsScreen' kung iba ang pangalan ng class sa settings.dart mo
      );
      return;
    }

    setState(() {
      _selectedIndex = index;
    });

    double targetOffset = 0.0;

    // Tinatayang posisyon (offset in pixels) ng bawat seksyon pababa
    switch (index) {
      case 0:
        targetOffset = 0.0; // Dashboard
        break;
      case 1:
        targetOffset = 450.0; // Daily Trivia
        break;
      case 2:
        targetOffset = 900.0; // My Progress
        break;
      case 3:
        targetOffset = 1250.0; // Leaderboard
        break;
      case 4:
        targetOffset = 1600.0; // Activity History
        break;
    }

    _scrollController.animateTo(
      targetOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 900;

    return Scaffold(
      backgroundColor: Colors.grey[50], // Light view background
      body: Row(
        children: [
          // Sidebar para sa Desktop view
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
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDashboardView(),
                        const SizedBox(height: 40),
                        _buildDailyTriviaView(),
                        const SizedBox(height: 40),
                        _buildMyProgressView(),
                        const SizedBox(height: 40),
                        _buildLeaderboardView(),
                        const SizedBox(height: 40),
                        _buildActivityHistoryView(),
                        const SizedBox(height: 40),
                        const Center(
                          child: Text(
                              'Settings page is accessible via sidebar.',
                              style:
                                  TextStyle(color: Colors.grey, fontSize: 16)),
                        ),
                        const SizedBox(
                            height:
                                100), // Dagdag allowance sa pinakadulo para makapag-scroll nang maayos
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
              _sidebarItem(context, 0, Icons.dashboard, 'Dashboard'),
              _sidebarItem(context, 1, Icons.calendar_today, 'Daily trivia'),
              _sidebarItem(context, 2, Icons.trending_up, 'My Progress'),
              _sidebarItem(context, 3, Icons.leaderboard, 'Leaderboard'),
              _sidebarItem(context, 4, Icons.history, 'Activity History'),
              _sidebarItem(context, 5, Icons.settings, 'Settings'),
            ],
          ),
        ),
        // Install App Card sa baba ng sidebar
        Padding(
          padding: const EdgeInsets.all(16.0),
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
                const Text('Install our app',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.black87)),
                const SizedBox(height: 4),
                const Text('Add U-Trivia to your home screen for quick access!',
                    style: TextStyle(fontSize: 11, color: Colors.grey)),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue[800],
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    onPressed: () {},
                    child: const Text('Install Now',
                        style: TextStyle(fontSize: 12)),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _sidebarItem(
      BuildContext context, int index, IconData icon, String title) {
    bool isSelected = _selectedIndex == index;
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
          _scrollToSection(index, context);
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
              onPressed: () {
                Scaffold.of(context).openDrawer();
              },
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
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
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

  Widget _buildDashboardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Welcome, Patrick! 👋',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const SizedBox(height: 4),
        const Text('Ready to learn something new today?',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _cardContainer(
              width: 220,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Total Points',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.orange, size: 28),
                      SizedBox(width: 8),
                      Text('150',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                  SizedBox(height: 4),
                  Text('Keep it up!',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                ],
              ),
            ),
            _cardContainer(
              width: 260,
              color: Colors.purple[50],
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Play',
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87)),
                  const SizedBox(height: 4),
                  const Text(
                      'Random quiz to test your knowledge and earn points.',
                      style: TextStyle(fontSize: 11, color: Colors.grey)),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        elevation: 0),
                    onPressed: () {},
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: const [
                        Text('Click to play'),
                        SizedBox(width: 4),
                        Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            _cardContainer(
              width: 200,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text('Quizzes Completed',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(Icons.book, color: Colors.blue, size: 28),
                      SizedBox(width: 8),
                      Text('3',
                          style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.black87)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        LayoutBuilder(
          builder: (context, constraints) {
            return Wrap(
              spacing: 20,
              runSpacing: 20,
              children: [
                SizedBox(
                  width: constraints.maxWidth > 700
                      ? (constraints.maxWidth - 20) / 2
                      : constraints.maxWidth,
                  child: Column(
                    children: [
                      _featureCard(
                          'Weekly Challenge',
                          'Special quiz/challenge every week.',
                          Icons.local_fire_department,
                          'Take Challenge'),
                      const SizedBox(height: 16),
                      _featureCard(
                          'Badges and Achievements',
                          'Unlock badges and show your achievements.',
                          Icons.military_tech,
                          'View'),
                    ],
                  ),
                ),
                SizedBox(
                  width: constraints.maxWidth > 700
                      ? (constraints.maxWidth - 20) / 2
                      : constraints.maxWidth,
                  child: Column(
                    children: [
                      _featureCard(
                          'University and Academic quizzes',
                          'Test your knowledge with quizzes',
                          Icons.account_balance,
                          'Start Quiz'),
                      const SizedBox(height: 16),
                      _featureCard(
                          'Points and Scoring',
                          'Earn points and level up your rank',
                          Icons.star_border,
                          'View'),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ],
    );
  }

  Widget _cardContainer(
      {required double width, required Widget child, Color? color}) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _featureCard(
      String title, String subtitle, IconData icon, String buttonText) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
                color: Colors.red[50], borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: Colors.red),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black87)),
                const SizedBox(height: 4),
                Text(subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const SizedBox(height: 12),
                OutlinedButton(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.blue[800],
                    side: BorderSide(color: Colors.blue.shade200),
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(buttonText, style: const TextStyle(fontSize: 12)),
                      const SizedBox(width: 4),
                      const Icon(Icons.arrow_forward, size: 12),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDailyTriviaView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Daily Trivia',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const Text('Learn something new today',
            style: TextStyle(color: Colors.grey)),
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Question 1 of 5',
                      style: TextStyle(
                          color: Colors.purple, fontWeight: FontWeight.bold)),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                        color: Colors.green[100],
                        borderRadius: BorderRadius.circular(12)),
                    child: const Text('Science',
                        style: TextStyle(
                            color: Colors.green,
                            fontSize: 12,
                            fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Text('What is the chemical symbol of water?',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87)),
              const SizedBox(height: 20),
              _optionTile('A', 'O2', false),
              _optionTile('B', 'H2O', true),
              _optionTile('C', 'CO2', false),
              _optionTile('D', 'HO', false),
            ],
          ),
        ),
      ],
    );
  }

  Widget _optionTile(String letter, String text, bool isCorrect) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: isCorrect ? Colors.green[50] : Colors.white,
        border:
            Border.all(color: isCorrect ? Colors.green : Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          CircleAvatar(
              radius: 14,
              backgroundColor: isCorrect ? Colors.green : Colors.grey[200],
              child: Text(letter,
                  style: TextStyle(
                      color: isCorrect ? Colors.white : Colors.black87,
                      fontSize: 12))),
          const SizedBox(width: 12),
          Text(text,
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  color: isCorrect ? Colors.green[900] : Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildMyProgressView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('My Progress',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const Text('Track your learning journey and achievements.',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            _cardContainer(
                width: 200,
                child: const Text('Total Points: 150',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500))),
            _cardContainer(
                width: 200,
                child: const Text('Quizzes Completed: 3',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500))),
            _cardContainer(
                width: 200,
                child: const Text('Level: 1 / 50',
                    style: TextStyle(
                        color: Colors.black87, fontWeight: FontWeight.w500))),
          ],
        ),
      ],
    );
  }

  Widget _buildLeaderboardView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Leaderboard 🏆',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const Text('Top students based on total points.',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Text('Rank',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Student',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Level',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Points',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('4')),
                DataCell(Text('James Harden')),
                DataCell(Text('3')),
                DataCell(Text('1,300 pts'))
              ]),
              DataRow(cells: [
                DataCell(Text('5')),
                DataCell(Text('Carl Jefferson')),
                DataCell(Text('3')),
                DataCell(Text('1,100 pts'))
              ]),
              DataRow(cells: [
                DataCell(Text('6')),
                DataCell(Text('Jojo Mara Sigan')),
                DataCell(Text('3')),
                DataCell(Text('1,050 pts'))
              ]),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityHistoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Activity History 🕒',
            style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Colors.black87)),
        const Text('Track your recent activities and quiz attempts.',
            style: TextStyle(color: Colors.grey)),
        const SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade200),
          ),
          child: DataTable(
            columns: const [
              DataColumn(
                  label: Text('Date & Time',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Activity',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Types',
                      style: TextStyle(fontWeight: FontWeight.bold))),
              DataColumn(
                  label: Text('Points',
                      style: TextStyle(fontWeight: FontWeight.bold))),
            ],
            rows: const [
              DataRow(cells: [
                DataCell(Text('August 1, 2026')),
                DataCell(Text('Completed Daily Trivia')),
                DataCell(Text('Challenge')),
                DataCell(Text('+150')),
              ]),
            ],
          ),
        ),
      ],
    );
  }
}
