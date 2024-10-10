import 'package:flutter/material.dart';

Widget filds(BuildContext context, TextEditingController controller,
    String hint, double width, double height) {
  return Container(
    width: MediaQuery.of(context).size.width * width,
    height: MediaQuery.of(context).size.height * height,
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
          hintText: hint,
          enabledBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(color: Colors.transparent),
              borderRadius: BorderRadius.all(Radius.circular(5))),
          filled: true,
          contentPadding: EdgeInsets.all(20),
          fillColor: Colors.grey.withOpacity(0.6)),
    ),
  );
}
