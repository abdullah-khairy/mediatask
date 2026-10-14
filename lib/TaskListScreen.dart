import 'package:flutter/material.dart';
import 'package:mediatask/TaskExecutionScreen.dart';

class TaskListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('مهام Dozza X'),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Chip(label: Text('رصيدك: 15.5 JOD')),
          )
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: 5, // استبدله ببيانات من Supabase
        itemBuilder: (context, index) {
          return Card(
            elevation: 3,
            margin: EdgeInsets.only(bottom: 15),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            child: ListTile(
              contentPadding: EdgeInsets.all(15),
              leading: Icon(Icons.facebook, color: Colors.blue, size: 40),
              title: Text('نشر منشور في 5 مجموعات', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text('المكافأة: 0.50 دينار'),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green, foregroundColor: Colors.white),
                onPressed: () {
                  // الانتقال لصفحة التنفيذ
                  Navigator.push(context, MaterialPageRoute(builder: (context) => TaskExecutionScreen(
                    url: 'https://m.facebook.com', 
                    taskText: 'هذا النص سيتم نسخه تلقائياً من Dozza X',
                  )));
                },
                child: Text('تنفيذ'),
              ),
            ),
          );
        },
      ),
    );
  }
}