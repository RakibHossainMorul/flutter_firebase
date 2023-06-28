import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/firestore/add_firestore_screen.dart';

import '../utils/utils.dart';

class FirestoreListScreen extends StatefulWidget {
  const FirestoreListScreen({super.key});

  @override
  State<FirestoreListScreen> createState() => _FirestoreListScreenState();
}

class _FirestoreListScreenState extends State<FirestoreListScreen> {
  //
  final auth = FirebaseAuth.instance;
  final firestoreRef =
      FirebaseFirestore.instance.collection('Users').snapshots();
  CollectionReference ref = FirebaseFirestore.instance.collection('Users');
  TextEditingController updateController = TextEditingController();
  //
  Future<void> showMyDialog(String title, String id) async {
    updateController.text = title;

    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text("Update"),
            content: TextField(
              controller: updateController,
              decoration: InputDecoration(
                  hintText: 'Enter new title',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10))),
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel")),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text(
                    "Update",
                    style: TextStyle(color: Colors.white),
                  ))
            ],
          );
        });
  }

//This is used for stream builder widget for this file
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        tooltip: 'Add Data to Firestore',
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const AddDataToFirestore()));
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Firestore Screen'),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(
              height: 15,
            ),
            StreamBuilder(
                stream: firestoreRef,
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  //
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  //
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('Something went wrong'),
                    );
                  }
                  //
                  return Expanded(
                      child: ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ListTile(
                        trailing: IconButton(
                          onPressed: () {
                            ref
                                .doc(
                                    snapshot.data!.docs[index]['id'].toString())
                                .delete()
                                .then((value) {
                              Utils().toastMessage('Deleted Successfully');
                            }).onError((error, stackTrace) {
                              Utils().toastMessage(error.toString());
                            });
                          },
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                        ),
                        onTap: () {
                          ref
                              .doc(snapshot.data!.docs[index]['id'].toString())
                              .update({
                            'title': 'Updated Title',
                          }).then((value) {
                            Utils().toastMessage('Updated Successfully');
                          }).onError((error, stackTrace) {
                            Utils().toastMessage(error.toString());
                          });
                        },
                        title: Text(snapshot.data!.docs[index]['title']),
                        subtitle: Text(snapshot.data!.docs[index]['id']),
                        /*
                        trailing: IconButton(
                          onPressed: () {
                            showMyDialog(snapshot.data!.docs[index]['title'],
                                snapshot.data!.docs[index]['id']);
                          },
                          icon: const Icon(Icons.edit),
                        ),
                        */
                      );
                    },
                  ));
                }),
          ],
        ),
      ),
    );
  }
}
