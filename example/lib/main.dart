import 'dart:io';
import 'package:flutter/material.dart';
import 'package:imagekit/imagekit.dart';
import 'package:image_picker/image_picker.dart';

void main() {
  final imagekit = ImageKit.getInstance();
  const config = Configuration(
    publicKey: 'your-public-key',
    urlEndpoint: 'https://ik.imagekit.io/your-company-name',
    authenticationEndpoint: 'http://your-server.tld/imagekit/auth',
  );
  imagekit.setConfig(config);
  runApp(const MaterialApp(home: HomePage()));
}

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

  Future<void> selectImage() async {
    final xFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (xFile == null) return;
    setState(() {
      file = File(xFile.path);
    });
  }

  Future<void> uploadImage() async {
    final selectedFile = file;
    if (selectedFile == null) return;
    const tags = ['rose', 'flower'];
    const bearerToken =
        'eyJhbGciOiJIUzI1NiJ9.eyJSb2xlIjoiVVNFUiIsIklzc3VlciI6Ik5TVEFDSyBJTkRJQSIsIlVzZXJuYW1lIjoieXQubnN0YWNrQGdtYWlsLmNvbSIsImV4cCI6MTY3MjcyNzU4NSwiaWF0IjoxNjcyNzI3NTg1fQ.vOVKKT-U8f6M4jU1kCb_zT1XFpFDvqeGQHUN_PtHVLQ';
    final image = await imagekit.upload(
      selectedFile,
      tags: tags,
      bearerToken: bearerToken,
    );
    // File Id: image.fileId
    // Thumbnail Url: image.thumbnailUrl
    // Image Url: image.filePath
    print(image.toJson());
  }
}
