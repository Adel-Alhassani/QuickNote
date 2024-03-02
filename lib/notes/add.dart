import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Button.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';
import 'package:flutter_firebase_course/notes/view.dart';

class AddNote extends StatefulWidget {
  final String categoryId;
  const AddNote({super.key, required this.categoryId});

  @override
  State<AddNote> createState() => _AddNoteState();
}

class _AddNoteState extends State<AddNote> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();
  bool isLoading = false;

  addNote() async {
    CollectionReference categoryNotes = FirebaseFirestore.instance
        .collection('category')
        .doc(widget.categoryId)
        .collection("notes");
    try {
      isLoading = true;
      setState(() {});
      await categoryNotes.add({"note": note.text});
      isLoading = false;
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
    isLoading = false;
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
                isLoading: isLoading,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    addNote();
                  }
                })
          ]),
        ),
      ),
    );
  }
}
