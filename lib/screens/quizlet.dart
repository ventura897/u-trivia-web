import 'package:flutter/material.dart';

class QuizletPage extends StatelessWidget {
  const QuizletPage({super.key});

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
                ListTile(
                  leading: const Icon(Icons.dashboard, color: Colors.blue),
                  title: const Text('Dashboard',
                      style: TextStyle(
                          color: Colors.blue, fontWeight: FontWeight.bold)),
                  onTap: () => Navigator.pop(context),
                ),
                const ListTile(
                    leading: Icon(Icons.people), title: Text('Students')),
                const ListTile(
                    leading: Icon(Icons.settings), title: Text('Settings')),
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
                        const Text('CREATE QUIZ',
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 20),
                        Container(
                          padding: const EdgeInsets.all(25),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text('Question',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16)),
                                  CircleAvatar(
                                      backgroundColor: Colors.red,
                                      radius: 16,
                                      child: Icon(Icons.delete,
                                          color: Colors.white, size: 18)),
                                ],
                              ),
                              const SizedBox(height: 10),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter Question...',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(height: 20),
                              const Text('Options',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16)),
                              const SizedBox(height: 10),
                              TextField(
                                decoration: InputDecoration(
                                  hintText: 'Enter Option....',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextButton.icon(
                                onPressed: () {},
                                icon: const Icon(Icons.add, color: Colors.blue),
                                label: const Text('Add Option',
                                    style: TextStyle(color: Colors.blue)),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30, vertical: 15)),
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Previous',
                                  style: TextStyle(color: Colors.black)),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black,
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 40, vertical: 15),
                                elevation: 0,
                                side: const BorderSide(color: Colors.grey),
                              ),
                              onPressed: () {},
                              child: const Text('Next'),
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
}
