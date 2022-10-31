import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("Shared Preferences"),
        ),
        body: HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  Future<void> setIntoSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("email", emailController.text);
    await prefs.setString("password", passwordController.text);
  }

  Future<void> getFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      email = prefs.getString("email");
      password = prefs.getString("password");
    });
  }

  String? email = "";
  String? password = "";

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        TextField(
            controller: emailController,
            decoration: InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5.0)))),
        Padding(padding: EdgeInsets.only(top: 4)),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
              labelText: "Password",
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(5.0))),
        ),
        RaisedButton(
          onPressed: () {
            setIntoSharedPreferences();
          },
          child: Text("Set"),
        ),
        Padding(padding: EdgeInsets.only(top: 8)),
        Text(
          "Your Email: $email",
          style: TextStyle(fontSize: 20),
        ),
        Text(
          "Your Password: $password",
          style: TextStyle(fontSize: 20),
        ),
        RaisedButton(
          onPressed: () {
            getFromSharedPreferences();
          },
          child: Text("Get"),
        ),
      ],
    );
  }
}
