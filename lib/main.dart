import 'package:flutter/material.dart';
import 'package:bolao_da_copa/screens/login.dart';
import 'package:bolao_da_copa/screens/register.dart';

void main() {
  runApp(
    MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'login',
        routes: {
          'login': (context) => const MyLogin(),
          'register': (context) => const MyRegister(),
        }),
  );
}
