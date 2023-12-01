import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:appagro/screens/login.dart';
import 'package:appagro/screens/home.dart';

void main() async {
  // Configuração e credenciais do Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyD2PMFGzr8ZCv-vUChjwKweIvnP5fGXwQE",
        authDomain: "appagro-91fbf.firebaseapp.com",
        projectId: "appagro-91fbf",
        storageBucket: "appagro-91fbf.appspot.com",
        messagingSenderId: "904452878466",
        appId: "1:904452878466:web:9bd6ffee8f94c370ffc49b"),
  );
  runApp(MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: _auth.currentUser != null ? HomeScreen() : LoginScreen(),
    );
  }
}