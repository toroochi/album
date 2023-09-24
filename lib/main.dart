import 'dart:typed_data';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_web/image_picker_web.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _auth = FirebaseAuth.instance;
  Uint8List? imageData;

  void uploadPicture() async {
    try {
      Uint8List? uint8list = await ImagePickerWeb.getImageAsBytes();
      if (uint8list != null) {
        var metadata = SettableMetadata(
          contentType: "image/jpeg",
        );
        FirebaseStorage.instance.ref("image/sample").putData(uint8list, metadata);

        // アップロード後、ダウンロードして画像を表示
        var imageURL = await FirebaseStorage.instance.ref("image/sample").getDownloadURL();
        setState(() {
          imageData = uint8list;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                uploadPicture();
              },
              child: Text('Upload'),
            ),
            SizedBox(height: 20),
            if (imageData != null)
              Image.memory(
                imageData!,
                width: 300, // 画像の幅を調整
              ),
          ],
        ),
      ),
    );
  }
}
