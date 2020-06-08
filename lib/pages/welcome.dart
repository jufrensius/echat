import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Plugins
import 'package:firebase_auth/firebase_auth.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

//Custom Widgets
import 'package:venus/widgets/CustomTextField.dart';
import 'package:venus/widgets/CustomSubmitButton.dart';

//Pages
import 'package:venus/pages/sign-up.dart';
import 'package:venus/pages/sign-in.dart';

class Welcome extends StatefulWidget {
  static String id = 'welcome';
  @override
  _WelcomeState createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final _auth = FirebaseAuth.instance;

  final GlobalKey<FormState> signIn = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

  bool _btnEnabled = false;

  bool passwordVisible = true;

  void passwordState() {
    passwordVisible = true;
    super.initState();
  }

  bool isEmpty() {
    setState(() {
      if ((emailInputController.text.trim() != '') &&
          (passwordInputController.text.trim() != '')) {
        _btnEnabled = true;
      } else {
        _btnEnabled = false;
      }
    });
  }

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.red.shade900,
                  ),
                ),
              )
            : Form(
                key: signIn,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Hero(
                          tag: 'logo',
                          child: Image.asset(
                            'assets/images/logo.png',
                            height: 70.0,
                          ),
                        ),
                        Padding(padding: EdgeInsets.only(right: 16.0)),
                        TypewriterAnimatedTextKit(
                          text: ['eChat'],
                          textAlign: TextAlign.start,
                          textStyle: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 64.0,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      margin: EdgeInsets.all(32.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          CustomSubmitButton(
                            label: 'Sign in',
                            onPressed: () =>
                                Navigator.pushNamed(context, SignIn.id),
                          ),
                          Padding(padding: EdgeInsets.only(top: 32.0)),
                          CustomSubmitButton(
                            label: 'Sign up',
                            onPressed: () =>
                                Navigator.pushNamed(context, SignUp.id),
                          ),
                        ],
                      ),
                    ),
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        text: 'Created by ',
                        style: TextStyle(
                          fontFamily: 'Roboto Regular',
                          color: Colors.black,
                          fontSize: 13.0,
                        ),
                        children: <TextSpan>[
                          TextSpan(
                            text: 'Jufrensius Antony Barasa',
                            style: TextStyle(
                              fontFamily: 'Roboto Regular',
                              color: Color.fromRGBO(112, 189, 165, 1),
                              fontSize: 13.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
