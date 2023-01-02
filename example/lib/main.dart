import 'package:example/home.dart';
import 'package:flutter/material.dart';
import 'package:imagekit/imagekit.dart';

void main() {
  final imagekit = ImageKit.getInstance();
  const config = Configuration(
    publicKey: 'your-public-key',
    urlEndpoint: 'https://ik.imagekit.io/your-endpoint',
    authenticationEndpoint: 'http://your-server.tld/imagekit/auth',
  );
  imagekit.setConfig(config);
  runApp(const MaterialApp(home: HomePage()));
}
