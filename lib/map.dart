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
  late GoogleMapController _controller;
  bool _added = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('location').snapshots(),
        builder: (ctx, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (_added) {
            mymap(snapshot);
          }

          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          return GoogleMap(
            mapType: MapType.normal,
            markers: {
              Marker(
                markerId: MarkerId('id'),
                position: LatLng(
                  snapshot.data!.docs
                      .singleWhere((it) => it.id == widget.user_id)['latitude'],
                  snapshot.data!.docs.singleWhere(
                      (it) => it.id == widget.user_id)['longitude'],
                ),
                icon: BitmapDescriptor.defaultMarkerWithHue(
                  BitmapDescriptor.hueMagenta,
                ),
              )
            },
            initialCameraPosition: CameraPosition(
              target: LatLng(
                snapshot.data!.docs
                    .singleWhere((it) => it.id == widget.user_id)['latitude'],
                snapshot.data!.docs
                    .singleWhere((it) => it.id == widget.user_id)['longitude'],
              ),
              zoom: 14.47,
            ),
            onMapCreated: (GoogleMapController controller) async {
              setState(() {
                _controller = controller;
                _added = true;
              });
            },
          );
        },
      ),
    );
  }

  Future<void> mymap(AsyncSnapshot<QuerySnapshot> snapshot) async {
    await _controller.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(
            snapshot.data!.docs
                .singleWhere((it) => it.id == widget.user_id)['latitude'],
            snapshot.data!.docs
                .singleWhere((it) => it.id == widget.user_id)['longitude'],
          ),
          zoom: 14.47,
        ),
      ),
    );
  }
}
