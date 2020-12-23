import 'package:flutter/material.dart';
import 'package:social_network_app/screens/post_screen_page.dart';
import 'package:social_network_app/widgets/post_widget.dart';

class PostTile extends StatelessWidget {

  final Post post;

  PostTile(this.post);

  displayFullPost(context){
    Navigator.push(context, MaterialPageRoute(builder: (context) => PostScreenPage(postId: post.postId, userId: post.ownerId)));
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => displayFullPost(context),
      child: Image.network(post.url),
    );
  }
}
