import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:surichatapp/weight_room.dart';
import 'package:surichatapp/LoginScreen.dart';


Future main() async {
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp();
   runApp(MyApp());
}

class MyApp extends StatelessWidget
{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
      home: Authentication(),
      );
  }
}

class Authentication extends StatelessWidget
{
  FirebaseAuth auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    if(auth.currentUser != null)
      {
        return WeightRoom();
      }
    else
      {
        return LoginScreen();
      }
  }
}





