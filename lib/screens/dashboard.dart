import 'package:flutter/material.dart';

import 'activityhistory.dart';
import 'dailytrivia.dart';
import 'leaderboard.dart';
import 'myprogress.dart';
import 'settings.dart';

void main() {
  runApp(const UTriviaApp());
}

class UTriviaApp extends StatelessWidget {
  const UTriviaApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'U-TRIVIA',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF3F4F6),
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: const DashboardScreen(),
    );
  }
}

class Sidebar extends StatelessWidget {
  final int currentIndex;
  const Sidebar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 240,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo & Title
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFF1E3A8A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Center(
                  child: Text(
                    'U',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              const Text(
                'U-TRIVIA',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),

          // Navigation Items
          _buildNavItem(
            context,
            Icons.dashboard,
            'Dashboard',
            0,
            const DashboardScreen(),
          ),
          _buildNavItem(
            context,
            Icons.calendar_today,
            'Daily trivia',
            1,
            const DailyTriviaScreen(),
          ),
          _buildNavItem(
            context,
            Icons.bar_chart,
            'My Progress',
            2,
            const MyProgressScreen(),
          ),
          _buildNavItem(
            context,
            Icons.leaderboard,
            'Leaderboard',
            3,
            const LeaderboardScreen(),
          ),
          _buildNavItem(
            context,
            Icons.history,
            'Activity History',
            4,
            const ActivityHistoryScreen(),
          ),
          _buildNavItem(
            context,
            Icons.settings,
            'Settings',
            5,
            const SettingsScreen(),
          ),

          const Spacer(),

          // Install App Widget
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Row(
                  children: [
                    Icon(Icons.phone_iphone, size: 20, color: Colors.black54),
                    SizedBox(width: 8),
                    Text(
                      'Install our app',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  'Add U-Trivia to your home screen for quick access!',
                  style: TextStyle(fontSize: 10, color: Colors.black54),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD1FAE5),
                      foregroundColor: const Color(0xFF065F46),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6),
                      ),
                    ),
                    onPressed: () {},
                    child: const Text(
                      'Install Now',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                      ),
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
    BuildContext context,
    IconData icon,
    String title,
    int index,
    Widget targetScreen,
  ) {
    bool isSelected = currentIndex == index;
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
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
            fontSize: 14,
          ),
        ),
        dense: true,
        onTap: () {
          if (!isSelected) {
            Navigator.pushReplacement(
              context,
              PageRouteBuilder(
                pageBuilder: (context, anim1, anim2) => targetScreen,
                transitionsBuilder: (context, anim1, anim2, child) => child,
              ),
            );
          }
        },
      ),
    );
  }
}

class TopHeader extends StatelessWidget {
  const TopHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      color: Colors.white,
      child: Row(
        children: [
          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: const [
                  Icon(Icons.search, color: Colors.grey, size: 20),
                  SizedBox(width: 8),
                  Text(
                    'Search quiz, events, or challenges ......',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          const Icon(Icons.notifications_none, color: Colors.black87),
          const SizedBox(width: 16),
          Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: const Color(0xFF047857),
                child: const Text(
                  'P',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Text(
                'Patrick Marquez',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down,
                  size: 18, color: Colors.black87),
            ],
          ),
        ],
      ),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentIndex: 0),
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
                        // Welcome Banner
                        Row(
                          children: const [
                            Text(
                              'Welcome, Patrick!',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(width: 8),
                            Text('👋', style: TextStyle(fontSize: 24)),
                          ],
                        ),
                        const Text(
                          'Ready to learn something new today?',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // Top Stats Row
                        Row(
                          children: [
                            // Total Points Card
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.amber.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.star,
                                          color: Colors.amber,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Total Points',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),
                                    const Text(
                                      '150',
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const Text(
                                      'Keep it up!',
                                      style: TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Quick Play Card
                            Expanded(
                              flex: 3,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF3E8FF),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.flash_on,
                                          color: Colors.purple,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Quick Play',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      'Random quiz to test your knowledge and earn points.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: Colors.black54,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Text(
                                            'Click to play',
                                            style: TextStyle(
                                              fontSize: 11,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                          SizedBox(width: 4),
                                          Icon(Icons.arrow_forward,
                                              size: 14, color: Colors.black87),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Quizzes Completed Card
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.blue.shade100,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Quizzes Completed',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.assignment,
                                          color: Colors.blue,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          '3',
                                          style: TextStyle(
                                            fontSize: 28,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Campus Rank Card
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE0F2FE),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: const [
                                        Icon(
                                          Icons.emoji_events,
                                          color: Colors.orange,
                                          size: 24,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Campus Rank',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    const Text(
                                      '#11',
                                      style: TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black87,
                                      ),
                                    ),
                                    const Text(
                                      'Top 5% of students',
                                      style: TextStyle(
                                        fontSize: 9,
                                        color: Colors.black54,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Middle Grid & Progress Right Side
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left 2 Columns Grid
                            Expanded(
                              flex: 3,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFeatureCard(
                                          'Weekly Challenge',
                                          'Special quiz/challenge every week.',
                                          'Take Challenge',
                                          Icons.track_changes,
                                          Colors.red,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildFeatureCard(
                                          'University and Academic Quizzes',
                                          'Test your knowledge with quizzes',
                                          'Start Quiz',
                                          Icons.account_balance,
                                          Colors.indigo,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildFeatureCard(
                                          'Badges and Achievements',
                                          'Unlock badges and show your achievements.',
                                          'View',
                                          Icons.military_tech,
                                          Colors.grey,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: _buildFeatureCard(
                                          'Points and Scoring',
                                          'Earn points and level up your rank',
                                          'View',
                                          Icons.star_border,
                                          Colors.amber,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Right Progress Box
                            Expanded(
                              flex: 2,
                              child: Container(
                                padding: const EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: Colors.grey.shade200,
                                  ),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Your Progress',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          'View details',
                                          style: TextStyle(
                                            color: Color(0xFF047857),
                                            fontSize: 11,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Level 1',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.black87,
                                          ),
                                        ),
                                        Text(
                                          '300 / 1000 PTS',
                                          style: TextStyle(
                                            fontSize: 11,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 10),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: 0.29,
                                        minHeight: 12,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                          Color(0xFFA3E635),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '29%',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 10),
                                    const Center(
                                      child: Text(
                                        'Keep earning points to level up!',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Recent Achievements Section
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Recent Achievements',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      color: Colors.black87,
                                    ),
                                  ),
                                  Text(
                                    'View all',
                                    style: TextStyle(
                                      color: Color(0xFF047857),
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _buildAchievementItem(
                                'Completed University History Quiz',
                                '+ 150 pts',
                              ),
                              _buildAchievementItem(
                                'Completed Daily Learning Challenge',
                                '+ 150 pts',
                              ),
                              _buildAchievementItem(
                                'Completed University History Quiz',
                                '+ 150 pts',
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
    );
  }

  Widget _buildFeatureCard(
    String title,
    String subtitle,
    String actionText,
    IconData icon,
    Color iconColor,
  ) {
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
              Icon(icon, color: iconColor, size: 24),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Text(
                actionText,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2563EB),
                ),
              ),
              const SizedBox(width: 4),
              const Icon(Icons.arrow_forward,
                  size: 14, color: Color(0xFF2563EB)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String points) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.military_tech, color: Colors.amber, size: 20),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          Text(
            points,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Color(0xFF047857),
            ),
          ),
        ],
      ),
    );
  }
}
