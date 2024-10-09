import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:task1/editscreen.dart';
import 'package:task1/register.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
      DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('students');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Students List'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RegisterStudentScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: StreamBuilder(
        stream: databaseRef.onValue,
        builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
          if (snapshot.hasError) {
            return const Text('Something went wrong');
          }

          if (!snapshot.hasData || snapshot.data!.snapshot.value == null) {
            return const Center(child: Text('No students found'));
          }

          final Map<dynamic, dynamic> students =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>;

          return ListView.builder(
            itemCount: students.length,
            itemBuilder: (context, index) {
              final studentKey = students.keys.elementAt(index);
              final studentData = students[studentKey];

              return ListTile(
                leading: Image.network(studentData['image_url'], width: 50),
                title: Text(studentData['name']),
                subtitle: Text(
                    'Class: ${studentData['class']}, Age: ${studentData['age']}'),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditStudentScreen(
                              studentKey: studentKey,
                              studentData: studentData,
                            ),
                          ),
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete),
                      onPressed: () async {
                        await databaseRef.child(studentKey).remove();
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
