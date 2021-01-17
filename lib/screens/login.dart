import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:doginer/screens/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flushbar/flushbar.dart';
import 'package:doginer/common/theme.dart';
import 'package:doginer/auth/sign_in.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:flutter/services.dart';


class LoginPage extends StatefulWidget {
  static String tag = 'login-page';
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  String _errorMessage = '';

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

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

  Widget entryField(String title, TextEditingController controller, {bool isPassword = false}) {
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
          TextFormField(
              controller: controller,
              obscureText: isPassword,
              decoration: InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Future<String> signIn(final String email, final String password) async {
    var user = await _firebaseAuth.signInWithEmailAndPassword(email: email, password: password);
    return user.toString();
  }

  Widget submitButton() {
    return RaisedButton(
      onPressed: () async{
        if (_formKey.currentState.validate()) {
          try{
            await signIn(emailController.text, passwordController.text);
            Navigator.of(context).pushNamed("/main_page");
          }catch(e){
            print("Sign In Error: $e");
            String exception = getExceptionText(e);
            Flushbar(
              title: "Sign In Error",
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
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Color(0xff9a8478).withAlpha(100),
                  offset: Offset(2, 4),
                  blurRadius: 8,
                  spreadRadius: 2)
            ],
            color: Colors.white),
        child: Container(
          constraints: const BoxConstraints(minWidth: 88.0, minHeight: 36.0), // min sizes for Material buttons
          alignment: Alignment.center,
          child: const Text(
            'Login',
            style: TextStyle(fontSize: 20, color: Color(0xff9a8478)),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  Widget divider() {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 20,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          Text('or'),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Divider(
                thickness: 1,
              ),
            ),
          ),
          SizedBox(
            width: 20,
          ),
        ],
      ),
    );
  }

  Widget googleButton() {
    return Container(
      height: 50,
      margin: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: Color(0xff2872ba),
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(width: 6.0, color: Colors.white),
                ),
                child:Image.asset("assets/images/google_logo.png")
            )
          ),
          Expanded(
            flex: 5,
            child: Container(
              alignment: Alignment.center,
              child: Text('Log in with Google',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w400)),
            ),
          ),
        ],
      ),
    );
  }

  Widget createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
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

  Widget emailPasswordWidget(FocusScopeNode node) {

    final email = TextFormField(
      validator: (value) {
        if (value.isEmpty || !value.contains('@')) {
          return 'Please enter a valid email.';
        }
        return null;
      },
      keyboardType: TextInputType.emailAddress,
      autofocus: false,
      controller: emailController,
      decoration: InputDecoration(
        hintText: 'Email',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5)),
      ),
      textInputAction: TextInputAction.next,
      onEditingComplete: () => node.nextFocus(),
    );

    final password = TextFormField(
      autofocus: false,
      obscureText: true,
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter password.';
        }
        return null;
      },
      controller: passwordController,
      textInputAction: TextInputAction.done,
      onFieldSubmitted: (v) {
        FocusScope.of(context).requestFocus(node);
      },
      decoration: InputDecoration(
        hintText: 'Password',
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(5.0)),
      ),
    );

    final errorMessage = Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        '$_errorMessage',
        style: TextStyle(fontSize: 14.0, color: Colors.red),
        textAlign: TextAlign.center,
      ),
    );

    return Column(
      children: <Widget>[
        errorMessage,
        SizedBox(height: 12.0),
        email,
        SizedBox(height: 8.0),
        password,
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;

    final node = FocusScope.of(context);
    String _errorMessage = '';

    void onChange() {
      setState(() {
        _errorMessage = '';
      });
    }
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
                        SizedBox(height: 50),
                        emailPasswordWidget(node),
                        SizedBox(height: 20),
                        submitButton(),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          alignment: Alignment.centerRight,
                          child: Text('Forgot Password ?',
                              style: TextStyle(
                                  fontSize: 14, fontWeight: FontWeight.w500)),
                        ),
                        divider(),
                        SignInButton(
                          Buttons.Google,
                          text: "Sign up with Google",
                          onPressed: () {
                            signInWithGoogle().then((result) {
                              if (result != null) {
                                Navigator.of(context).pushNamed("/main_page");
                              }
                            });
                          },
                        ),
                        SizedBox(height: height * .055),
                        createAccountLabel(),
                      ],
                    ),
                  )
                )
              ),
              Positioned(top: 40, left: 0, child: backButton()),
            ],
          ),
        ));
  }

}

