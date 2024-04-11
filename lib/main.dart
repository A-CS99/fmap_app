import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:ui' as ui;


void main() {
  runApp(const MainApp());
}

class Pos {
  double x = 0;
  double y = 0;
  Pos(this.x, this.y);
}

class GeoPoint {
  double longitude = 0;
  double latitude = 0;
  GeoPoint(this.longitude, this.latitude);
}

const mapSize = (
  width: 355.0,
  height: 493.0,
);

const geoRange = (
  leftTop: (latitude: 39.948755, longitude: 116.416720),
  rightBottom: (latitude: 39.947896, longitude: 116.417750),
);

Pos geo2Pos(double longitude, double latitude) {  
  final x = (longitude - geoRange.leftTop.longitude) / (geoRange.rightBottom.longitude - geoRange.leftTop.longitude) * mapSize.width;
  final y = (geoRange.leftTop.latitude - latitude) / (geoRange.leftTop.latitude - geoRange.rightBottom.latitude) * mapSize.height;
  
  return Pos(x, y);
}

void drawLine(Canvas canvas, Paint paint, List<Pos> places) {
  final path = Path()
    ..moveTo(places[0].x, places[0].y);
  for (var i = 1; i < places.length; i++) {
    path.lineTo(places[i].x, places[i].y);
  }

  canvas.drawPath(path, paint);
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    const mapSize = (
      width: 355.0,
      height: 493.0,
    );
    
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text( 'width: ${screenSize.width}, height: ${screenSize.height}'),
        ),
        body: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: mapSize.width,
                height: mapSize.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/imgs/map.jpg'),
                    fit: BoxFit.fitWidth,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              left: 0, 
              child: CustomPaint(
                size: Size(mapSize.width, mapSize.height),
                painter: MyPainter(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MyPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final myPaint = Paint()
      ..isAntiAlias = true
      ..style = PaintingStyle.stroke
      ..strokeWidth = 10
      ..color = Colors.red;
    final testGeoPoints = [
      GeoPoint(116.416958, 39.948741),
      GeoPoint(116.417548, 39.948745),
      GeoPoint(116.417515, 39.948215),
      GeoPoint(116.417232, 39.947906),
    ];
    final testPosPoints = testGeoPoints.map((e) => geo2Pos(e.longitude, e.latitude)).toList();
    drawLine(canvas, myPaint, testPosPoints);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}