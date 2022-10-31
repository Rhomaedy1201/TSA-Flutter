void _login() async {
  setState(() {
    _isLoading = true;
  });

  var data = {'nis': nis, 'password': password};

  var res = await NetWork().auth(data, '/login');
  var body = json.decode(res.body);
  print(body);
  if (res.statusCode == 200) {
    var data = json.decode(res.body);
  }
}
