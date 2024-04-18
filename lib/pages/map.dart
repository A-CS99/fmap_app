import 'package:flutter/material.dart';
import '/const.dart';
import '/paint.dart';
import '/types.dart';

class MapPage extends StatelessWidget {
  final List<Place> places;
  final List<Point> showPoints;
  final List<GeoPoint> pathPoints;
  final NavPlaces navPlaces;
  final Function setNavPlaces;

  const MapPage(this.places, this.showPoints, this.pathPoints, this.navPlaces, this.setNavPlaces, {super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final mapWidth = screenSize.width;
    final mapHeight = screenSize.width / mapImgSize.width * mapImgSize.height;
    mapSize = (width: mapWidth, height: mapHeight);

    final dorpdownItems = places.map<DropdownMenuItem<String>>(
        (e) => DropdownMenuItem<String>(
          value: e.name, 
          child: Text(e.name)
        )
      ).toList();
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            DropdownButton(
              value: navPlaces.from.id == -1 ? '请选择导航/TSP起点' : navPlaces.from.name,
              onChanged: (String? name) {
                if (name == null || name == '请选择导航/TSP起点') {
                  setNavPlaces(Place(-1, '', GeoPoint(0, 0)), navPlaces.to);
                  return;
                }
                final Place from = places.firstWhere((e) => e.name == name);
                setNavPlaces(from, navPlaces.to);
              },
              items: [const DropdownMenuItem<String>(
                value: '请选择导航/TSP起点',
                child: Text('请选择导航/TSP起点')
              )] + dorpdownItems,
            ),
            DropdownButton(
              value: navPlaces.to.id == -1 ? '请选择导航终点' : navPlaces.to.name,
              onChanged: (String? name) {
                if (name == null || name == '请选择导航终点') {
                  setNavPlaces(navPlaces.from, Place(-1, '', GeoPoint(0, 0)));
                  return;
                }
                final Place to = places.firstWhere((e) => e.name == name);
                setNavPlaces(navPlaces.from, to);
              },
              items: [const DropdownMenuItem<String>(
                value: '请选择导航终点',
                child: Text('请选择导航终点')
              )] + dorpdownItems,
            ),
          ],
        ),
        SizedBox(
          width: mapWidth,
          height: mapHeight,
          child: Center(
            child: MapCanvas(showPoints, pathPoints),
          ),
        ),
      ],
    );
  }
}

class MapCanvas extends StatelessWidget {
  final List<Point> showPoints;
  final List<GeoPoint> pathPoints;

  const MapCanvas(this.showPoints, this.pathPoints, {super.key});

  @override
  Widget build(BuildContext context) {

    return Stack(
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
              painter: MyPainter(showPoints, pathPoints),
            ),
          ),
        ],
      );
  }
}