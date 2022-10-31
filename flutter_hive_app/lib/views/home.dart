import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';
import '../controller/DelUser.dart';
import '../controller/UpdateUser.dart';
import '../controller/addNewUser.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    Key? key,
  }) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Box<String>? userBox;

  final TextEditingController idController = TextEditingController();
  final TextEditingController namaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userBox = Hive.box<String>("Users");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hive DB"),
      ),
      body: Column(
        children: [
          Expanded(
              child: ValueListenableBuilder(
            valueListenable: userBox!.listenable(),
            builder: (context, Box<String> users, _) {
              return ListView.separated(
                itemBuilder: (context, index) {
                  final key = users.keys.toList()[index];
                  final value = users.get(key);

                  return ListTile(
                    title: Text(
                      value!,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    subtitle: Text(
                      key,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                  );
                },
                separatorBuilder: (_, index) => Divider(),
                itemCount: users.keys.toList().length,
              );
            },
          )),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              AddNewUser(
                idController: idController,
                namaController: namaController,
                userBox: userBox,
              ),
              UpdateUser(
                idController: idController,
                namaController: namaController,
                userBox: userBox,
              ),
              DelUser(
                idController: idController,
                userBox: userBox,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
