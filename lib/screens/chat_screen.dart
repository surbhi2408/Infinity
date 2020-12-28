import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:social_network_app/screens/login_screen.dart';
import 'package:social_network_app/widgets/full_image_widget.dart';
import 'package:social_network_app/widgets/progress_widget.dart';

class Chat extends StatelessWidget {

  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  Chat({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black,
              backgroundImage: CachedNetworkImageProvider(receiverAvatar),
            ),
          ),
        ],
        iconTheme: IconThemeData(
          color:Colors.white,
        ),
        title: Text(
          receiverName,
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: ChatScreen(receiverId: receiverId, receiverAvatar: receiverAvatar, receiverName: receiverName),
    );
  }
}

class ChatScreen extends StatefulWidget {

  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  ChatScreen({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
  }) : super(key : key);

  @override
  _ChatScreenState createState() => _ChatScreenState(receiverId: receiverId, receiverAvatar: receiverAvatar, receiverName: receiverName);
}

class _ChatScreenState extends State<ChatScreen> {

  final String receiverId;
  final String receiverAvatar;
  final String receiverName;

  _ChatScreenState({
    Key key,
    @required this.receiverId,
    @required this.receiverAvatar,
    @required this.receiverName,
  });

  final TextEditingController textEditingController = TextEditingController();
  final ScrollController listScrollController = ScrollController();
  final FocusNode focusNode = FocusNode();
  bool isDisplaySticker;
  bool isLoading;

  File imageFile;
  String imageUrl;

  String chatId;
  //SharedPreferences preferences;
  String id;
  var listMessage;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    focusNode.addListener(onFocusChange);

    isDisplaySticker = false;
    isLoading = false;

    chatId = "";

    readLocal();
  }

  readLocal() async{
    //preferences = await SharedPreferences.getInstance();
    //id = preferences.getString("id") ?? "";
    id = currentUser?.id;

    if(id.hashCode <= receiverId.hashCode){
      chatId = '$id-$receiverId';
    }
    else{
      chatId = '$receiverId-$id';
    }

    usersReference.document(id).updateData({'chattingWith': receiverId});

    setState(() {

    });
  }

  onFocusChange(){
    // hiding the sticker when keyboard appears
    if(focusNode.hasFocus){
      setState(() {
        isDisplaySticker = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              // create list of Messages
              createListMessages(),

              // show stickers
              (isDisplaySticker ? createStickers() : Container()),

              // input controllers
              createInput(),
            ],
          ),
          createLoading(),
        ],
      ),
      onWillPop: onBackPress,
    );
  }

  createLoading(){
    return Positioned(
      child: isLoading ? circularProgress() : Container(),
    );
  }

  Future<bool> onBackPress(){
    if(isDisplaySticker){
      setState(() {
        isDisplaySticker = false;
      });
    }
    else{
      Navigator.pop(context);
    }
    return Future.value(false);
  }

  // function to create stickers or gifs
  createStickers(){
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[

            // first row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("mimi1",2),
                  child: Image.asset(
                    "assets/stickers/mimi1.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi2",2),
                  child: Image.asset(
                    "assets/stickers/mimi2.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi3",2),
                  child: Image.asset(
                    "assets/stickers/mimi3.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 2nd row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("mimi4",2),
                  child: Image.asset(
                    "assets/stickers/mimi4.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi5",2),
                  child: Image.asset(
                    "assets/stickers/mimi5.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi6",2),
                  child: Image.asset(
                    "assets/stickers/mimi6.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 3rd row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("mimi7",2),
                  child: Image.asset(
                    "assets/stickers/mimi7.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi8",2),
                  child: Image.asset(
                    "assets/stickers/mimi8.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi9",2),
                  child: Image.asset(
                    "assets/stickers/mimi9.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 4th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("mimi10",2),
                  child: Image.asset(
                    "assets/stickers/mimi10.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi11",2),
                  child: Image.asset(
                    "assets/stickers/mimi11.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi12",2),
                  child: Image.asset(
                    "assets/stickers/mimi12.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 5th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("mimi13",2),
                  child: Image.asset(
                    "assets/stickers/mimi13.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi14",2),
                  child: Image.asset(
                    "assets/stickers/mimi14.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("mimi15",2),
                  child: Image.asset(
                    "assets/stickers/mimi15.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 6th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("love1",2),
                  child: Image.asset(
                    "assets/stickers/love1.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("love2",2),
                  child: Image.asset(
                    "assets/stickers/love2.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("love3",2),
                  child: Image.asset(
                    "assets/stickers/love3.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 7th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("love4",2),
                  child: Image.asset(
                    "assets/stickers/love4.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("love5",2),
                  child: Image.asset(
                    "assets/stickers/love5.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("love6",2),
                  child: Image.asset(
                    "assets/stickers/love6.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 8th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("love7",2),
                  child: Image.asset(
                    "assets/stickers/love7.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("love8",2),
                  child: Image.asset(
                    "assets/stickers/love8.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("birthday",2),
                  child: Image.asset(
                    "assets/stickers/birthday.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 9th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("emo1",2),
                  child: Image.asset(
                    "assets/stickers/emo1.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo2",2),
                  child: Image.asset(
                    "assets/stickers/emo2.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo3",2),
                  child: Image.asset(
                    "assets/stickers/emo3.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            //10th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("emo4",2),
                  child: Image.asset(
                    "assets/stickers/emo4.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo5",2),
                  child: Image.asset(
                    "assets/stickers/emo5.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo6",2),
                  child: Image.asset(
                    "assets/stickers/emo6.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 11th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("emo7",2),
                  child: Image.asset(
                    "assets/stickers/emo7.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo8",2),
                  child: Image.asset(
                    "assets/stickers/emo8.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo9",2),
                  child: Image.asset(
                    "assets/stickers/emo9.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 12th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("emo10",2),
                  child: Image.asset(
                    "assets/stickers/emo10.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo11",2),
                  child: Image.asset(
                    "assets/stickers/emo11.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo12",2),
                  child: Image.asset(
                    "assets/stickers/emo12.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

            // 13th row
            Row(
              children: <Widget>[
                FlatButton(
                  onPressed: () => onSendMessage("emo13",2),
                  child: Image.asset(
                    "assets/stickers/emo13.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
                FlatButton(
                  onPressed: () => onSendMessage("emo14",2),
                  child: Image.asset(
                    "assets/stickers/emo14.gif",
                    width: 50.0,
                    height: 50.0,
                    fit: BoxFit.cover,
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            ),

          ],
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        ),
      ),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(
          color: Colors.grey,
          width: 0.5,
        )),
        color: Colors.black,
      ),
      padding: EdgeInsets.all(5.0),
      height: 180.0,
    );
  }

  void getSticker(){
    focusNode.unfocus();
    setState(() {
      isDisplaySticker = !isDisplaySticker;
    });
  }

  // function to create message list
  createListMessages(){
    return Flexible(
      child: chatId == ""
          ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(
                Colors.lightBlueAccent,
              ),
        ),
      )
          : StreamBuilder(
        stream: Firestore.instance.collection("messages")
            .document(chatId)
            .collection(chatId)
            .orderBy("timestamp", descending: true)
            .limit(20)
            .snapshots(),

        builder: (context, snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.lightBlueAccent,),
              ),
            );
          }
          else{
            listMessage = snapshot.data.documents;
            return ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemBuilder: (context, index) => createItem(index, snapshot.data.documents[index]),
              itemCount: snapshot.data.documents.length,
              reverse: true,
              controller: listScrollController,
            );
          }
        },
      ),
    );
  }

  bool isLastMsgLeft(int index){
    if((index > 0 && listMessage != null && listMessage[index - 1]["idFrom"] == id) || index == 0){
      return true;
    }
    else{
      return false;
    }
  }

  bool isLastMsgRight(int index){
    if((index > 0 && listMessage != null && listMessage[index - 1]["idFrom"] != id) || index == 0){
      return true;
    }
    else{
      return false;
    }
  }

  // function to display messages
  Widget createItem(int index, DocumentSnapshot document){

    // sender message - right side
    if(document["idFrom"] == id){
      return Row(
        children: <Widget>[
          document["type"] == 0

              // text msg
              ? Container(
                  child: Text(
                    document["content"],
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                width: 200.0,
                decoration: BoxDecoration(
                  color: Colors.lightBlueAccent,
                  borderRadius: BorderRadius.circular(8.0),
                ),
                margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
          )

              // image msg
              : document["type"] == 1
              ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            "assets/images/img_not_available.jpeg",
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FullPhoto(url: document["content"])
                      ));
                    },
                  ),
            margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
          )

              // sticker .gif image
          :Container(
            child: Image.asset(
              "assets/stickers/${document['content']}.gif",
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
          ),
        ],
        mainAxisAlignment: MainAxisAlignment.end,
      );
    }

    // receiver messages - left side
    else{
      return Container(
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                isLastMsgLeft(index)
                    ? Material(
                  // display receiver profile image
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                      ),
                      width: 35.0,
                      height: 35.0,
                      padding: EdgeInsets.all(10.0),
                    ),
                    imageUrl: receiverAvatar,
                    width: 35.0,
                    height: 35.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(
                    Radius.circular(18.0),
                ),
                clipBehavior: Clip.hardEdge,
                )
                    : Container(
                  width: 35.0,
                ),

                // display messages
                document["type"] == 0

                // text msg
                    ? Container(
                  child: Text(
                    document["content"],
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  padding: EdgeInsets.fromLTRB(15.0, 10.0, 15.0, 10.0),
                  width: 200.0,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )

                // image msg
                    : document["type"] == 1
                    ? Container(
                  child: FlatButton(
                    child: Material(
                      child: CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.lightBlueAccent),
                          ),
                          width: 200.0,
                          height: 200.0,
                          padding: EdgeInsets.all(70.0),
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          ),
                        ),
                        errorWidget: (context, url, error) => Material(
                          child: Image.asset(
                            "assets/images/img_not_available.jpeg",
                            width: 200.0,
                            height: 200.0,
                            fit: BoxFit.cover,
                          ),
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                          clipBehavior: Clip.hardEdge,
                        ),
                        imageUrl: document["content"],
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                      clipBehavior: Clip.hardEdge,
                    ),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => FullPhoto(url: document["content"])
                      ));
                    },
                  ),
                  margin: EdgeInsets.only(left: 10.0),
                )

                // sticker .gif msg
                    : Container(
                        child: Image.asset(
                          "assets/stickers/${document['content']}.gif",
                          width: 100.0,
                          height: 100.0,
                          fit: BoxFit.cover,
                        ),
                      margin: EdgeInsets.only(bottom: isLastMsgRight(index) ? 20.0 : 10.0, right: 10.0),
                      ),
                  ],
                ),

            // message timing
            isLastMsgLeft(index)
                ? Container(
              child: Text(
                DateFormat("dd MMMM, yyyy - hh:mm:aa")
                    .format(DateTime.fromMillisecondsSinceEpoch(int .parse(document["timestamp"]))),
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 12.0,
                  fontStyle: FontStyle.italic,
                ),
              ),
              margin: EdgeInsets.only(left: 50.0, top: 50.0, bottom: 5.0),
              )
                : Container()
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
            margin: EdgeInsets.only(bottom: 10.0),
      );
    }
  }

  // function to create text Field where user can write messages
  createInput(){
    return Container(
      child: Row(
        children: <Widget>[

          // pick image icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.image),
                color: Colors.white,
                onPressed: getImage,
              ),
            ),
            color: Colors.black,
          ),

          // emoji icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 1.0),
              child: IconButton(
                icon: Icon(Icons.tag_faces),
                color: Colors.white,
                onPressed: getSticker,
              ),
            ),
            color: Colors.black,
          ),

          // Text Field to send messages
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: "Write here...",
                  hintStyle: TextStyle(
                    color: Colors.grey,
                  ),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // send message icon button
          Material(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 8.0),
              child: IconButton(
                icon: Icon(Icons.send),
                color: Colors.blue,
                onPressed: () => onSendMessage(textEditingController.text, 0),
              ),
            ),
            color: Colors.black,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.5,
          ),
        ),
        color:Colors.black,
      ),
    );
  }

  void onSendMessage(String contentMsg, int type){
    // type = 0 its text msg
    // type = 1 its imageFile
    // type = 2 its sticker - emoji-gifs
    if(contentMsg != ""){
      textEditingController.clear();

      var docRef = Firestore.instance.collection("messages")
          .document(chatId)
          .collection(chatId)
          .document(DateTime.now().millisecondsSinceEpoch.toString());

      Firestore.instance.runTransaction((transaction) async{
        await transaction.set(docRef, {
          "idFrom": id,
          "idTo": receiverId,
          "timestamp": DateTime.now().millisecondsSinceEpoch.toString(),
          "content": contentMsg,
          "type": type,
        },);
      });

      listScrollController.animateTo(0.0, duration: Duration(microseconds: 300), curve: Curves.easeOut);
    }
    else{
      Fluttertoast.showToast(msg: "Empty Message cannot be send.");
    }
  }

  Future getImage() async{
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);

    if(imageFile != null){
      isLoading = true;
    }

    uploadImageFile();
  }

  Future uploadImageFile() async{
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    StorageReference storageReference = FirebaseStorage.instance.ref().child("chat Images").child(fileName);

    StorageUploadTask storageUploadTask = storageReference.putFile(imageFile);
    StorageTaskSnapshot storageTaskSnapshot = await storageUploadTask.onComplete;

    storageTaskSnapshot.ref.getDownloadURL().then((downloadUrl){
      imageUrl = downloadUrl;
      setState(() {
        isLoading = false;
        onSendMessage(imageUrl, 1);
      });
    }, onError: (errorMsg){
      setState(() {
        isLoading = false;
      });
      Fluttertoast.showToast(msg: "Error: " + errorMsg);
    });
  }
}

