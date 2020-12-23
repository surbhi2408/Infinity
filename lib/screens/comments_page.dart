import 'package:flutter/material.dart';
import 'package:social_network_app/widgets/header_widget.dart';

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

  _CommentsPageState({
    this.postId,
    this.postOwnerId,
    this.postImageUrl,
  });

  // function where comments are displayed
  displayComments(){

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "Comments"),
      body: Column(
        children: <Widget>[
          Expanded(
            child: displayComments(),
          ),
        ],
      ),
    );
  }
}

class Comment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

