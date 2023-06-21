import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase/ui/auth/sign_up.dart';

import '../../utils/utils.dart';
import '../../widgets/rounded_button.dart';
import '../post_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final _formFieldKey = GlobalKey<FormState>();
  FirebaseAuth auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      loading = true;
    });
    auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        loading = false;
      });
      Utils()
          .toastMessage("Login Successful\n${emailController.text.toString()}");
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const PostScreen()));
    }).onError((error, stackTrace) {
      setState(() {
        loading = false;
      });
      Utils().toastMessage(error.toString());
    });
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(children: [
          Expanded(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Form(
                  key: _formFieldKey,
                  child: Column(children: [
                    TextFormField(
                      keyboardType: TextInputType.emailAddress,
                      controller: emailController,
                      decoration: const InputDecoration(
                        hintText: 'Email',
                        prefixIcon: Icon(Icons.email),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 10),
                    TextFormField(
                      keyboardType: TextInputType.visiblePassword,
                      obscureText: true,
                      controller: passwordController,
                      decoration: const InputDecoration(
                        hintText: 'Password',
                        prefixIcon: Icon(Icons.lock),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'Enter Password';
                        }
                        return null;
                      },
                    ),
                  ])),
              const SizedBox(height: 10),
              RoundButton(
                loading: loading,
                title: "Login",
                onTap: () {
                  if (_formFieldKey.currentState!.validate()) {
                    //////////
                    login();
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?"),
                  TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpScreen()));
                      },
                      child: const Text(
                        "Register",
                        style: TextStyle(color: Colors.blue),
                      ))
                ],
              ),
              TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Sign in With Phone",
                    style: TextStyle(color: Colors.blue),
                  ))
            ],
          ))
        ]),
      ),
    );
  }
}
