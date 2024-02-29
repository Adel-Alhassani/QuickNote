import 'package:flutter/material.dart';

class CustomeButton extends StatelessWidget {
  final String text;
  final Color color;
  final bool isLoading;

  final VoidCallback onPressed;

  const CustomeButton(
      {super.key,
      required this.text,
      required this.color,
    
      required this.onPressed, required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 150,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        onPressed: onPressed,
        child: isLoading
            ? Container(
                child: CircularProgressIndicator(
                color: Colors.white,
              ))
            : Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "$text",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
          ],
        ),
        color: color,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
    );
  }
}
