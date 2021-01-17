import 'package:flutter/material.dart';
import 'package:doginer/screens/login.dart';
import 'package:doginer/common/theme.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:doginer/auth/sign_in.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';

class SignUpPage extends StatefulWidget {
  static String tag = 'register-page';
  @override
  _SignUpPage createState() => new _SignUpPage();
}

class _SignUpPage extends State<SignUpPage> {

  final _formKey = GlobalKey<FormState>();
  final emailTextEditController = new TextEditingController();
  final passwordTextEditController = new TextEditingController();
  final confirmPasswordTextEditController = new TextEditingController();

  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  final FocusNode _confirmPasswordFocus = FocusNode();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String _errorMessage = '';


  Widget backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget entryField(String title, {bool isPassword = false}) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: () async {
        if (_formKey.currentState.validate()) {
          try{
            await _firebaseAuth
                .createUserWithEmailAndPassword(
                email: emailTextEditController.text,
                password: passwordTextEditController.text);
            Navigator.of(context).pushNamed("/main_page");
          }catch(e){
            print("Register Error: $e");
            String exception = getExceptionText(e);
            Flushbar(
              title: "Register Error",
              message: exception,
              duration: Duration(seconds: 5),
            )..show(context);
          }
          }
      },
      textColor: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80.0)),
      padding: const EdgeInsets.all(0.0),
      child: Ink(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [primaryColor, secondaryColor]),
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
        ),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Register Now',
            style: TextStyle(fontSize: 15),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
              style: TextStyle(
                  color: primaryColor,
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget logo() {
    return Align(
        alignment: Alignment.center,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(bottom:10),
                child: SvgPicture.asset(
                    "assets/dogs/dog-paw.svg"
                )
            ),
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                  text: 'Doginer',
                  style: GoogleFonts.portLligatSans(
                    textStyle: Theme.of(context).textTheme.display1,
                    fontSize: 30,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  )),
            )
          ],
        )
    );
  }

  Widget emailPasswordWidget() {

    var email = Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value.isEmpty || !value.contains('@')) {
            return 'Please enter a valid email.';
          }
          return null;
        },
        controller: emailTextEditController,
        keyboardType: TextInputType.emailAddress,
        autofocus: true,
        textInputAction: TextInputAction.next,
        focusNode: _emailFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context).requestFocus(_passwordFocus);
        },
        decoration: InputDecoration(
          hintText: 'Email',
          contentPadding:
          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );

    var password =     Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        validator: (value) {
          if (value.length < 8) {
            return 'Password must be longer than 8 characters.';
          }
          return null;
        },
        autofocus: false,
        obscureText: true,
        controller: passwordTextEditController,
        textInputAction: TextInputAction.next,
        focusNode: _passwordFocus,
        onFieldSubmitted: (term) {
          FocusScope.of(context)
              .requestFocus(_confirmPasswordFocus);
        },
        decoration: InputDecoration(
          hintText: 'Password',
          contentPadding:
          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );

    var confirmPassword =    Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        autofocus: false,
        obscureText: true,
        controller: confirmPasswordTextEditController,
        focusNode: _confirmPasswordFocus,
        textInputAction: TextInputAction.done,
        validator: (value) {
          if (passwordTextEditController.text != value || value.isEmpty) {
            return 'Passwords do not match.';
          }
          return null;
        },
        decoration: InputDecoration(
          hintText: 'Confirm Password',
          contentPadding:
          EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5.0)),
        ),
      ),
    );
    return Column(
      children: <Widget>[
        email,
        password,
        confirmPassword
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Container(
      decoration: BoxDecoration(
        // Box decoration takes a gradient
          gradient: LinearGradient(
            // Where the linear gradient begins and ends
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            // Add one stop for each color. Stops should increase from 0 to 1
            stops: [0.1, 0.9],
            colors: [
              // Colors are easy thanks to Flutter's Colors class.
              gradientColor1,
              gradientColor2,
            ],
          )
        ),
        height: height,
        child: Stack(
          children: <Widget>[
            Container(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Form(
                key: _formKey,
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      logo(),
                      SizedBox(
                        height: 50,
                      ),
                      emailPasswordWidget(),
                      SizedBox(
                        height: 20,
                      ),
                      submitButton(),
                      SizedBox(height: height * .14),
                      loginAccountLabel(),
                    ],
                  ),
                ),
              )
            ),
            Positioned(top: 40, left: 0, child: backButton()),
          ],
        ),
      ),
    );
  }
}