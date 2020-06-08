import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:venus/pages/chat.dart';
import 'package:venus/pages/forgot-password.dart';

import 'package:venus/pages/sign-in.dart';
import 'package:venus/pages/sign-up.dart';
import 'package:venus/pages/welcome.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'eChat',
      initialRoute: Welcome.id,
      routes: {
        SignIn.id: (BuildContext context) => SignIn(),
        SignUp.id: (BuildContext context) => SignUp(),
        Welcome.id: (BuildContext context) => Welcome(),
        Chat.id: (BuildContext context) => Chat(),
        ForgotPassword.id: (BuildContext context) => ForgotPassword(),
      },
    );
  }
}
