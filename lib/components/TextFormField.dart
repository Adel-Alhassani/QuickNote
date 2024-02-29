import 'package:flutter/material.dart';

class CustomeTextFormField extends StatelessWidget {
  final String hint;
  final TextEditingController myController;
  const CustomeTextFormField(
      {super.key, required this.hint, required this.myController});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: myController,
      validator: (value) {
        if (value == "") {
          return "Field cannot be empty!";
        }
      },
      decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)))),
    );
  }
}
