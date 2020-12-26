import 'package:flutter/material.dart';
import 'package:social_network_app/widgets/header_widget.dart';

class ChatSearchScreen extends StatefulWidget {
  @override
  _ChatSearchScreenState createState() => _ChatSearchScreenState();
}

class _ChatSearchScreenState extends State<ChatSearchScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: header(context, strTitle: "ChatSearch",),
    );
  }
}
