import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Button.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';
import 'package:flutter_firebase_course/notes/view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({super.key, required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();
  bool isAddNoteLoading = false;
  bool isAddImageLoading = false;
  File? file;
  String? url;

  addImage() async {
    final ImagePicker picker = ImagePicker();
    // Pick an image.

    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    var imageName = path.basename(image!.path);

    if (image != null) {
      file = File(image!.path);
      var refStorage = FirebaseStorage.instance.ref("images/$imageName");
      isAddImageLoading = true;
      setState(() {});
      await refStorage.putFile(file!);
      url = await refStorage.getDownloadURL();
    }
    isAddImageLoading = false;
    setState(() {});
  }

  addNote() async {
    CollectionReference categoryNotes = FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryId)
        .collection("notes");
    try {
      isAddNoteLoading = true;
      setState(() {});
      await categoryNotes.add({"note": note.text, "url": url ?? "none"});
      isAddNoteLoading = false;
      setState(() {});
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ViewPage(
                  categoryId: widget.categoryId,
                )),
      );
      print("Note Added");
    } catch (e) {
      print("Failed to add note: $e");
    }
    isAddNoteLoading = false;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Note'),
      ),
      body: Form(
        key: formState,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(children: [
            CustomeTextFormField(hint: "Type a note", myController: note),
            SizedBox(
              height: 20,
            ),
            CustomeButton(
                text: "Add",
                color: Colors.orange,
                isLoading: isAddNoteLoading,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    addNote();
                  }
                }),
            SizedBox(
              height: 10,
            ),
            CustomeUploadButtonIcon(
                text: "Upload an image",
                width: 250,
                color: url == null ? Colors.orange : Colors.green,
                icon: Icon(Icons.image),
                onPressed: () {
                  addImage();
                },
                isLoading: isAddImageLoading)
          ]),
        ),
      ),
    );
  }
}
