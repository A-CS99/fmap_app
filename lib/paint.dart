import 'package:flutter/material.dart';
import 'const.dart';
import 'funcs.dart';
import 'types.dart';


  
class MyPainter extends CustomPainter {
  final List<Point> points;

  MyPainter(this.points);
  @override
  void paint(Canvas canvas, Size size) {
    final testPosPoints = testGeoPoints.map((e) => geo2Pos(e.longitude, e.latitude)).toList();
    final placePosPoints = points.map((e) => geo2Pos(e.geoPoint.longitude, e.geoPoint.latitude)).toList();
    if (testPosPoints.isNotEmpty) {
      drawLine(canvas, testPosPoints);
    }
    if (placePosPoints.isNotEmpty) {
      drawMarkers(canvas, placePosPoints);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

void drawMarkers(Canvas canvas, List<Pos> places) {
  final markerPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.fill
    ..color = Colors.red;
  for (var i = 0; i < places.length; i++) {
    final pos = places[i];
    canvas.drawCircle(Offset(pos.x, pos.y), 12, markerPaint);
    canvas.drawCircle(Offset(pos.x, pos.y), 6, Paint()..color = Colors.white);
  }
}

void drawLine(Canvas canvas, List<Pos> places) {
  // 外部线
  final outerPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 12
    ..color = Colors.blue[800]!
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final outerPath = Path()
    ..moveTo(places[0].x, places[0].y);
  for (var i = 1; i < places.length; i++) {
    outerPath.lineTo(places[i].x, places[i].y);
  }
  canvas.drawPath(outerPath, outerPaint);

  // 内部线
  final linePaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..color = Colors.blue[400]!
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;
  final path = Path()
    ..moveTo(places[0].x, places[0].y);
  for (var i = 1; i < places.length; i++) {
    path.lineTo(places[i].x, places[i].y);
  }
  canvas.drawPath(path, linePaint);
}