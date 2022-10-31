import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class DelUser extends StatelessWidget {
  const DelUser({
    Key? key,
    required this.idController,
    required this.userBox,
  }) : super(key: key);

  final TextEditingController idController;
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
                        ElevatedButton(
                          onPressed: () {
                            final key = idController.text;
                            userBox!.delete(key);
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
        child: Text("Delete"));
  }
}
