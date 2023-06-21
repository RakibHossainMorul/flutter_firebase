import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/utils/utils.dart';

import 'auth/login_screen.dart';

class PostScreen extends StatefulWidget {
  const PostScreen({super.key});

  @override
  State<PostScreen> createState() => _PostScreenState();
}

class _PostScreenState extends State<PostScreen> {
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                auth
                    .signOut()
                    .then((value) => Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const LoginScreen())))
                    .onError((error, stackTrace) => () {
                          Utils().toastMessage(error.toString());
                        });
              },
              icon: const Icon(Icons.logout))
        ],
        title: const Text("Post Screen"),
      ),
      body: Center(
        child: Text("Post Screen"),
      ),
    );
  }
}
