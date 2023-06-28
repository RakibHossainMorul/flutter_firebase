import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../utils/utils.dart';
import '../../widgets/rounded_button.dart';
import '../Posts/post_screen.dart';

class VerifyCodeScreen extends StatefulWidget {
  final String verificationId;
  const VerifyCodeScreen({super.key, required this.verificationId});

  @override
  State<VerifyCodeScreen> createState() => _VerifyCodeScreenState();
}

class _VerifyCodeScreenState extends State<VerifyCodeScreen> {
  bool loading = false;
  final auth = FirebaseAuth.instance;
  TextEditingController phoneVerifyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text("Phone Verify Code"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phoneVerifyController,
                decoration: const InputDecoration(
                  labelText: "Verification Code",
                  hintText: "6 Digit Code",
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              RoundButton(
                  title: 'Verify',
                  loading: loading,
                  onTap: () {
                    setState(() {
                      loading = true;
                    });
                    auth
                        .signInWithCredential(PhoneAuthProvider.credential(
                            verificationId: widget.verificationId,
                            smsCode: phoneVerifyController.text.toString()))
                        .then((value) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage("Phone Verified");
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PostScreen()));
                    }).onError((error, stackTrace) {
                      setState(() {
                        loading = false;
                      });
                      Utils().toastMessage(error.toString());
                    });
                  })
            ],
          ),
        ));
  }
}
