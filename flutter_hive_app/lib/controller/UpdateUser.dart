import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class UpdateUser extends StatelessWidget {
  const UpdateUser({
    Key? key,
    required this.idController,
    required this.namaController,
    required this.userBox,
  }) : super(key: key);

  final TextEditingController idController;
  final TextEditingController namaController;
  final Box<String>? userBox;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (_) {
                return Dialog(
                  child: Container(
                    padding: EdgeInsets.all(32),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: idController,
                          decoration: InputDecoration(
                            labelText: "ID",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        TextField(
                          controller: namaController,
                          decoration: InputDecoration(
                            labelText: "Name",
                            border: OutlineInputBorder(),
                          ),
                        ),
                        SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: () {
                            final key = idController.text;
                            final value = namaController.text;
                            userBox!.put(key, value);
                            Navigator.pop(context);
                          },
                          child: Text("Submit"),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
        child: Text("Update"));
  }
}
