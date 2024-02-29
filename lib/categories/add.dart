import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Button.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';

class AddCategory extends StatefulWidget {
  const AddCategory({super.key});

  @override
  State<AddCategory> createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  GlobalKey<FormState> formState = GlobalKey();
  TextEditingController name = TextEditingController();
  bool isLoading = false;
  CollectionReference category =
      FirebaseFirestore.instance.collection('category');
  addCategory() async {
    try {
      isLoading = true;
      setState(() {});
      DocumentReference reference = await category.add(
          {"name": name.text, "id": FirebaseAuth.instance.currentUser!.uid});
      isLoading = false;
      setState(() {});
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => HomePage()),
          (Route<dynamic> route) => false);
      print("Category Added");
    } catch (e) {
      print("Failed to add Category: $e");
    }
    isLoading = false;
    setState(() {});
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
                text: "Add",
                color: Colors.orange,
                isLoading: isLoading,
                onPressed: () {
                  if (formState.currentState!.validate()) {
                    addCategory();
                  }
                })
          ]),
        ),
      ),
    );
  }
}
