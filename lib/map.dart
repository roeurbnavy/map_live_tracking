// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class MyMap extends StatefulWidget {
  final String user_id;

  const MyMap(
    this.user_id,
  );

  @override
  State<MyMap> createState() => _MyMapState();
}

class _MyMapState extends State<MyMap> {
  final Location location = Location();
  // late GoogleMapController _controller;
  // bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          // if (_added) {
          //   mymap(snapshot);
          // }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          LatLng position = LatLng(
            snapshot.data!.docs
                .singleWhere((it) => it.id == widget.user_id)['latitude'],
            snapshot.data!.docs
                .singleWhere((it) => it.id == widget.user_id)['longitude'],
          );

          LatLng setPositions() {
            return LatLng(position.latitude, position.longitude);
          }

          return GoogleMap(
            mapType: MapType.hybrid,
            onLongPress: (LatLng value) async {
              await FirebaseFirestore.instance
                  .collection('location')
                  .doc('user1')
                  .set({
                'latitude': value.latitude,
                'longitude': value.longitude,
                'name': 'Navy'
              }, SetOptions(merge: true));
            },
            markers: {
              Marker(
                markerId: MarkerId(widget.user_id),
                position: setPositions(),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta,
                ),
              )
            },
            initialCameraPosition: CameraPosition(
              target: setPositions(),
              // tilt: 59.440717697143555,
              zoom: 16.47,
            ),
            onMapCreated: (GoogleMapController controller) async {
              // setState(() {
              //   _controller = controller;
              //   _added = true;
              // });
            },
          );
        },
      ),
    );
  }

  // // Auto update camera position when other device change position
  // Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
  //   await _controller.animateCamera(
  //     CameraUpdate.newCameraPosition(
  //       CameraPosition(
  //         target: LatLng(
  //           snapshot.data!.docs
  //               .singleWhere((it) => it.id == widget.user_id)['latitude'],
  //           snapshot.data!.docs
  //               .singleWhere((it) => it.id == widget.user_id)['longitude'],
  //         ),
  //         // zoom: 14.47,
  //         // tilt: 59.440717697143555,
  //         zoom: 19.151926040649414,
  //       ),
  //     ),
  //   );
  // }
}
