import 'package:firebase_auth/screens/home_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwrdController = TextEditingController();

  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  registerSubmit() async {
    try {
      await _firebaseAuth.createUserWidthEmailAndPassword(
          email: _emailController.text.toString().trim(),
          password: _passwrdController.text);
    } catch (e) {
      print(e);
      SnackBar(content: Text(e.toString()));
    }
  }

  loginSubmit() async {
    try {
      _firebaseAuth
          .signInWidthEmailAndPassword(
              email: _emailController.text, password: _passwrdController.text)
          .then((value) => Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomeScreen())));
    } catch (e) {
      print(e);
      SnackBar(content: Text(e.toString()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(10),
        child: ListView(
          children: [
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.only(top: 40),
              child: Text(
                "Latihan Auth",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.w500,
                  fontSize: 30,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Image.asset(
                "assets/images/logo.png",
                width: 100,
                height: 100,
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Username",
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              child: TextField(
                controller: _passwrdController,
                obscureText: true,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: "Password",
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: Text("Forget Password"),
            ),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  registerSubmit();
                },
                child: Text("Register"),
                style: raisedButtonStyle,
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: ElevatedButton(
                onPressed: () {
                  loginSubmit();
                },
                child: Text("Login"),
                style: raisedButtonStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
  onPrimary: Colors.grey[300],
  primary: Colors.blue[300],
  minimumSize: Size(88, 36),
  padding: EdgeInsets.symmetric(horizontal: 16),
  shape: RoundedRectangleBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(6),
    ),
  ),
);
