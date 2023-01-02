import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagekit/imagekit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final imagekit = ImageKit.getInstance();
  File? file;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example App'),
      ),
      body: Column(
        children: [
          file != null ? Image.file(file!) : const SizedBox(),
          Visibility(
            visible: file != null,
            replacement: Center(
              child: ElevatedButton(
                onPressed: selectImage,
                child: const Text('Select Image'),
              ),
            ),
            child: Center(
              child: ElevatedButton(
                onPressed: uploadImage,
                child: const Text('Upload Image'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void selectImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    setState(() {
      file = File(xFile.path);
    });
  }

  void uploadImage() async {
    final selectedFile = file;
    if (selectedFile == null) return;
    const tags = ['rose', 'flower'];
    final data = await imagekit.upload(selectedFile, tags: tags);
    print(data.toJson());
  }
}
