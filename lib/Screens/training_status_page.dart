import 'package:flutter/material.dart';

class TrainingStatusPage extends StatelessWidget {
  final String name;
  final int index;

  TrainingStatusPage({required this.name, required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Mark Training Status')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Mark training status for:',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              name,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainingResultPage(
                          userName: name,
                          status: 'Pass',
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.check, color: Colors.white),
                  label: Text('Pass'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => TrainingResultPage(
                          userName: name,
                          status: 'Fail',
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.close, color: Colors.white),
                  label: Text('Fail'),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingResultPage extends StatelessWidget {
  final String userName;
  final String status;

  TrainingResultPage({required this.userName, required this.status});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Result")),
      body: Center(
        child: Text(
          '$userName has been marked as $status',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
