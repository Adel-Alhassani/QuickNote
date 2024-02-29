import 'package:flutter/material.dart';

class CustomeLogo extends StatelessWidget {
  const CustomeLogo({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      width: 100,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: const BorderRadius.all(Radius.circular(60))),
      child: Image.asset(
        "images/logo.png",
      ),
    );
  }
}
