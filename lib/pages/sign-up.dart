import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Plugins
import 'package:flutter/gestures.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

//Custom Widgets
import 'package:venus/widgets/CustomTextField.dart';
import 'package:venus/widgets/CustomSubmitButton.dart';

//Pages
import 'package:venus/pages/sign-in.dart';
import 'package:venus/pages/chat.dart';

class SignUp extends StatefulWidget {
  static String id = 'sign-up';
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool isLoading = false;
  bool passwordVisible = true;
  bool _btnEnabled = false;
  final _auth = FirebaseAuth.instance;
  FirebaseUser loggedinUser;

  void getCurrentUser() async {
    try {
      final user = await _auth.currentUser();
      if (user != null) {
        loggedinUser = user;
        print(loggedinUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  final GlobalKey<FormState> signUp = GlobalKey<FormState>();
  TextEditingController emailInputController;
  TextEditingController passwordInputController;

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

  @override
  initState() {
    emailInputController = new TextEditingController();
    passwordInputController = new TextEditingController();
    getCurrentUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white12,
        elevation: 0.0,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Color.fromRGBO(112, 189, 165, 1),
                  ),
                ),
              )
            : SingleChildScrollView(
                child: Form(
                  key: signUp,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: <Widget>[
                            Hero(
                              tag: 'logo',
                              child: Image.asset(
                                'assets/images/logo.png',
                                height: 90.0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(bottom: 16.0)),
                            Text(
                              'Sign up',
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 26.0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 32.0)),
                            CustomTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailInputController,
                              onChanged: (value) => isEmpty(),
                            ),
                            CustomTextField(
                              hintText: 'Password',
                              keyboardType: TextInputType.text,
                              controller: passwordInputController,
                              onChanged: (value) => isEmpty(),
                              obscureText: passwordVisible,
                              suffixIcon: IconButton(
                                icon: Icon(passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off),
                                onPressed: () {
                                  setState(() {
                                    passwordVisible = !passwordVisible;
                                  });
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 20.0),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20.0, top: 20.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            CustomSubmitButton(
                              label: 'Sign up',
                              onPressed: _btnEnabled == true
                                  ? () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        final newUser = await _auth
                                            .createUserWithEmailAndPassword(
                                                email:
                                                    emailInputController.text,
                                                password:
                                                    passwordInputController
                                                        .text);
                                        if (newUser != null) {
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Chat.id,
                                              (Route<dynamic> route) => false);
                                        }
                                      } catch (e) {
                                        print(e);
                                      }
                                    }
                                  : null,
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                text: 'Already have an Account? ',
                                style: TextStyle(
                                  fontFamily: 'Roboto Regular',
                                  color: Colors.black,
                                  fontSize: 13.0,
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                    text: 'Sign in',
                                    style: TextStyle(
                                      fontFamily: 'Roboto Regular',
                                      color: Color.fromRGBO(112, 189, 165, 1),
                                      fontSize: 13.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () => Navigator.pushNamed(
                                          context, SignIn.id),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
