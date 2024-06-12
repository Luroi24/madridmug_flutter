import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:madridmug_flutter/pages/menu_page.dart';
import 'package:madridmug_flutter/controllers/user.dart' as User1;

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreen createState() => _SignUpScreen();
}
class _SignUpScreen extends State<SignUpScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  void _signUpWithEmailAndPassword() async {
    try {
      final User? user = (await _auth.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      )).user;
      if (user != null) {
        print('Register successful!');
        User1.User.NoData().addUser(user.uid);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MenuPage()),
        );
      } else {
        print('Register failed!');
      }
    } on FirebaseAuthException catch (e) {
      print(e); // Handle the error
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Registrar usuario")),
      body: Column(
        children: <Widget>[
          TextField(
            controller: emailController,
            decoration: InputDecoration(labelText: 'Email'),
          ),
          TextField(
            controller: passwordController,
            decoration: InputDecoration(labelText: 'Password'),
            obscureText: true,
          ),
          ElevatedButton(
            onPressed: _signUpWithEmailAndPassword,
            child: Text('Register'),
          ),
        ],
      ),
    );
  }
}