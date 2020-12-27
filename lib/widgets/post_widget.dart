import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_share/flutter_share.dart';
import 'package:giffy_dialog/giffy_dialog.dart';
import 'package:social_network_app/models/user.dart';
import 'package:social_network_app/screens/comments_page.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/screens/profile_page.dart';
import 'package:social_network_app/widgets/progress_widget.dart';

class Post extends StatefulWidget {

  final String postId;
  final String ownerId;
  final dynamic likes;
  final String username;
  final String description;
  final String location;
  final String url;

  Post({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
  });

  factory Post.fromDocument(DocumentSnapshot documentSnapshot){
    return Post(
      postId: documentSnapshot["postId"],
      ownerId: documentSnapshot["ownerId"],
      likes: documentSnapshot["likes"],
      username: documentSnapshot["username"],
      description: documentSnapshot["description"],
      location: documentSnapshot["location"],
      url: documentSnapshot["url"],
    );
  }

  int getTotalNumberOfLikes(likes){
    if(likes == null){
      return 0;
    }

    int counter = 0;
    likes.values.forEach((eachValue){
      if(eachValue == true){
        counter = counter + 1;
      }
    });
    return counter;
  }

  @override
  _PostState createState() => _PostState(
    postId: this.postId,
    ownerId: this.ownerId,
    likes: this.likes,
    username: this.username,
    description: this.description,
    location: this.location,
    url: this.url,
    likeCount: getTotalNumberOfLikes(this.likes),
  );
}

class _PostState extends State<Post> {

  final String postId;
  final String ownerId;
  Map likes;
  final String username;
  final String description;
  final String location;
  final String url;
  int likeCount;
  bool isLiked;
  bool showHeart = false;
  final String currentOnlineUserId = currentUser?.id;

  _PostState({
    this.postId,
    this.ownerId,
    this.likes,
    this.username,
    this.description,
    this.location,
    this.url,
    this.likeCount,
  });

  @override
  Widget build(BuildContext context) {

    isLiked = (likes[currentOnlineUserId] == true);

    return Padding(
      padding: EdgeInsets.only(bottom: 12.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          createPostHead(),
          createPostPicture(),
          createPostFooter(),
        ],
      ),
    );
  }

  // creating head of the post that are shown in timeline
  createPostHead(){
    return FutureBuilder(
      future: usersReference.document(ownerId).get(),
      builder: (context, dataSnapshot){
        if(!dataSnapshot.hasData){
          return circularProgress();
        }
        User user = User.fromDocument(dataSnapshot.data);
        bool isPostOwner = currentOnlineUserId == ownerId;
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: CachedNetworkImageProvider(
              user.url,
            ),
            backgroundColor: Colors.grey,
          ),
          title: GestureDetector(
            onTap: () => displayUserProfile(context, userProfileId: user.id),
            child: Text(
              user.username,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          subtitle: Text(
            location,
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          trailing: isPostOwner ? IconButton(
            icon: Icon(
              Icons.more_vert,
              color: Colors.white,
            ),
            onPressed: () => showingBottomSheet(),
          ) : Text(""),
        );
      },
    );
  }

  // opening bottom modal sheet to perform various options
  showingBottomSheet(){
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black45,
      builder: (context){
        return Column(
          children: <Widget>[
            ListTile(
              leading: Icon(
                  Icons.delete,
                color: Colors.white,
              ),
              title: Text(
                  "Delete Post",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => controlPostDelete(context),
            ),

            ListTile(
              leading: Icon(
                Icons.share,
                color: Colors.white,
              ),
              title: Text(
                "Share Post",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: (){
                Navigator.pop(context);
                controlSharePosts();
              }
            ),

            ListTile(
              leading: Icon(
                Icons.edit,
                color: Colors.white,
              ),
              title: Text(
                "Edit Post",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
              onTap: () => print("edit clicked"),
              //onTap: () => controlPostEdit(context),
            ),
          ],
        );
      }
    );
  }

  // controlling post delete option
  controlPostDelete(BuildContext mContext){
    Navigator.pop(context);
    return showDialog(
      context: mContext,
      builder: (context){
        return AssetGiffyDialog(
          buttonCancelColor: Colors.black45,
          buttonOkColor: Colors.redAccent,
          image: Image.asset("assets/images/delete.gif"),
          title: Text(
            "Delete this Post",
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          description: Text(
            "Do you want to delete this post? Warning: This post will be permanently deleted from your profile.",
            textAlign: TextAlign.center,
          ),
          entryAnimation: EntryAnimation.DEFAULT,
          onOkButtonPressed: (){
            Navigator.pop(context);
            removeUserPost();
          },
        );
        // return SimpleDialog(
        //   title: Text(
        //     "What do you want?",
        //     style: TextStyle(
        //       color: Colors.white,
        //     ),
        //   ),
        //   children: <Widget>[
        //     SimpleDialogOption(
        //       child: Text(
        //         "Delete",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       onPressed: (){
        //         Navigator.pop(context);
        //         removeUserPost(),
        //       },
        //     ),
        //     SimpleDialogOption(
        //       child: Text(
        //         "Cancel",
        //         style: TextStyle(
        //           color: Colors.white,
        //           fontWeight: FontWeight.bold,
        //         ),
        //       ),
        //       onPressed: () => Navigator.pop(context),
        //     ),
        //   ],
        // );
      }
    );
  }

  // removing post permanently from the firebase storage
  removeUserPost() async{
    postsReference.document(ownerId).collection("usersPosts").document(postId).get().then((document){
      if(document.exists){
        document.reference.delete();
      }
    });

    storageReference.child("post_$postId.jpg").delete();

    QuerySnapshot querySnapshot = await activityFeedReference
        .document(ownerId)
        .collection("feedItems")
        .where("postId", isEqualTo: postId)
        .getDocuments();

    querySnapshot.documents.forEach((document) {
      if(document.exists){
        document.reference.delete();
      }
    });

    QuerySnapshot commentsQuerySnapshot = await commentsReference.document(postId).collection("comments").getDocuments();

    commentsQuerySnapshot.documents.forEach((document) {
      if(document.exists){
        document.reference.delete();
      }
    });
  }

  displayUserProfile(BuildContext context, {String userProfileId}){
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => ProfilePage(userProfileId: userProfileId,),
    ));
  }

  removeLike(){
    bool isNotPostOwner = currentOnlineUserId != ownerId;

    if(isNotPostOwner){
      activityFeedReference.document(ownerId).collection("feedItems").document(postId).get().then((document){
        if(document.exists){
          document.reference.delete();
        }
      });
    }
  }

  addLike(){
    bool isNotPostOwner = currentOnlineUserId != ownerId;
    if(isNotPostOwner){
      activityFeedReference.document(ownerId).collection("feedItems").document(postId).setData({
        "type": "like",
        "username": currentUser.username,
        "userId": currentUser.id,
        "timestamp": DateTime.now(),
        "url": url,
        "postId": postId,
        "userProfileImg": currentUser.url,
      });
    }
  }

  // function to control likes and dislikes of a post
  controlUserLikedPost(){
    bool _liked = likes[currentOnlineUserId] == true;
    if(_liked){
      postsReference.document(ownerId).collection("usersPosts").document(postId).updateData({
        "likes.$currentOnlineUserId": false,
      });
      removeLike();
      setState(() {
        likeCount = likeCount - 1;
        isLiked = false;
        likes[currentOnlineUserId] = false;
      });
    }
    else if(!_liked){
      postsReference.document(ownerId).collection("usersPosts").document(postId).updateData({
        "likes.$currentOnlineUserId": true,
      });
      addLike();

      setState(() {
        likeCount = likeCount + 1;
        isLiked = true;
        likes[currentOnlineUserId] = true;
        showHeart = true;
      });
      Timer(Duration(milliseconds: 800), (){
        setState(() {
          showHeart = false;
        });
      });
    }
  }

  // creating post picture field just after head of the post
  createPostPicture(){
    return GestureDetector(
      onDoubleTap: () => controlUserLikedPost,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          //cachedNetworkImage(url),
          Image.network(url),
          showHeart
              ? Icon(
              Icons.favorite,
            size: 100.0,
            color: Colors.white,
          )
              : Text(""),
        ],
      ),
    );
  }

  // footer of the post where user can see number of liked posts and comments
  createPostFooter(){
    return Column(
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 40.0, left: 20.0),
            ),
            GestureDetector(
              onTap: () => controlUserLikedPost(),
              child: Icon(
                isLiked ? Icons.favorite : Icons.favorite_border,
                size: 28.0,
                color: Colors.red,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            GestureDetector(
              onTap: () => displayComments(context, postId: postId, ownerId: ownerId, url: url),
              child: Icon(
                Icons.chat_bubble_outline,
                size: 28.0,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 20.0),
            ),
            GestureDetector(
              onTap: () => controlSharePosts(),
              child: Icon(
                Icons.share,
                size: 28.0,
                color: Colors.white,
              ),
            ),
          ],
        ),

        // row where likes are displayed
        Row(
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                "$likeCount likes",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),

        // row where description of the post is displayed
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(left: 20.0),
              child: Text(
                  "$username  ",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Text(
                description,
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // sharing posts to other social media
  controlSharePosts(){
    //final RenderBox box = context.findRenderObject();
    FlutterShare.share(
      title: 'SocioApp',
      text: description,
      linkUrl: url,
      chooserTitle: 'Where you want to Share',
    );
  }

  displayComments(BuildContext context, {String postId, String ownerId, String url}){
    Navigator.push(context, MaterialPageRoute(
      builder: (context){
        return CommentsPage(postId: postId, postOwnerId: ownerId, postImageUrl: url,);
      }
    ));
  }
}
