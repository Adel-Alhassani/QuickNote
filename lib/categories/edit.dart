import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Button.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';

class EditCategory extends StatefulWidget {
  final String oldName;
  final String docId;
  const EditCategory({super.key, required this.docId, required this.oldName});

  @override
  State<EditCategory> createState() => _EditCategoryState();
}

class _EditCategoryState extends State<EditCategory> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();
  bool isLoading = false;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  updateCategory() async {
    try {
      isLoading = true;
      setState(() {});
      await category.doc(widget.docId).update({"name": name.text});
      isLoading = false;
      setState(() {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
      print("Category Updated");
    } catch (e) {
      print("Failed to update Category: $e");
    }
    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name.text = widget.oldName;
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    name.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Category'),
      ),
      body: Form(
        key: formState,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Column(children: [
            CustomeTextFormField(
                hint: "Enter cetegory's name", myController: name),
            SizedBox(
              height: 20,
            ),
            CustomeButton(
                text: "Save",
                color: Colors.orange,
                isLoading: isLoading,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    updateCategory();
                  }
                })
          ]),
        ),
      ),
    );
  }
}
