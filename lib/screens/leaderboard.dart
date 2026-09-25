import 'package:flutter/material.dart';

import 'dashboard.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          const Sidebar(currentIndex: 3),
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
                                children: [
                                  // Rank 2
                                  _buildPodiumColumn(
                                    '2',
                                    'Jose Manalo',
                                    'Level 4',
                                    '1,900 pts',
                                    Colors.red.shade100,
                                    120,
                                  ),
                                  const SizedBox(width: 16),
                                  // Rank 1
                                  _buildPodiumColumn(
                                    '1',
                                    'Tristan Ibarra',
                                    'Level 5',
                                    '2,300 pts',
                                    Colors.amber.shade100,
                                    150,
                                  ),
                                  const SizedBox(width: 16),
                                  // Rank 3
                                  _buildPodiumColumn(
                                    '3',
                                    'Rene Baterbonia',
                                    'Level 4',
                                    '1,590 pts',
                                    Colors.blue.shade100,
                                    100,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              // Your Rank Banner
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: const [
                                        Text(
                                          'Patrick Marquez',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 13,
                                          ),
                                        ),
                                        Text(
                                          'Level 1',
                                          style: TextStyle(fontSize: 12),
                                        ),
                                        Text(
                                          '#11\n300 pts',
                                          textAlign: TextAlign.right,
                                          style: TextStyle(
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
                              _buildTableRow(
                                '4',
                                'James Harden',
                                '3',
                                '1,300 pts',
                              ),
                              _buildTableRow(
                                '5',
                                'Carl Jefferson',
                                '3',
                                '1,100 pts',
                              ),
                              _buildTableRow(
                                '6',
                                'Jojo Mara Sigan',
                                '3',
                                '1,050 pts',
                              ),
                              _buildTableRow('7', 'Top Son', '3', '1,004 pts'),
                              _buildTableRow(
                                '8',
                                'Jerald Norman',
                                '2',
                                '999 pts',
                              ),
                              _buildTableRow(
                                '9',
                                'Coco Pementel',
                                '2',
                                '899 pts',
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
