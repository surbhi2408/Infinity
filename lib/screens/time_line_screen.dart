import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/header_widget.dart';
import 'package:social_network_app/widgets/post_widget.dart';
import 'package:social_network_app/widgets/progress_widget.dart';
import 'package:social_network_app/models/user.dart';

class TimeLinePage extends StatefulWidget {

  final User gCurrentUser;

  TimeLinePage({this.gCurrentUser});

  @override
  _TimeLinePageState createState() => _TimeLinePageState();
}

class _TimeLinePageState extends State<TimeLinePage> {

  List<Post> posts;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  List<String> followingsList = [];

  retrieveTimeLine() async{
    QuerySnapshot querySnapshot = await timelineReference
        .document(widget.gCurrentUser.id)
        .collection("timelinePosts")
        .orderBy("timestamp", descending: true)
        .getDocuments();

    List<Post> allPosts = querySnapshot.documents.map((document) => Post.fromDocument(document)).toList();

    setState(() {
      this.posts = allPosts;
    });
  }

  retrieveFollowings() async{
    QuerySnapshot querySnapshot = await followingReference.document(currentUser.id).collection("userFollowing").getDocuments();

    setState(() {
      followingsList = querySnapshot.documents.map((document) => document.documentID).toList();
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    retrieveTimeLine();
    retrieveFollowings();
  }

  createUserTimeline(){
    if(posts == null){
      return circularProgress();
    }
    else{
      return ListView(
        children: posts,
      );
    }
  }


  @override
  Widget build(context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: header(context, isAppTitle: true),
      body: RefreshIndicator(
        child: createUserTimeline(),
        onRefresh: () => retrieveTimeLine(),
      ),
    );
  }
}