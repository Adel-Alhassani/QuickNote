import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({super.key});

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  List<QueryDocumentSnapshot> data = [];
  getData() async {
    try {
      QuerySnapshot queryDocumentSnapshot = await FirebaseFirestore.instance
          .collection("user")
          .orderBy("age", descending: true)
          .get();
      print(queryDocumentSnapshot.size);
      data.addAll(queryDocumentSnapshot.docs);
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
      appBar: AppBar(
        title: Text('Filter'),
      ),
      body: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              DocumentReference user = FirebaseFirestore.instance
                  .collection("user")
                  .doc(data[index].id);

              FirebaseFirestore.instance.runTransaction((transaction) async {
                DocumentSnapshot snapshot = await transaction.get(user);
                if (snapshot.exists) {
                  var snapshotData = snapshot.data();
                  if (snapshotData is Map<String, dynamic>) {
                    int money = snapshotData["money"] + 100;
                    transaction.update(user, {"money": money});
                  }
                }
              }).then((value) {
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => FilterPage()),
                    (Route<dynamic> route) => false);
              });
            },
            child: Card(
                child: ListTile(
              title: Text(
                data[index]['username'],
                style: TextStyle(fontSize: 30),
              ),
              subtitle: Text(
                "age: ${data[index]["age"].toString()}",
                style: TextStyle(fontSize: 20),
              ),
              trailing: Text(
                "${data[index]["money"]}\$",
                style: TextStyle(fontSize: 26, color: Colors.red),
              ),
            )),
          );
        },
      ),
    );
    ;
  }
}
