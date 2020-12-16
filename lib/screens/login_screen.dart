import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isSignedIn = false;

  Widget buildHomeScreen(){
    return Text("Already signed in.");
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "SocioApp",
              style: TextStyle(
                fontSize: 30.0,
                color: Colors.white,
                fontFamily: "Signatra"
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            SvgPicture.asset(
                "assets/images/login.svg",
              height: MediaQuery.of(context).size.height * 0.4,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03,),
            GestureDetector(
              onTap: () => "button clicked",
              child: Container(
                width: 270.0,
                height: 65.0,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/GoogleSignIn.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if(isSignedIn){
      return buildHomeScreen();
    }
    else{
      return buildSignInScreen();
    }
  }
}
