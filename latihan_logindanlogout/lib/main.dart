import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:latihan_logindanlogout/dashboard.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: LoginPage(),
      ),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var emailController = TextEditingController();
  var passController = TextEditingController();

  void initState() {
    // TODO: implement initState
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = await pref.getString("login");
    if (val != null) {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Dashboard()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          children: [
            Text(
              "Login",
              style: TextStyle(fontSize: 35),
            ),
            SizedBox(
              height: 20,
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(
                  labelText: "Email",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.email)),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              controller: passController,
              obscureText: true,
              decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.password)),
            ),
            SizedBox(
              height: 20,
            ),
            OutlinedButton.icon(
                onPressed: () {
                  login();
                },
                icon: Icon(Icons.login),
                label: Text("Login"))
          ],
        ),
      ),
    );
  }

  void login() async {
    if (passController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(Uri.parse("https://reqres.in/api/login"),
          body: ({
            "email": emailController.text,
            "password": passController.text
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);
        print("Login Token " + body["token"]);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Token: ${body['token']}")));
        pageRoute(body['token']);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Invalid Credential")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Blank Value Found")));
    }
  }

  void pageRoute(String token) async {
    //menyimpan nilai token pada shared preferences
    SharedPreferences.setMockInitialValues({});
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString("login", token);
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => Dashboard()));
  }
}
