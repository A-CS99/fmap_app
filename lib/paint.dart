import 'package:flutter/material.dart';
import 'const.dart';
import 'funcs.dart';
import 'types.dart';


  
class MyPainter extends CustomPainter {
  final List<Place> places;

  MyPainter(this.places);
  @override
  void paint(Canvas canvas, Size size) {
    final testPosPoints = testGeoPoints.map((e) => geo2Pos(e.longitude, e.latitude)).toList();
    final placePosPoints = places.map((e) => geo2Pos(e.geoPoint.longitude, e.geoPoint.latitude)).toList();
    if (testPosPoints.isNotEmpty) {
      drawLine(canvas, testPosPoints);
    }
    if (placePosPoints.isNotEmpty) {
      drawMarkers(canvas, placePosPoints);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

void drawMarkers(Canvas canvas, List<Pos> places) {
  final markerPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.red;
  for (var i = 0; i < places.length; i++) {
    final pos = places[i];
    canvas.drawCircle(Offset(pos.x, pos.y), 10, markerPaint);
  }
}

void drawLine(Canvas canvas, List<Pos> places) {
  final linePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 10
    ..color = Colors.blue;

  final path = Path()
    ..moveTo(places[0].x, places[0].y);
  for (var i = 1; i < places.length; i++) {
    path.lineTo(places[i].x, places[i].y);
  }

  canvas.drawPath(path, linePaint);
}