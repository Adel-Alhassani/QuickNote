import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/auth/login.dart';
import 'package:flutter_firebase_course/categories/add.dart';
import 'package:flutter_firebase_course/categories/edit.dart';
import 'package:flutter_firebase_course/notes/view.dart';
import 'package:google_sign_in/google_sign_in.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<QueryDocumentSnapshot> data = [];

  bool isLoading = true;

  getData() async {
    try {
      QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
          .collection("category")
          .where("id", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get();

      data.addAll(queryDocumentSnapshot.docs);
      isLoading = false;
    } catch (e) {
      print("Error $e");
    }
    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.orange,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddCategory()));
          },
          child: Icon(Icons.add)),
      appBar: AppBar(
        title: Text('Home page'),
        actions: [
          IconButton(
              onPressed: () async {
                try {
                  // if (GoogleSignIn().currentUser != null) {
                  //   GoogleSignIn().disconnect();
                  // }
                  GoogleSignIn().signOut();
                  await FirebaseAuth.instance.signOut();
                  Navigator.of(context).pushAndRemoveUntil(
                      MaterialPageRoute(builder: (context) => Login()),
                      (Route<dynamic> route) => false);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.exit_to_app))
        ],
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, mainAxisExtent: 170),
                itemCount: data.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) =>
                              ViewPage(categoryId: data[index].id)));
                    },
                    onLongPress: () {
                      AwesomeDialog(
                        context: context,
                        dialogType: DialogType.warning,
                        animType: AnimType.rightSlide,
                        title: 'Options',
                        desc: 'What you want to do?',
                        btnOkText: "Edit",
                        btnOkOnPress: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => EditCategory(
                                  docId: data[index].id,
                                  oldName: data[index]["name"])));
                        },
                        btnCancelText: "Delete",
                        btnCancelOnPress: () async {
                          await FirebaseFirestore.instance
                              .collection("category")
                              .doc(data[index].id)
                              .delete();
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        },
                      ).show();
                    },
                    child: Card(
                      child: Column(children: [
                        Image.asset(
                          "images/folder.png",
                          width: 100,
                        ),
                        Text(
                          "${data[index]["name"]}",
                          style: TextStyle(fontSize: 20),
                        )
                      ]),
                    ),
                  );
                },
              ),
            ),
    );
    ;
  }
}
