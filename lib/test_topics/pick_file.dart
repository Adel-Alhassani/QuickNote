import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';

class PickFilePage extends StatefulWidget {
  const PickFilePage({super.key});

  @override
  State<PickFilePage> createState() => _PickFilePageState();
}

class _PickFilePageState extends State<PickFilePage> {
  File? file;
  String? url;

  getImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    var imageName = basename(image!.path);

    if (image != null) {
      file = File(image!.path);
      var refStorage = FirebaseStorage.instance.ref("images/$imageName");
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('image picker'),
      ),
      body: Center(
        child: Column(children: [
          MaterialButton(
            color: Colors.blue,
            onPressed: () {
              getImage();
            },
            child: Text("Select an image"),
          ),
          if (url != null)
            Image.network(
              url!,
              width: 300,
              height: 300,
            )
        ]),
      ),
    );
    ;
  }
}
