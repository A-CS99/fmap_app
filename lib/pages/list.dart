import 'package:flutter/material.dart';

import '/types.dart';

class ListPage extends StatelessWidget {
  final List<Place> places;
  const ListPage(this.places, {super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        Expanded(
          child: ListView.builder(
            itemCount: places.length,
            itemBuilder: (context, index) {
              return ListCard(places[index]);
            },
          ),
        ),
      ],
    );
  }
}

class ListCard extends StatelessWidget {
  final Place place;

  const ListCard(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(place.name),
        subtitle: Text('(${place.geoPoint.longitude}, ${place.geoPoint.latitude})'),
      ),
    );
  }
}