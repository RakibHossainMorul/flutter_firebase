import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';
import 'package:flutter_firebase/widgets/rounded_button.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  State<AddPostScreen> createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  //
  bool loading = false;
  final realTimeDatabase = FirebaseDatabase.instance.ref('Posts');
  TextEditingController postController = TextEditingController();
  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Add Post Screen"),
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
                  realTimeDatabase.child(randomID).set({
                    'title': postController.text.toString(),
                    'id': randomID,
                  }).then((value) {
                    Utils().toastMessage("Post Added");
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
