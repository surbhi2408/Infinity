import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:social_network_app/screens/Notifications_page.dart';
import 'package:social_network_app/screens/Upload_page.dart';
import 'package:social_network_app/screens/profile_page.dart';
import 'package:social_network_app/screens/search_screen.dart';
import 'package:social_network_app/screens/time_line_screen.dart';

final GoogleSignIn gSignIn = GoogleSignIn();

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  bool isSignedIn = false;
  PageController pageController;
  int getPageIndex = 0;

  // function for checking whether user is logged in or not
  void initState(){
    super.initState();

    pageController = PageController();

    gSignIn.onCurrentUserChanged.listen((gSignInAccount) {
      controlSignIn(gSignInAccount);
    }, onError: (gError){
      print("Error Message: " + gError);
    });

    gSignIn.signInSilently(suppressErrors: false).then((gSignInAccount){
      controlSignIn(gSignInAccount);
    }).catchError((gError){
      print("Error Message: " + gError);
    });
  }

  controlSignIn(GoogleSignInAccount signInAccount) async{
    if(signInAccount != null){
      setState(() {
        isSignedIn = true;
      });
    }
    else{
      setState(() {
        isSignedIn = false;
      });
    }
  }

  void dispose(){
    pageController.dispose();
    super.dispose();
  }

  loginUser(){
    gSignIn.signIn();
  }

  logoutUser(){
    gSignIn.signOut();
  }

  whenPageChanges(int pageIndex){
    setState(() {
      this.getPageIndex = pageIndex;
    });
  }

  onTapChangePage(int pageIndex){
    pageController.animateToPage(pageIndex, duration: Duration(milliseconds: 150), curve: Curves.bounceInOut);
  }

  Scaffold buildHomeScreen(){
    return Scaffold(
      body: PageView(
        children: <Widget>[
          TimeLinePage(),
          SearchScreen(),
          UploadPage(),
          NotificationsPage(),
          ProfilePage(),
        ],
        controller: pageController,
        onPageChanged: whenPageChanges,
        physics: NeverScrollableScrollPhysics(),
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: getPageIndex,
        onTap: onTapChangePage,
        color: Colors.black,
        backgroundColor: Colors.grey,
        buttonBackgroundColor: Colors.black,
        height: 55,
        items: <Widget>[
          Icon(Icons.home, size: 20, color: Colors.white,),
          Icon(Icons.search, size: 20, color: Colors.white,),
          Icon(Icons.photo_camera, size: 37, color: Colors.white,),
          Icon(Icons.favorite, size: 20, color: Colors.white,),
          Icon(Icons.person, size: 20, color: Colors.white,),
        ],
      ),
    );
    // return RaisedButton.icon(
    //   onPressed: logoutUser,
    //   icon: Icon(Icons.exit_to_app),
    //   label: Text("Sign Out"),
    // );
  }

  Scaffold buildSignInScreen(){
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [Theme.of(context).accentColor, Theme.of(context).primaryColor],
          ),
        ),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "SocioApp",
              style: TextStyle(
                fontSize: 45.0,
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
              onTap: loginUser,
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
