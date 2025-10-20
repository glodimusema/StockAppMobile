import 'package:flutter/material.dart';

Widget description(context, name,age) {
  return Scaffold(
    appBar: AppBar(
      title: Text(name.toString()),
    ),
    body: Center(
      child: Text(age.toString()),
    ),
  );
}