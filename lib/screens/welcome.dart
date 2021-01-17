import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:doginer/common/theme.dart';
import 'package:doginer/screens/login.dart';
import 'package:doginer/screens/signup.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_svg/flutter_svg.dart';

class WelcomePage extends StatelessWidget {
  Widget submitButton(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => LoginPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
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
        child: Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Color(0xff9a8478)),
        ),
      ),
    );
  }

  Widget signUpButton(context) {
    return InkWell(
      onTap: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SignUpPage()));
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: EdgeInsets.symmetric(vertical: 13),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          border: Border.all(color: Colors.white, width: 2),
        ),
        child: Text(
          'Register now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget logo(context) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        child:Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(5)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                    color: Colors.grey.shade200,
                    offset: Offset(2, 4),
                    blurRadius: 5,
                    spreadRadius: 2)
              ],
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [gradientColor1, gradientColor2])),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              logo(context),
              SizedBox(
                height: 80,
              ),
              submitButton(context),
              SizedBox(
                height: 20,
              ),
              signUpButton(context),
            ],
          ),
        ),
      ),
    );
  }
}