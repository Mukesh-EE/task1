
import 'package:flutter/material.dart';

import 'package:firebase_database/firebase_database.dart';

class EditStudentScreen extends StatefulWidget {
  final String studentKey;
  final Map studentData;

  const EditStudentScreen({
    Key? key,
    required this.studentKey,
    required this.studentData,
  }) : super(key: key);

  @override
  _EditStudentScreenState createState() => _EditStudentScreenState();
}

class _EditStudentScreenState extends State<EditStudentScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _classController;
  late TextEditingController _ageController;
  late TextEditingController _imageUrlController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.studentData['name']);
    _classController = TextEditingController(text: widget.studentData['class']);
    _ageController = TextEditingController(text: widget.studentData['age'].toString());
    _imageUrlController = TextEditingController(text: widget.studentData['image_url']);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _classController.dispose();
    _ageController.dispose();
    _imageUrlController.dispose();
    super.dispose();
  }

  Future<void> _updateStudent() async {
    if (_formKey.currentState!.validate()) {
      final updatedStudent = {
        'name': _nameController.text,
        'class': _classController.text,
        'age': int.parse(_ageController.text),
        'image_url': _imageUrlController.text,
      };
  DatabaseReference databaseRef = FirebaseDatabase.instance.ref().child('students');

      await databaseRef.child(widget.studentKey).update(updatedStudent);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Student updated successfully')),
      );

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Student'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _classController,
                decoration: const InputDecoration(labelText: 'Class'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a class';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ageController,
                decoration: const InputDecoration(labelText: 'Age'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an age';
                  }
                  if (int.tryParse(value) == null) {
                    return 'Please enter a valid number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _imageUrlController,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter an image URL';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateStudent,
                child: const Text('Update Student'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
