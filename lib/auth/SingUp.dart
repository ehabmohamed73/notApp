import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final SingUpKey = GlobalKey<FormState>();
  String? username, email, password;

  //Sin Up with Email
  SingUpWithEmail() async {
    var formData = SingUpKey.currentState;
    if (formData!.validate()) {
      formData.save();
      try {
        final credential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(
                email: email.toString(), password: password.toString());

        return credential;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          AwesomeDialog(
              context: context,
              title: "PassWord",
              body: Text("The password provided is too weak"))
            ..show();
        } else if (e.code == 'email-already-in-use') {
          AwesomeDialog(
              context: context,
              title: "PassWord",
              btnOkOnPress: () {},
              btnCancelOnPress: () {},
              body: Text("The account already exists for that email."))
            ..show();
        }
      } catch (e) {
        print(e);
      }
    } else {
      print("not Valid");
    }
  }

  //Sin UP with Google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            child: Column(
              children: <Widget>[
                Container(
                  height: 400,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage('assets/images/background.png'),
                          fit: BoxFit.fill)),
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                        left: 30,
                        width: 80,
                        height: 200,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-1.png'))),
                        ),
                      ),
                      Positioned(
                        left: 140,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/light-2.png'))),
                        ),
                      ),
                      Positioned(
                        right: 40,
                        top: 40,
                        width: 80,
                        height: 150,
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image:
                                      AssetImage('assets/images/clock.png'))),
                        ),
                      ),
                      Positioned(
                        child: Container(
                          margin: EdgeInsets.only(top: 50),
                          child: Center(
                            child: Text(
                              "SingUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 40,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(30.0),
                  child: Column(
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromRGBO(143, 148, 251, .2),
                                  blurRadius: 20.0,
                                  offset: Offset(0, 10))
                            ]),
                        child: Form(
                          key: SingUpKey,
                          child: Column(
                            children: <Widget>[
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.length > 100) {
                                      return "can't be more than 100 letters";
                                    }
                                    if (value.length < 2) {
                                      return "can't be less than 2 letters";
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    username = newValue!;
                                  },
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontFamily: "arile"),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "UserName",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.length > 100) {
                                      return "can't be more than 100 letters";
                                    }
                                    if (value.length < 2) {
                                      return "can't be less than 2 letters";
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    email = newValue!;
                                  },
                                  keyboardType: TextInputType.emailAddress,
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontFamily: "arile"),
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Email",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                child: TextFormField(
                                  validator: (value) {
                                    if (value!.length > 100) {
                                      return "can't be more than 100 letters";
                                    }
                                    if (value.length < 4) {
                                      return "can't be less than 4 letters";
                                    }

                                    return null;
                                  },
                                  onSaved: (newValue) {
                                    password = newValue!;
                                  },
                                  style: TextStyle(
                                      color: Colors.grey[900],
                                      fontFamily: "arile"),
                                  obscureText: true,
                                  decoration: InputDecoration(
                                      border: InputBorder.none,
                                      hintText: "Password",
                                      hintStyle:
                                          TextStyle(color: Colors.grey[400])),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      InkWell(
                        onTap: () async {
                          UserCredential respons = await SingUpWithEmail();
                          if (respons != null) {
                            await FirebaseFirestore.instance
                                .collection("user")
                                .add({"username": username, "email": email});
                            Navigator.of(context)
                                .pushReplacementNamed("homePage");
                          }
                        },
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              gradient: LinearGradient(colors: [
                                Color.fromRGBO(143, 148, 251, 1),
                                Color.fromRGBO(143, 148, 251, .6),
                              ])),
                          child: Center(
                            child: Text(
                              "SingUp",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                          padding: EdgeInsets.only(left: 10),
                          child: Row(
                            children: [
                              const Text(
                                "have Account",
                                style: TextStyle(
                                    color: Color.fromRGBO(143, 148, 251, 1)),
                              ),
                              InkWell(
                                onTap: (() {
                                  Navigator.of(context)
                                      .pushReplacementNamed("Login");
                                }),
                                child: const Text(
                                  "Sing UP",
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 143, 220, 251)),
                                ),
                              ),
                            ],
                          )),
                      SizedBox(height: 20),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        Color.fromARGB(190, 143, 148, 251)),
                                child: Icon(FontAwesomeIcons.google),
                                onPressed: () async {
                                  UserCredential cred =
                                      await signInWithGoogle();
                                  print(cred.additionalUserInfo);
                                },
                              ),
                            ),
                            Container(
                              width: 100,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary:
                                        Color.fromARGB(190, 143, 148, 251)),
                                child: Icon(Icons.facebook_outlined),
                                onPressed: () async {
                                  UserCredential cred =
                                      await signInWithGoogle();
                                  print(cred);
                                },
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }
}
