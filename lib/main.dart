import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:loginapp/auth/Login.dart';
import 'package:loginapp/auth/SingUp.dart';
import 'package:loginapp/control/addNot.dart';
import 'package:loginapp/home/homePage.dart';

bool isSingIn = false;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  var user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    isSingIn = false;
  } else {
    isSingIn = true;
  }
  runApp(mainApp());
}

class mainApp extends StatelessWidget {
  const mainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.blue,
        buttonColor: Colors.blue,
        textTheme: TextTheme(
            headline4: TextStyle(fontSize: 20, color: Colors.white),
            headline5: TextStyle(
              fontSize: 25,
              color: Color(0xFFD8655D),
              fontWeight: FontWeight.bold,
            )),
      ),
      home: isSingIn == false ? Login() : homePage(),
      routes: {
        "Login": (context) => Login(),
        "SingUp": (context) => SingUp(),
        "homePage": (context) => homePage(),
        "addNot": (context) => addNot()
      },
    );
  }
}
