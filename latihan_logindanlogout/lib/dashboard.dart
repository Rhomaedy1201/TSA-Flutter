import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Dashboard extends StatefulWidget {
  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String token = "";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCred();
  }

  void getCred() async {
    //mendapatkan token dari shared preferences
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString("login")!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: SafeArea(
          child: Center(
            child: Column(
              children: [
                Text("Welcome user"),
                SizedBox(
                  height: 15,
                ),
                Text("Your token: ${token}"),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
