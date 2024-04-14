import 'package:flutter/foundation.dart';
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