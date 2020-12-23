import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/header_widget.dart';
import 'package:social_network_app/widgets/progress_widget.dart';
import 'package:timeago/timeago.dart' as tAgo;

class CommentsPage extends StatefulWidget {

  final String postId;
  final String postOwnerId;
  final String postImageUrl;

  CommentsPage({
    this.postId,
    this.postOwnerId,
    this.postImageUrl,
  });

  @override
  _CommentsPageState createState() => _CommentsPageState(postId: postId, postOwnerId: postOwnerId, postImageUrl: postImageUrl);
}

class _CommentsPageState extends State<CommentsPage> {

  final String postId;
  final String postOwnerId;
  final String postImageUrl;
  TextEditingController commentTextEditingController = TextEditingController();

  _CommentsPageState({
    this.postId,
    this.postOwnerId,
    this.postImageUrl,
  });

  // function where comments are displayed
  retrieveComments(){
    return StreamBuilder(
      stream: commentsReference.document(postId).collection("comments").orderBy("timestamp",descending: false).snapshots(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        List<Comment> comments = [];
        dataSnapshot.data.documents.forEach((document){
          comments.add(Comment.fromDocument(document));
        });
        return ListView(
          children: comments,
        );
      },
    );
  }

  // after clicking to post, comment is saved to fireStore
  saveComment(){
    commentsReference.document(postId).collection("comments").add({
      "username": currentUser.username,
      "comment": commentTextEditingController.text,
      "timestamp": DateTime.now(),
      "url": currentUser.url,
      "userId": currentUser.id,
    });

    bool isNotPostOwner = postOwnerId != currentUser.id;
    if(isNotPostOwner){
      activityFeedReference.document(postOwnerId).collection("feedItems").add({
        "type": "comment",
        "commentDate": timestamp,
        "postId": postId,
        "userId": currentUser.id,
        "username": currentUser.username,
        "userProfileImg": currentUser.url,
        "url": postImageUrl,
      });
    }
    commentTextEditingController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: retrieveComments(),
          ),
          Divider(),
          ListTile(
            title: TextFormField(
              controller: commentTextEditingController,
              decoration: InputDecoration(
                labelText: "Write comment here...",
                labelStyle: TextStyle(
                  color: Colors.white,
                ),
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
              ),
              style: TextStyle(
                color: Colors.white,
              ),
            ),
            trailing: OutlineButton(
              onPressed: saveComment,
              borderSide: BorderSide.none,
              child: Text(
                  "Post",
                style: TextStyle(
                  color: Colors.lightGreenAccent,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {

  final String username;
  final String userId;
  final String url;
  final String comment;
  final Timestamp timestamp;

  Comment({
    this.username,
    this.userId,
    this.url,
    this.comment,
    this.timestamp,
  });

  factory Comment.fromDocument(DocumentSnapshot documentSnapshot){
    return Comment(
      username: documentSnapshot["username"],
      userId: documentSnapshot["userId"],
      url: documentSnapshot["url"],
      comment: documentSnapshot["comment"],
      timestamp: documentSnapshot["timestamp"],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 6.0),
      child: Container(
        color: Colors.black,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                username + ":  " + comment,
                style: TextStyle(
                  fontSize: 18.0,
                  color: Colors.white,
                ),
              ),
              leading: CircleAvatar(
                backgroundImage: CachedNetworkImageProvider(url),
              ),
              subtitle: Text(
                tAgo.format(timestamp.toDate()),
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Divider(height: 1.0,),
          ],
        ),
      ),
    );
  }
}

