import 'package:flutter/material.dart';

Widget buttonIcon(IconData icon) {
  return Container(
    height: 60,
    width: 60,
    padding: EdgeInsets.all(4),
    child: Icon(icon, color: Color(0xff33ffcc)),
    decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(30)), color: Colors.black,)
  );
}