import 'package:flutter/material.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/header_widget.dart';
import 'package:social_network_app/widgets/post_widget.dart';
import 'package:social_network_app/widgets/progress_widget.dart';

class PostScreenPage extends StatelessWidget {

  final String userId;
  final String postId;

  PostScreenPage({
    this.userId,
    this.postId,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: postsReference.document(userId).collection("usersPosts").document(postId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }

        Post post = Post.fromDocument(dataSnapshot.data);
        return Center(
          child: Scaffold(
            appBar: header(context, strTitle: post.description),
            body: ListView(
              children: <Widget>[
                Container(
                  child: post,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
