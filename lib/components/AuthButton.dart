import 'package:flutter/material.dart';

class CustomeAuthButton extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomeAuthButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onPressed,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      minWidth: double.infinity,
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
    );
  }
}

class CustomeAuthButtonIcon extends StatelessWidget {
  final String text;
  final Color color;
  final String icon;
  final VoidCallback onPressed;
  final bool isLoading;

  const CustomeAuthButtonIcon(
      {super.key,
      required this.text,
      required this.color,
      required this.icon,
      required this.onPressed,
      required this.isLoading});

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20))),
      minWidth: double.infinity,
      onPressed: onPressed,
      child: isLoading
          ? Container(
              child: CircularProgressIndicator(
              color: Colors.white,
            ))
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Login With Google",
                  style: TextStyle(color: Colors.white, fontSize: 20),
                ),
                Container(
                  margin: const EdgeInsets.only(left: 10),
                  height: 20,
                  width: 20,
                  child: Image.asset(icon),
                )
              ],
            ),
      color: color,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    );
  }
}
