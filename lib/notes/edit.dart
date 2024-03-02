import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Button.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';
import 'package:flutter_firebase_course/notes/view.dart';

class EditNote extends StatefulWidget {
  final String oldNote;
  final String noteId;
  final String categoryId;
  const EditNote(
      {super.key,
      required this.noteId,
      required this.oldNote,
      required this.categoryId});

  @override
  State<EditNote> createState() => _EditNoteState();
}

class _EditNoteState extends State<EditNote> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController note = TextEditingController();
  bool isLoading = false;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  updateNote() async {
    try {
      isLoading = true;
      setState(() {});
      await category
          .doc(widget.categoryId)
          .collection("notes")
          .doc(widget.noteId)
          .update({"note": note.text});
      isLoading = false;
      setState(() {});
      Navigator.of(context).push(
        MaterialPageRoute(
            builder: (context) => ViewPage(
                  categoryId: widget.categoryId,
                )),
      );
      print("note Updated");
    } catch (e) {
      print("Failed to update note: $e");
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    note.text = widget.oldNote;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    note.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Form(
        key: formState,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(children: [
            CustomeTextFormField(hint: "edit note", myController: note),
            SizedBox(
              height: 20,
            ),
            CustomeButton(
                text: "Save",
                color: Colors.orange,
                isLoading: isLoading,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    updateNote();
                  }
                })
          ]),
        ),
      ),
    );
  }
}
