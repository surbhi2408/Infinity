import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/models/user.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/progress_widget.dart';

class EditProfilePage extends StatefulWidget {

  final String currentOnlineUserId;

  EditProfilePage({this.currentOnlineUserId});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController profileNameTextEditingController = TextEditingController();
  TextEditingController bioTextEditingController = TextEditingController();
  final _scaffoldGlobalKey = GlobalKey<ScaffoldState>();
  bool loading = false;
  User user;
  bool _profileNameValid = true;
  bool _bioValid = true;

  void initState(){
    super.initState();

    getAndDisplayUserInformation();
  }

  // displaying information of user in profile page
  getAndDisplayUserInformation() async{
    setState(() {
      loading = true;
    });

    DocumentSnapshot documentSnapshot = await usersReference.document(widget.currentOnlineUserId).get();
    user = User.fromDocument(documentSnapshot);

    profileNameTextEditingController.text = user.profileName;
    bioTextEditingController.text = user.bio;

    setState(() {
      loading = false;
    });
  }

  // updating users profile name and bio and showing it in snackBar after completion
  updateUserData(){
    setState(() {
      profileNameTextEditingController.text.trim().length < 3 || profileNameTextEditingController.text.isEmpty
          ? _profileNameValid = false
          : _profileNameValid = true;

      bioTextEditingController.text.trim().length > 110 ? _bioValid = false : _bioValid = true;

      if(_profileNameValid && _bioValid){
        usersReference.document(widget.currentOnlineUserId).updateData({
          "profileName": profileNameTextEditingController.text,
          "bio": bioTextEditingController.text,
        });

        SnackBar successSnackBar = SnackBar(content: Text("Profile has been updated successfully."),);
        _scaffoldGlobalKey.currentState.showSnackBar(successSnackBar);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldGlobalKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(
          color: Colors.white,
        ),
        title: Text(
          "Edit Profile",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
                Icons.done,
              color: Colors.white,
              size: 30.0,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
      body: loading ? circularProgress() : ListView(
        children: <Widget>[
          Container(
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 7.0),
                  child: CircleAvatar(
                    radius: 52.0,
                    backgroundImage: CachedNetworkImageProvider(user.url),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      createProfileNameTextFormField(),
                      createBioTextFormField(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 29.0, left: 50.0, right: 50.0),
                  child: RaisedButton(
                    onPressed: updateUserData,
                    child: Text(
                      "Update",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 10.0, left: 50.0, right: 50.0),
                  child: RaisedButton(
                    color: Colors.red,
                    onPressed: logoutUser,
                    child: Text(
                      "LogOut",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  logoutUser() async{
      await gSignIn.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context) => LoginScreen()));
  }

  Column createProfileNameTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Profile Name",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          controller: profileNameTextEditingController,
          decoration: InputDecoration(
            hintText: "Write your profile name here...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            errorText: _profileNameValid ? null : "Profile name is very short",
          ),
        ),
      ],
    );
  }

  Column createBioTextFormField(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(top: 13.0),
          child: Text(
            "Bio",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ),
        TextField(
          style: TextStyle(
            color: Colors.white,
          ),
          controller: bioTextEditingController,
          decoration: InputDecoration(
            hintText: "Write bio here...",
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.grey,
              ),
            ),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Colors.white,
              ),
            ),
            hintStyle: TextStyle(
              color: Colors.grey,
            ),
            errorText: _bioValid ? null : "Bio is too long...",
          ),
        ),
      ],
    );
  }
}
