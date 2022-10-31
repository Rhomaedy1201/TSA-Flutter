import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void _register() async {
  setState(() {
    _isLoading = true;
  });

  var data = {'name': name, 'email': email, 'password': password};

  var res = await NetWork().auth(data, '/register');
  var body = json.decode(res.body);
  if (body['success']) {
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    localStorage.setString('token', json.encode(body['token']));
    localStorage.setString('user', json.encode(body['user']));
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Home(),
      ),
    );
  } else {
    if (body['message']['name'] != null) {
      _showMsg(body['message']['name'][0].toString());
    } else if (body['message']['email'] != null) {
      _showMsg(body['message']['email'][0].toString());
    } else if (body['message']['password'] != null) {
      _showMsg(body['message']['password'][0].toString());
    }
  }

  setState(() {
    _isLoading = false;
  });
}
