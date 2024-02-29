// import 'dart:ffi';
// import 'dart:math';

import 'dart:math';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_firebase_course/auth/signup.dart';
import 'package:flutter_firebase_course/components/AuthButton.dart';
import 'package:flutter_firebase_course/components/Logo.dart';
import 'package:flutter_firebase_course/components/TextFormField.dart';
import 'package:flutter_firebase_course/home.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  late TextEditingController email = TextEditingController();
  late TextEditingController password = TextEditingController();
  GlobalKey<FormState> formState = GlobalKey();
  bool isLoadingWithEmailAndPassword = false;
  bool isLoadingWithGoogle = false;

  Future signInWithGoogle() async {
    // Trigger the authentication flow
    isLoadingWithGoogle = true;
    setState(() {});
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      isLoadingWithGoogle = false;
      setState(() {});
      return;
    }

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    await FirebaseAuth.instance.signInWithCredential(credential);
    isLoadingWithGoogle = false;
    setState(() {});

    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => HomePage()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
        key: formState,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: ListView(
            children: [
              Center(
                child: CustomeLogo(),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Login",
                  style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Login To Continue Using The App",
                  style: TextStyle(fontSize: 16, color: Colors.grey[500]),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Email",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomeTextFormField(
                hint: "Enter Your Email",
                myController: email,
              ),
              const SizedBox(
                height: 20,
              ),
              Container(
                alignment: Alignment.centerLeft,
                child: const Text(
                  "Password",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              CustomeTextFormField(
                hint: "Enter Your Password",
                myController: password,
              ),
              const SizedBox(
                height: 5,
              ),
              InkWell(
                onTap: () async {
                  if (email.text == "") {
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Email Not Valid!',
                      desc:
                          'Please enter a valid email so that we can sent to you the reset message.',
                      btnOkOnPress: () {},
                    ).show();
                    return;
                  }
                  try {
                    await FirebaseAuth.instance
                        .sendPasswordResetEmail(email: email.text);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.info,
                      animType: AnimType.rightSlide,
                      title: 'Reset Password message',
                      desc:
                          'Please Reset you Password by click on the link sented to your email.',
                      btnOkOnPress: () {},
                    ).show();
                  } catch (e) {
                    print(e);
                    AwesomeDialog(
                      context: context,
                      dialogType: DialogType.error,
                      animType: AnimType.rightSlide,
                      title: 'Error',
                      desc: "${e}",
                      btnOkOnPress: () {},
                    ).show();
                  }
                },
                child: Container(
                  alignment: Alignment.centerRight,
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              CustomeAuthButton(
                  text: "Login",
                  color: Colors.orange,
                  isLoading: isLoadingWithEmailAndPassword,
                  onPressed: () async {
                    if (formState.currentState!.validate()) {
                      try {
                        isLoadingWithEmailAndPassword = true;
                        setState(() {});
                        final credential = await FirebaseAuth.instance
                            .signInWithEmailAndPassword(
                                email: email.text, password: password.text);

                        if (credential.user!.emailVerified) {
                          Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                  builder: (context) => HomePage()));
                        } else {
                          FirebaseAuth.instance.currentUser!
                              .sendEmailVerification();

                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.info,
                            animType: AnimType.rightSlide,
                            title: 'Email verified message',
                            desc:
                                'Please verified you email by click on the link sented to your email.',
                            btnOkOnPress: () {},
                          ).show();
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          print('No user found for that email.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Email not found!',
                            desc: 'No user found for that email.',
                            btnOkOnPress: () {},
                          ).show();
                        } else if (e.code == 'wrong-password') {
                          print('Wrong password provided for that user.');
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Wrong Password',
                            desc: 'Wrong password provided for that user.',
                            btnOkOnPress: () {},
                          ).show();
                        } else {
                          print(e.code);
                          print(e);
                          AwesomeDialog(
                            context: context,
                            dialogType: DialogType.error,
                            animType: AnimType.rightSlide,
                            title: 'Error',
                            desc: "$e",
                            btnOkOnPress: () {},
                          ).show();
                        }
                      }
                    } else {
                      print("Not valid");
                    }
                    isLoadingWithEmailAndPassword = false;
                    setState(() {});
                  }),
              const SizedBox(
                height: 15,
              ),
              CustomeAuthButtonIcon(
                  text: "Login With Google",
                  color: Color.fromARGB(255, 187, 25, 14),
                  icon: "images/4.png",
                  isLoading: isLoadingWithGoogle,
                  onPressed: () {
                    signInWithGoogle();
                  }),
              const SizedBox(
                height: 15,
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Signup()));
                },
                child: Text.rich(
                  TextSpan(children: [
                    TextSpan(text: "Don't Have An Account? "),
                    TextSpan(
                        text: "Register",
                        style: TextStyle(
                            color: Colors.orange, fontWeight: FontWeight.bold))
                  ]),
                  style: TextStyle(fontSize: 18),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
