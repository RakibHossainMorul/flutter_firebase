import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/widgets/rounded_button.dart';
import '../utils/utils.dart';

class AddDataToFirestore extends StatefulWidget {
  const AddDataToFirestore({super.key});

  @override
  State<AddDataToFirestore> createState() => _AddDataToFirestoreState();
}

class _AddDataToFirestoreState extends State<AddDataToFirestore> {
  //
  bool loading = false;
  TextEditingController postController = TextEditingController();
  final firestoreRef = FirebaseFirestore.instance.collection('Users');
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Firestore Post Screen"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextFormField(
              controller: postController,
              maxLines: 4,
              decoration: const InputDecoration(
                labelText: "Title",
                hintText: "Enter Title",
              ),
            ),
            const SizedBox(
              height: 15,
            ),
            RoundButton(
                loading: loading,
                title: 'Add Post',
                onTap: () {
                  setState(() {
                    loading = true;
                  });
                  //Backend Code here
                  String randomID =
                      DateTime.now().millisecondsSinceEpoch.toString();
                  firestoreRef.doc(randomID).set({
                    'title': postController.text.toString(),
                    'id': randomID,
                  }).then((value) {
                    Utils().toastMessage("Firestore Post Added");
                    setState(() {
                      loading = false;
                    });
                  }).onError((error, stackTrace) {
                    Utils().toastMessage(error.toString());
                    setState(() {
                      loading = false;
                    });
                  });
                })
          ],
        ),
      ),
    );
  }
}
