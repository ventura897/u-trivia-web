import 'package:flutter/material.dart';

import 'facultydashboard.dart';
import 'settingsfaculty.dart';

class StudentPage extends StatelessWidget {
  const StudentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F4F4),
      body: Row(
        children: [
          // Sidebar
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
                      Text('U-TRIVIA',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                _sidebarItem(context, Icons.dashboard, 'Dashboard', 0),
                _sidebarItem(context, Icons.people, 'Students', 1, true),
                _sidebarItem(context, Icons.settings, 'Settings', 2),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Column(
              children: [
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
                          child:
                              Text('I', style: TextStyle(color: Colors.white))),
                      SizedBox(width: 10),
                      Text('Ivana Cruz',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Icon(Icons.arrow_drop_down),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Students',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const Text('Manage and monitor registered students.',
                            style: TextStyle(color: Colors.grey)),
                        const SizedBox(height: 25),
                        Row(
                          children: [
                            _statCard(
                                'Total Students',
                                '1,200',
                                '+12 this week',
                                Colors.blue,
                                Icons.group_outlined),
                            const SizedBox(width: 20),
                            _statCard('Active Students', '1,099', '',
                                Colors.blue, Icons.person_outline),
                            const SizedBox(width: 20),
                            _statCard('Quiz Attempts', '799', '', Colors.blue,
                                Icons.assignment_outlined),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Recent',
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
                                  Text('Department',
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

  Widget _sidebarItem(
      BuildContext context, IconData icon, String title, int index,
      [bool selected = false]) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: selected ? Colors.blue[50] : Colors.transparent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: ListTile(
        leading: Icon(icon, color: selected ? Colors.blue : Colors.black54),
        title: Text(title,
            style: TextStyle(
                color: selected ? Colors.blue : Colors.black87,
                fontWeight: selected ? FontWeight.bold : FontWeight.normal)),
        onTap: () {
          if (index == 0) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const FacultyDashboard()));
          } else if (index == 2) {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const SettingsFacultyPage()));
          }
        },
      ),
    );
  }

  Widget _statCard(
      String title, String value, String subtitle, Color color, IconData icon) {
    return Container(
      width: 220,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          color: Colors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: color),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(color: Colors.grey)),
          const SizedBox(height: 5),
          Text(value,
              style:
                  const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          if (subtitle.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(subtitle,
                style: const TextStyle(color: Colors.green, fontSize: 12)),
          ]
        ],
      ),
    );
  }
}
