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
        fontFamily: isAppTitle ? "Signatra" : "",
        fontSize: isAppTitle ? 45.0 : 22.0,
      ),
      overflow: TextOverflow.ellipsis,
    ),
    centerTitle: true,
    backgroundColor: Theme.of(context).accentColor,
  );
}