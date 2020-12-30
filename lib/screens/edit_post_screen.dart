import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:social_network_app/models/user.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/header_widget.dart';
import 'package:social_network_app/widgets/progress_widget.dart';

class EditPostScreen extends StatefulWidget {

  final String postId;
  final String postUrl;
  final String description;
  final String location;
  final User gCurrentUser;

  EditPostScreen({
    Key key,
    this.postId,
    this.postUrl,
    this.description,
    this.location,
    this.gCurrentUser,
  }) : super(key : key);

  @override
  _EditPostScreenState createState() => _EditPostScreenState(postId: postId, postUrl: postUrl, description: description, location: location);
}

class _EditPostScreenState extends State<EditPostScreen> {

  final String postId;
  final String postUrl;
  final String description;
  final String location;

  _EditPostScreenState({
    Key key,
    this.postId,
    this.postUrl,
    this.description,
    this.location,
  });

  TextEditingController descriptionTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();
  bool loading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getAndDisplayPostInformation();
  }

  getAndDisplayPostInformation(){
    setState(() {
      loading = true;
    });

    descriptionTextEditingController.text = description;
    locationTextEditingController.text = location;

    setState(() {
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Edit Post",),
      body: ListView(
        shrinkWrap: true,
        children: <Widget>[
          loading ? linearProgress() : Text(""),
          Container(
            child: Image.network(
                postUrl,
                height: MediaQuery.of(context).size.height * 0.3,
                width: MediaQuery.of(context).size.width * 0.8,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 12.0),
          ),
          ListTile(
            leading: CircleAvatar(
              backgroundImage: CachedNetworkImageProvider(
                currentUser.url,
              ),
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: descriptionTextEditingController,
                decoration: InputDecoration(
                  hintText: "Say something about image.",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Divider(),

          ListTile(
            leading: Icon(
              Icons.person_pin_circle,
              color: Colors.white,
              size: 36.0,
            ),
            title: Container(
              width: 250.0,
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                ),
                controller: locationTextEditingController,
                decoration: InputDecoration(
                  hintText: "Write the location here..",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          Container(
            width: 220.0,
            height: 110.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              color: Colors.green,
              icon: Icon(
                Icons.location_on,
                color: Colors.white,
              ),
              label: Text(
                "Get my current location",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: getUserCurrentLocation,
            ),
          ),
          Container(
            width: 150.0,
            height: 110.0,
            alignment: Alignment.center,
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(35.0),
              ),
              color: Colors.green,
              icon: Icon(
                Icons.update,
                color: Colors.white,
              ),
              label: Text(
                "Update",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onPressed: updatePostData,
            ),
          ),
        ],
      ),
    );
  }

  // function to get current location of user
  getUserCurrentLocation() async{
    Position position = await Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    List<Placemark> placeMarks = await Geolocator().placemarkFromCoordinates(position.latitude, position.longitude);
    Placemark mPlaceMark = placeMarks[0];
    String completeAddressInfo = '${mPlaceMark.subThoroughfare} ${mPlaceMark.thoroughfare}, ${mPlaceMark.subLocality} ${mPlaceMark.locality}, ${mPlaceMark.subAdministrativeArea} ${mPlaceMark.administrativeArea}, ${mPlaceMark.postalCode} ${mPlaceMark.country},';
    String specificAddress = '${mPlaceMark.locality}, ${mPlaceMark.country}';
    locationTextEditingController.text = specificAddress;
  }

  updatePostData(){
    postsReference.document(currentUser.id).collection("usersPosts").document(postId).updateData({
      "description": descriptionTextEditingController.text,
      "location": locationTextEditingController.text,
    });

    SnackBar successSnackBar = SnackBar(content: Text("Post is successfully updated."),);
    Navigator.pop(context);
  }
}
