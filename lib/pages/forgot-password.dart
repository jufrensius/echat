import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Plugins
import 'package:flutter/gestures.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:venus/widgets/CustomSubmitButton.dart';

//Custom Widgets
import 'package:venus/widgets/CustomTextField.dart';

//Pages
import 'package:venus/pages/sign-in.dart';

class ForgotPassword extends StatefulWidget {
  static String id = 'forgot-password';

  ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _fogotPassword = GlobalKey<FormState>();
  TextEditingController emailInputController;

  bool _btnRecoverPassword = false;

  @override
  void initState() {
    emailInputController = new TextEditingController();
    super.initState();
  }

  bool isEmpty() {
    setState(
      () {
        if ((emailInputController.text.trim() != '')) {
          _btnRecoverPassword = true;
        } else {
          _btnRecoverPassword = false;
        }
      },
    );
  }

  bool isLoading = false;

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
                  key: _fogotPassword,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(left: 40.0, right: 40.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Forgot Password',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 26.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 20.0)),
                            Text(
                              'Please enter your email address. A link to create\n'
                              'a new password will be set to your email.',
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14.0,
                              ),
                            ),
                            Padding(padding: EdgeInsets.only(top: 50.0)),
                            CustomTextField(
                              hintText: 'Email',
                              keyboardType: TextInputType.emailAddress,
                              controller: emailInputController,
                              onChanged: (value) => isEmpty(),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        margin:
                            EdgeInsets.only(left: 20.0, top: 50.0, right: 20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            CustomSubmitButton(
                              label: 'Recover password',
                              onPressed: _btnRecoverPassword == true
                                  ? () async {
                                      setState(() {
                                        isLoading = true;
                                      });
                                      try {
                                        await _auth
                                            .sendPasswordResetEmail(
                                                email:
                                                    emailInputController.text)
                                            .then((value) =>
                                                Navigator.pushNamed(
                                                    context, SignIn.id));
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
                                text: 'Don\'t have an Account? ',
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
