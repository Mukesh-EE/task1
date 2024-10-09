import 'dart:io';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class RegisterStudentScreen extends StatefulWidget {
  @override
  _RegisterStudentScreenState createState() => _RegisterStudentScreenState();
}

class _RegisterStudentScreenState extends State<RegisterStudentScreen> {
   final _formKey = GlobalKey<FormState>();
  TextEditingController _nameTextController = TextEditingController();
  TextEditingController _studentClassTextController = TextEditingController();
 
  TextEditingController _genderTextController =
      TextEditingController();
  TextEditingController _addressTextController = TextEditingController();
  DatabaseReference dbRef = FirebaseDatabase.instance.ref().child('students');
  
  int? age;
  File? _image;
  final picker = ImagePicker();

  Future<void> _pickImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  Future<void> _registerStudent() async {
    if (_formKey.currentState!.validate() && _image != null) {
      _formKey.currentState!.save();

      String imageUrl = '';
      if (_image != null) {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('student_images/${DateTime.now().millisecondsSinceEpoch}.jpg');
        await storageRef.putFile(_image!);
        imageUrl = await storageRef.getDownloadURL();
      }

      final studentRef = dbRef.push();
      await studentRef.set({
        'name': _nameTextController.text,
        'class': _studentClassTextController.text,
        'gender': _genderTextController.text,
        'age': age,
        'address': _addressTextController.text,
        'image_url': imageUrl,
      });

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register Student')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                 
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  onSaved: (value) => _nameTextController.text = value.toString(),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter student name' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Class'),
                  onSaved: (value) => _studentClassTextController.text = value.toString(),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter class' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Gender'),
                  onSaved: (value) => _genderTextController.text = value.toString(),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter gender' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Age'),
                  keyboardType: TextInputType.number,
                  onSaved: (value) => age = int.parse(value!),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter age' : null,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Address'),
                  onSaved: (value) => _addressTextController.text = value.toString(),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter address' : null,
                ),
                const SizedBox(height: 10),
                _image == null
                    ? const Text('No image selected.')
                    : Image.file(_image!, height: 150),
                ElevatedButton(
                  onPressed: _pickImage,
                  child: const Text('Pick Image'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _registerStudent,
                  child: const Text('Register Student'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
