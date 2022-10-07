// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';

import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:louisianatrail/components/textForm.dart';
import 'package:louisianatrail/variables.dart';
import 'package:flutter/material.dart';

bool logState = false;

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> with TickerProviderStateMixin {
  AnimationController? _controller;
  Animation? _animation;

  late StreamSubscription<bool> _keyboardVisible;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _animation = Tween(begin: 230.0, end: 0.0).animate(_controller!)
      ..addListener(() {
        setState(() {});
      });

    var keyboardVisibilityController = KeyboardVisibilityController();

    _keyboardVisible =
        keyboardVisibilityController.onChange.listen((bool visible) {
      if (visible) {
        _controller!.forward();
      } else {
        _controller!.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller!.dispose();
    _keyboardVisible.cancel();

    super.dispose();
  }

  changeLog(value) {
    setState(() {
      logState = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: InkWell(
            splashColor: Colors.transparent,
            enableFeedback: false,
            onTap: () {
              FocusScope.of(context).requestFocus(FocusNode());
            },
            child: Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary
                  ]),
                ),
                child: Stack(alignment: Alignment.center, children: [
                  Positioned(
                    top: 75,
                    child: SizedBox(
                      width: 200,
                      child: Text("Louisiana Trail",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.headlineLarge),
                    ),
                  ),
                  Positioned(
                    top: _animation!.value,
                    child: Container(
                      padding: EdgeInsets.only(top: 75),
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xfff3f3f3),
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(30),
                              topRight: Radius.circular(30))),
                      child: logState ? Login(changeLog) : Register(changeLog),
                    ),
                  ),
                ])),
          ),
        ));
  }
}

class Login extends StatefulWidget {
  final Function? updateState;
  const Login(this.updateState, {Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  String displayError = "";
  String passwordError = "";

  submit() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      auth
          .signInWithEmailAndPassword(
        email: email!,
        password: password!,
      )
          .catchError((error) {
        // Handle Errors here.
        var errorCode = error.code;
        var errorMessage = error.message;
        if (errorCode == "wrong-password") {
          setState(() {
            passwordError = "Incorrect password";
          });
        } else {
          setState(() {
            displayError = errorMessage;
          });
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
          key: _formKey,
          child: Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text("Hit the trail",
                        style: Theme.of(context).textTheme.labelLarge),
                    SizedBox(height: 15),
                    TextForm(
                      labelText: "Email",
                      prefixIcon: Icons.email,
                      onSaved: (input) => email = input,
                    ),
                    SizedBox(height: 3),
                    displayError.isNotEmpty
                        ? Text(displayError,
                            style: TextStyle(color: Colors.red))
                        : SizedBox(),
                    SizedBox(height: 15),
                    TextForm(
                      labelText: "Password",
                      prefixIcon: Icons.lock,
                      onSaved: (input) => password = input,
                      obscureText: true,
                    ),
                    passwordError.isNotEmpty
                        ? Text(passwordError,
                            style: TextStyle(color: Colors.red))
                        : Text(""),
                    SizedBox(height: 10),
                    ElevatedButton(
                        onPressed: submit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.purple,
                            minimumSize: Size(350, 50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10))),
                        child: Text('Login',
                            style: Theme.of(context).textTheme.displayLarge)),
                    SizedBox(height: 20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Don't have an account?",
                            style: Theme.of(context).textTheme.labelMedium),
                        SizedBox(width: 5),
                        InkWell(
                            onTap: () => widget.updateState!(false),
                            child: Text("Register here",
                                style: Theme.of(context).textTheme.labelSmall))
                      ],
                    )
                  ]))),
    );
  }
}

class Register extends StatefulWidget {
  final Function? updateState;
  const Register(this.updateState, {Key? key}) : super(key: key);

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  String? email, username, password, confirmPassword;

  register() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      auth
          .createUserWithEmailAndPassword(email: email!, password: password!)
          .then((signedUser) {
        usercollection.doc(signedUser.user!.uid).set({
          'username': username,
        });
        database
            .child("users")
            .child(signedUser.user!.uid)
            .set({'username': username});
        auth.signInWithEmailAndPassword(
          email: email!,
          password: password!,
        );
        Navigator.pop(context);
        return {
          auth.currentUser!.updateDisplayName(username),
        };
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Form(
            key: _formKey,
            child: Container(
                margin: EdgeInsets.only(left: 30, right: 30),
                child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text("Sign Up",
                          style: Theme.of(context).textTheme.labelLarge),
                      SizedBox(height: 15),
                      TextForm(
                        labelText: "Username",
                        prefixIcon: Icons.person,
                        onSaved: (input) => username = input,
                        validator: (input) =>
                            !(input!.length > 5) && input.trim().isEmpty
                                ? 'Username Invalid'
                                : null,
                      ),
                      SizedBox(height: 10),
                      TextForm(
                        labelText: "Email",
                        prefixIcon: Icons.email,
                        onSaved: (input) => email = input,
                        validator: (input) => !input!.contains('@')
                            ? 'Please enter a valid email'
                            : null,
                      ),
                      SizedBox(height: 10),
                      TextForm(
                        labelText: "Password",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        onSaved: (input) => password = input,
                        validator: (input) => input!.length < 6
                            ? 'Password must be at least 6 characters'
                            : null,
                      ),
                      SizedBox(height: 10),
                      TextForm(
                        labelText: "Confirm Password",
                        prefixIcon: Icons.lock,
                        obscureText: true,
                        onSaved: (input) => confirmPassword = input,
                        validator: (input) => confirmPassword != password
                            ? 'Passwords must match'
                            : null,
                      ),
                      SizedBox(height: 10),
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.purple,
                                minimumSize: Size(350, 50),
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10))),
                            child: Text('Register',
                                style:
                                    Theme.of(context).textTheme.displayLarge)),
                      ),
                      SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Already have an account?",
                              style: Theme.of(context).textTheme.labelMedium),
                          SizedBox(width: 5),
                          InkWell(
                              onTap: () => widget.updateState!(true),
                              child: Text("Login Here",
                                  style:
                                      Theme.of(context).textTheme.labelSmall))
                        ],
                      )
                    ]))));
  }
}
