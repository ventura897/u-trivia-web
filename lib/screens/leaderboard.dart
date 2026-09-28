import 'package:flutter/material.dart';

import '../services/user_service.dart'; // Firebase data
import 'dashboard.dart';
import 'login_page.dart';

class LeaderboardScreen extends StatefulWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  State<LeaderboardScreen> createState() => _LeaderboardScreenState();
}

class _LeaderboardScreenState extends State<LeaderboardScreen> {
  final UserService _userService = UserService();

  // Live data mula sa Firebase (nag-a-update kapag may nagbago sa points/quizzes)
  late final Stream<LeaderboardData> _leaderboardStream =
      _userService.leaderboardStream();

  @override
  Widget build(BuildContext context) {
    // Kung walang naka-login, ibalik sa Login page.
    if (!_userService.isLoggedIn) return const LoginPage();

    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentIndex: 3),
          Expanded(
            child: Column(
              children: [
                const TopHeader(),
                Expanded(
                  child: StreamBuilder<LeaderboardData>(
                    stream: _leaderboardStream,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return const Center(
                          child: Text(
                            'Could not load the leaderboard. Please try again.',
                            style: TextStyle(color: Colors.grey, fontSize: 13),
                          ),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return _buildContent(snapshot.data!);
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(LeaderboardData data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: const [
              Text(
                'Leaderboard',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(width: 8),
              Text('🏆', style: TextStyle(fontSize: 24)),
            ],
          ),
          const Text(
            'Top students based on total points.',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 16),

          // Time Filters
          Row(
            children: [
              _buildFilterTab('All time', true),
              const SizedBox(width: 8),
              _buildFilterTab('This Month', false),
              const SizedBox(width: 8),
              _buildFilterTab('This Week', false),
            ],
          ),
          const SizedBox(height: 20),

          // Podium Box Container
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: _buildPodiumColumns(data.students),
                ),
                const SizedBox(height: 20),
                // Your Rank Banner
                if (data.me != null)
                  Container(
                    width: 400,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEF08A),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      children: [
                        const Text(
                          'Your Rank',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              data.me!.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              'Level ${data.me!.level}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              '#${data.me!.rank}\n${_formatPoints(data.me!.points)} pts',
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Leaderboard Table
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                  ),
                  child: Row(
                    children: const [
                      Expanded(
                        flex: 1,
                        child: Text(
                          'Rank',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'Student',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Level',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          'Points',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                ..._buildTableRows(data.students),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1,900 style formatting for points
  String _formatPoints(int points) {
    return points.toString().replaceAllMapped(
          RegExp(r'\B(?=(\d{3})+(?!\d))'),
          (match) => ',',
        );
  }

  // Podium: Rank 2 (left), Rank 1 (center), Rank 3 (right).
  // Kung kulang pa ang users, yung mga meron lang ang ipapakita.
  List<Widget> _buildPodiumColumns(List<LeaderboardEntry> students) {
    if (students.isEmpty) {
      return [
        const Text(
          'No students on the leaderboard yet.',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
      ];
    }

    // [position sa listahan, kulay, taas] - parehas ng orihinal na design
    final slots = <List<dynamic>>[
      [1, Colors.red.shade100, 120.0],
      [0, Colors.amber.shade100, 150.0],
      [2, Colors.blue.shade100, 100.0],
    ];

    final widgets = <Widget>[];
    for (final slot in slots) {
      final index = slot[0] as int;
      if (index >= students.length) continue;
      final student = students[index];
      if (widgets.isNotEmpty) widgets.add(const SizedBox(width: 16));
      widgets.add(
        _buildPodiumColumn(
          '${student.rank}',
          student.name,
          'Level ${student.level}',
          '${_formatPoints(student.points)} pts',
          slot[1] as Color,
          slot[2] as double,
        ),
      );
    }
    return widgets;
  }

  // Table: Rank 4 pababa (hanggang Top 50 lang para hindi sobrang haba)
  List<Widget> _buildTableRows(List<LeaderboardEntry> students) {
    return students
        .skip(3)
        .take(47)
        .map((student) => _buildTableRow(
              '${student.rank}',
              student.name,
              '${student.level}',
              '${_formatPoints(student.points)} pts',
            ))
        .toList();
  }

  Widget _buildFilterTab(String title, bool isSelected) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFBEF264) : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 12,
          color: isSelected ? Colors.black87 : Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildPodiumColumn(
    String rank,
    String name,
    String level,
    String pts,
    Color bgCol,
    double height,
  ) {
    return Container(
      width: 130,
      height: height + 60,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgCol,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: 16,
            backgroundColor: Colors.white,
            child: Text(
              rank,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          const SizedBox(height: 4),
          const CircleAvatar(radius: 14, backgroundColor: Colors.white54),
          const SizedBox(height: 4),
          Text(
            name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
            overflow: TextOverflow.ellipsis,
          ),
          Text(level, style: const TextStyle(fontSize: 9, color: Colors.grey)),
          Text(
            pts,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildTableRow(
    String rank,
    String student,
    String level,
    String points,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(rank, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 3,
            child: Text(
              student,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(level, style: const TextStyle(fontSize: 13)),
          ),
          Expanded(
            flex: 2,
            child: Text(
              points,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
