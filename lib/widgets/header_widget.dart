import 'package:flutter/material.dart';

AppBar header(context, {bool isAppTitle=false, String strTitle, disappearBackButton=false}){
  return AppBar(
    iconTheme: IconThemeData(
      color: Colors.white,
    ),
    automaticallyImplyLeading: disappearBackButton ? false : true,
    title: Text(
      isAppTitle ? "SocioApp" : strTitle,
      style: TextStyle(
        color: Colors.white,
        fontFamily: "Signatra",
        fontSize: isAppTitle ? 45.0 : 38.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}