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

class Place {
  int id = 0;
  String name = '';
  GeoPoint geoPoint = GeoPoint(0, 0);

  Place(this.id, this.name, this.geoPoint);
}

class Point {
  int id = 0;
  int placeId = 0;
  GeoPoint geoPoint = GeoPoint(0, 0);

  Point(this.id, this.placeId, this.geoPoint);
}