import 'package:flutter/material.dart';
import 'package:social_network_app/widgets/post_widget.dart';

class PostTile extends StatelessWidget {

  final Post post;

  PostTile(this.post);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.network(post.url),
    );
  }
}
