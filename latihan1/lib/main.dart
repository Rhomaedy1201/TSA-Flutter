import 'package:flutter/material.dart';

void main() {
  runApp(pageLogin());
}

class pageLogin extends StatelessWidget {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  void cekLogin(String username, String password, BuildContext context) {
    bool status = false;
    if (username == "Admin" && password == "Admin") {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Selamat datang admin"),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Silahkan cek username dan password anda"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: Text("page Login"),
          backgroundColor: Colors.amber,
        ),
        body: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    hintText: "Input Username",
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.all(10),
              ),
              Container(
                child: TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: "Input Password",
                    fillColor: Colors.white,
                    filled: true,
                    border: new OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  ),
                ),
                margin: EdgeInsets.only(left: 10, right: 10),
              ),
              Center(
                child: TextButton(
                  style: TextButton.styleFrom(
                    primary: Colors.white,
                    backgroundColor: Colors.amber,
                    padding: EdgeInsets.only(
                      left: 70,
                      right: 70,
                      top: 10,
                      bottom: 10,
                    ),
                  ),
                  onPressed: () {
                    String username = usernameController.text;
                    String password = passwordController.text;
                    cekLogin(username, password, context);
                    // print("username : $username, password: $password");
                  },
                  child: Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
