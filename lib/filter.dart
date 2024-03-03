import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  // List<QueryDocumentSnapshot> data = [];
  // getData() async {
  //   try {
  //     QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
  //         .collection("user")
  //         .orderBy("age", descending: true)
  //         .get();
  //     print(queryDocumentSnapshot.size);
  //     data.addAll(queryDocumentSnapshot.docs);
  //   } catch (e) {
  //     print("Error $e");
  //   }
  //   setState(() {});
  // }

  final Stream<QuerySnapshot> usersStream =
      FirebaseFirestore.instance.collection('user').snapshots();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            DocumentReference doc1 =
                FirebaseFirestore.instance.collection("user").doc("1");
            DocumentReference doc2 =
                FirebaseFirestore.instance.collection("user").doc("2");

            WriteBatch batch = FirebaseFirestore.instance.batch();

            batch.set(doc1, {
              "username": "ali",
              "age": 27,
              "money": 700,
            });

            batch.set(doc2, {
              "username": "shady",
              "age": 33,
              "money": 50,
            });
            batch.commit();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => FilterPage()),
                (Route<dynamic> route) => false);
          },
          child: Icon(Icons.add),
        ),
        appBar: AppBar(
          title: Text('Filter'),
        ),
        body: Container(
            child: StreamBuilder(
          stream: usersStream,
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            if (snapshot.hasError) {
              return Text("Error");
            }
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Text("Loading...");
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    DocumentReference user = FirebaseFirestore.instance
                        .collection("user")
                        .doc(snapshot.data!.docs[index].id);

                    FirebaseFirestore.instance
                        .runTransaction((transaction) async {
                      DocumentSnapshot snapshot = await transaction.get(user);
                      if (snapshot.exists) {
                        var snapshotData = snapshot.data();
                        if (snapshotData is Map<String, dynamic>) {
                          int money = snapshotData["money"] + 100;
                          transaction.update(user, {"money": money});
                        }
                      }
                    }).then((value) {
                      // Navigator.of(context).pushAndRemoveUntil(
                      //     MaterialPageRoute(builder: (context) => FilterPage()),
                      //     (Route<dynamic> route) => false);
                    });
                  },
                  child: Card(
                      child: ListTile(
                    title: Text(
                      snapshot.data!.docs[index]['username'],
                      style: TextStyle(fontSize: 30),
                    ),
                    subtitle: Text(
                      "age: ${snapshot.data!.docs[index]["age"].toString()}",
                      style: TextStyle(fontSize: 20),
                    ),
                    trailing: Text(
                      "${snapshot.data!.docs[index]["money"]}\$",
                      style: TextStyle(fontSize: 26, color: Colors.red),
                    ),
                  )),
                );
              },
            );
          },
        )));
  }
}