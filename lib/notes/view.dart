import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/auth/login.dart';
import 'package:flutter_firebase_course/categories/add.dart';
import 'package:flutter_firebase_course/categories/edit.dart';
import 'package:flutter_firebase_course/home.dart';
import 'package:flutter_firebase_course/notes/add.dart';
import 'package:flutter_firebase_course/notes/edit.dart';
import 'package:google_sign_in/google_sign_in.dart';

class ViewPage extends StatefulWidget {
  final String categoryId;
  const ViewPage({super.key, required this.categoryId});

  @override
  State<ViewPage> createState() => _ViewPageState();
}

class _ViewPageState extends State<ViewPage> {
  List<QueryDocumentSnapshot> data = [];
  bool isLoading = true;

  getData() async {
    try {
      QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
          .collection("category")
          .doc(widget.categoryId)
          .collection("notes")
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
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      AddNote(categoryId: widget.categoryId)));
            },
            child: Icon(Icons.add)),
        appBar: AppBar(
          title: Text('Notes'),
        ),
        body: PopScope(
            canPop: false,
            onPopInvoked: (pop) {
              Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (context) => HomePage()),
                  (Route<dynamic> route) => false);
            },
            child: isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: ListView.builder(
                      itemExtent: 170,
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return InkWell(
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
                                    builder: (context) => EditNote(
                                          noteId: data[index].id,
                                          oldNote: data[index]["note"],
                                          categoryId: widget.categoryId,
                                        )));
                              },
                              btnCancelText: "Delete",
                              btnCancelOnPress: () async {
                                await FirebaseFirestore.instance
                                    .collection("category")
                                    .doc(widget.categoryId)
                                    .collection("notes")
                                    .doc(data[index].id)
                                    .delete();
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                        builder: (context) => ViewPage(
                                              categoryId: widget.categoryId,
                                            )));
                              },
                            ).show();
                          },
                          child: Card(
                            // color: Colors.orange,
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "${data[index]["note"]}",
                                    style: TextStyle(fontSize: 20),
                                  ),
                                  if (data[index]["url"] != "none")
                                    Column(
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        Image.network(
                                          data[index]["url"],
                                          height: 100,
                                        )
                                      ],
                                    ),
                                ]),
                          ),
                        );
                      },
                    ),
                  )));
  }
}
