// add_diary_screen.dart

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'diary_entry.dart';

class AddDiaryScreen extends StatefulWidget {
  const AddDiaryScreen({super.key});

  @override
  State<AddDiaryScreen> createState() {
    return _AddDiaryScreenState();
  }
}

class _AddDiaryScreenState extends State<AddDiaryScreen> {
  late TextEditingController _textEditingController;
  File? _imageFile;

  @override
  void initState() {
    super.initState();
    _textEditingController = TextEditingController();
  }

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    final pickedImage = await ImagePicker().pickImage(source: source);
    if (pickedImage != null) {
      setState(() {
        _imageFile = File(pickedImage.path);
      });
    }
  }

  void _saveDiaryEntry(BuildContext context) {
    if (_textEditingController.text.isNotEmpty && _imageFile != null) {
      final newEntry = DiaryEntry(
        text: _textEditingController.text,
        imageFile: _imageFile!,
      );
      Navigator.pop(context, newEntry);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter text and select an image.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Diary'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextFormField(
              controller: _textEditingController,
              decoration: const InputDecoration(
                labelText: 'Diary Text',
              ),
              maxLines: 5,
            ),
            const SizedBox(height: 16.0),
            Row(
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text('Take a Photo'),
                ),
                const SizedBox(width: 16.0),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text('Choose from Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            if (_imageFile != null)
              Image.file(
                _imageFile!,
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            const Spacer(),
            Center(
              child: ElevatedButton(
                onPressed: () => _saveDiaryEntry(context),
                child: const Text('Save Diary'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
