import 'package:flutter/material.dart';

import 'dashboard.dart';

class MyProgressScreen extends StatelessWidget {
  const MyProgressScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentIndex: 2),
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
                        Row(
                          children: const [
                            Text(
                              'My Progress',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.trending_up, size: 28),
                          ],
                        ),
                        const Text(
                          'Track your learning journey and achievemenets.',
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                        const SizedBox(height: 20),

                        // Stats Summary Row
                        Row(
                          children: [
                            _buildSummaryCard(
                              'Total Points',
                              '150',
                              'Keep it up!',
                              Icons.star,
                              Colors.amber,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              'Quizzes Completed',
                              '3',
                              '',
                              Icons.assignment,
                              Colors.blue,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              'Level',
                              '1/50',
                              '',
                              Icons.military_tech,
                              Colors.purple,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              'Acuracy',
                              '100%',
                              'Good Job!',
                              Icons.track_changes,
                              Colors.red,
                            ),
                            const SizedBox(width: 16),
                            _buildSummaryCard(
                              'Campus Rank',
                              '#11',
                              'Top 5% of students',
                              Icons.emoji_events,
                              Colors.orange,
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Center Graph & Performance Row
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Progress Overview Chart box
                            Expanded(
                              flex: 3,
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
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: const [
                                            Text(
                                              'Progress overview',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Points',
                                              style: TextStyle(
                                                fontSize: 11,
                                                color: Colors.grey,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                              color: Colors.grey.shade300,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              6,
                                            ),
                                          ),
                                          child: Row(
                                            children: const [
                                              Text(
                                                'This week',
                                                style: TextStyle(fontSize: 11),
                                              ),
                                              SizedBox(width: 4),
                                              Icon(
                                                Icons.keyboard_arrow_down,
                                                size: 14,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    // Simulated Chart lines
                                    SizedBox(
                                      height: 160,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          _chartRow('1000'),
                                          _chartRow('700'),
                                          _chartRow('500'),
                                          _chartRow('300'),
                                          _chartRow('100'),
                                          _chartRow('0'),
                                        ],
                                      ),
                                    ),
                                    const Divider(),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Text(
                                          'Sept 1',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Sept 2',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Sept 3',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Sept 4',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Sept 5',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                        Text(
                                          'Sept 6',
                                          style: TextStyle(
                                            fontSize: 10,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 24),
                            // Category Performance box
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
                                    const Text(
                                      'Category Performance',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    _buildCategoryBar('General Knowledge', 0.0),
                                    _buildCategoryBar('Science', 0.4),
                                    _buildCategoryBar('History', 0.0),
                                    _buildCategoryBar('Technology', 0.0),
                                    _buildCategoryBar('Arts & Literature', 0.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 24),

                        // Bottom Grid (Recent Achievements & Your Progress Card)
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
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
                                          'Recent Achivements',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        Text(
                                          'View all',
                                          style: TextStyle(
                                            color: Color(0xFF047857),
                                            fontSize: 11,
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
                            ),
                            const SizedBox(width: 24),
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
                                    const SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Level 1',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
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
                                    const SizedBox(height: 8),
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(10),
                                      child: LinearProgressIndicator(
                                        value: 0.29,
                                        minHeight: 10,
                                        backgroundColor: Colors.grey.shade200,
                                        valueColor:
                                            const AlwaysStoppedAnimation<Color>(
                                              Color(0xFFA3E635),
                                            ),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Text(
                                        '29%',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                    const Center(
                                      child: Text(
                                        'Keep earning points to level up!',
                                        style: TextStyle(
                                          fontSize: 10,
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

  Widget _buildSummaryCard(
    String title,
    String value,
    String sub,
    IconData icon,
    Color color,
  ) {
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
            Row(
              children: [
                Icon(icon, color: color, size: 20),
                const SizedBox(width: 6),
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
              Text(
                sub,
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
          ],
        ),
      ),
    );
  }

  Widget _chartRow(String label) {
    return Row(
      children: [
        SizedBox(
          width: 35,
          child: Text(
            label,
            style: const TextStyle(fontSize: 10, color: Colors.grey),
          ),
        ),
        Expanded(child: Container(height: 1, color: Colors.grey.shade200)),
      ],
    );
  }

  Widget _buildCategoryBar(String category, double progress) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            category,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 10,
              backgroundColor: Colors.grey.shade200,
              valueColor: const AlwaysStoppedAnimation<Color>(
                Color(0xFFA3E635),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementItem(String title, String points) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              const Icon(Icons.school, size: 16, color: Colors.blueGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Text(
            points,
            style: const TextStyle(
              color: Color(0xFF047857),
              fontWeight: FontWeight.bold,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
