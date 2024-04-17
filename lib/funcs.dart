import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'const.dart';
import 'types.dart';


Pos geo2Pos(double longitude, double latitude) {
  final x = (longitude - geoRange.leftTop.longitude) / (geoRange.rightBottom.longitude - geoRange.leftTop.longitude) * mapSize.width;
  final y = (geoRange.leftTop.latitude - latitude) / (geoRange.leftTop.latitude - geoRange.rightBottom.latitude) * mapSize.height;
  
  return Pos(x, y);
}

void consoleLog(String msg) {
  if (kDebugMode) {
    print(msg);
  }
}


const toastConfig = (
  toastLength: Toast.LENGTH_SHORT, 
  gravity: ToastGravity.CENTER, 
  timeInSecForIosWeb: 1, 
  backgroundColor: Colors.blue, 
  textColor: Colors.white, 
  fontSize: 16.0,
);

void showToast(String toastMsg) {
  Fluttertoast.showToast(
    msg: toastMsg, 
    toastLength: toastConfig.toastLength,
    gravity: toastConfig.gravity,
    timeInSecForIosWeb: toastConfig.timeInSecForIosWeb,
    backgroundColor: toastConfig.backgroundColor,
    textColor: toastConfig.textColor,
    fontSize: toastConfig.fontSize
  );
}