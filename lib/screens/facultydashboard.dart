import 'package:flutter/material.dart';

import 'quizlet.dart';
import 'settingsfaculty.dart';
import 'student.dart';

class FacultyDashboard extends StatefulWidget {
  const FacultyDashboard({super.key});

  @override
  State<FacultyDashboard> createState() => _FacultyDashboardState();
}

class _FacultyDashboardState extends State<FacultyDashboard> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    if (index == 0) return; // Already on dashboard
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const StudentPage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SettingsFacultyPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Row(
        children: [
          // Sidebar Navigation
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
                      Text(
                        'U-TRIVIA',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sidebarItem(Icons.dashboard, 'Dashboard', 0, true),
                _sidebarItem(Icons.people, 'Students', 1, false),
                _sidebarItem(Icons.settings, 'Settings', 2, false),
              ],
            ),
          ),
          // Main Content Area
          Expanded(
            child: Column(
              children: [
                // Top Navbar
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
                        child: Text('I', style: TextStyle(color: Colors.white)),
                      ),
                      SizedBox(width: 10),
                      Text('Ivana Cruz',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                // Dashboard Body
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: const [
                            Text(
                              'Hello, Mrs Ivana!',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 10),
                            Text('👋', style: TextStyle(fontSize: 28)),
                          ],
                        ),
                        const Text(
                          'Saturday, September 6 2026',
                          style: TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            // Total Students Card
                            Container(
                              width: 220,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.group_outlined,
                                      size: 28, color: Colors.blue),
                                  const SizedBox(height: 10),
                                  const Text('Total Students',
                                      style: TextStyle(color: Colors.grey)),
                                  const SizedBox(height: 5),
                                  const Text('1,200',
                                      style: TextStyle(
                                          fontSize: 24,
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 10),
                                  const Text('+12 this week',
                                      style: TextStyle(
                                          color: Colors.green, fontSize: 12)),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Leaderboard Card
                            Container(
                              width: 250,
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.emoji_events_outlined,
                                      size: 28, color: Colors.orange),
                                  const SizedBox(height: 10),
                                  const Text('View Quiz Leaderboards',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 15),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey[200],
                                      foregroundColor: Colors.black,
                                      elevation: 0,
                                    ),
                                    onPressed: () {},
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: const [
                                        Text('View'),
                                        SizedBox(width: 5),
                                        Icon(Icons.arrow_forward, size: 16),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 20),
                            // Action Buttons
                            Column(
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const QuizletPage()),
                                    );
                                  },
                                  icon:
                                      const Icon(Icons.add, color: Colors.blue),
                                  label: const Text('Create Quiz'),
                                ),
                                const SizedBox(height: 15),
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    foregroundColor: Colors.black,
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 24, vertical: 16),
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                  onPressed: () {},
                                  icon:
                                      const Icon(Icons.add, color: Colors.blue),
                                  label: const Text('Create Challenge'),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        // Recent Quiz Activity Table
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Recent Quiz Activity',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 15),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Student',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('Quiz',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('Score',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('Date',
                                      style: TextStyle(color: Colors.grey)),
                                  Text('Status',
                                      style: TextStyle(color: Colors.grey)),
                                ],
                              ),
                              const Divider(),
                              ...List.generate(
                                  5,
                                  (index) => Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 15.0),
                                        child: Container(
                                            height: 1, color: Colors.grey[300]),
                                      )),
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

  Widget _sidebarItem(IconData icon, String title, int index, bool selected) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.black54),
        title: Text(
          title,
          style: TextStyle(
            color: selected ? Colors.blue : Colors.black87,
            fontWeight: selected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: () => _onItemTapped(index),
      ),
    );
  }
}
