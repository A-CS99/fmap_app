import 'package:flutter/material.dart';
import 'funcs.dart';
import 'types.dart';


  
class MyPainter extends CustomPainter {
  final List<Point> points;
  final List<GeoPoint> pathPoints;

  MyPainter(this.points, this.pathPoints);
  @override
  void paint(Canvas canvas, Size size) {
    List<Pos> pathPosPoints = [];
    if (pathPoints.isNotEmpty) {
      pathPosPoints = pathPoints.map((e) => geo2Pos(e.longitude, e.latitude)).toList();
    }
    List<Pos> placePosPoints = [];
    if (points.isNotEmpty) {
      placePosPoints = points.map((e) => geo2Pos(e.geoPoint.longitude, e.geoPoint.latitude)).toList();
    }
    if (pathPosPoints.isNotEmpty) {
      drawLine(canvas, pathPosPoints);
    }
    if (placePosPoints.isNotEmpty) {
      drawMarkers(canvas, placePosPoints);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate != this;
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
  // 内部线
  final innerPaint = Paint()
    ..isAntiAlias = true
    ..style = PaintingStyle.stroke
    ..strokeWidth = 8
    ..color = Colors.blue[400]!
    ..strokeCap = StrokeCap.round
    ..strokeJoin = StrokeJoin.round;

  final path = Path();
  for (var i = 0; i < places.length - 1; i++) {
    path.moveTo(places[i].x, places[i].y);
    path.lineTo(places[i+1].x, places[i+1].y);
  }
  canvas.drawPath(path, outerPaint);
  canvas.drawPath(path, innerPaint);
}