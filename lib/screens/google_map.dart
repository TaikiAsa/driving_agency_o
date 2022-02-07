import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:treiber_for_agent/providers/agent.dart';
import 'package:treiber_for_agent/providers/style.dart';

// ignore: must_be_immutable
class GoogleMapScreen extends StatefulWidget {
  @override
  State<GoogleMapScreen> createState() => _GoogleMapScreenState();
}

class _GoogleMapScreenState extends State<GoogleMapScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  final Set<Marker> _markers = {};

  @override
  Widget build(BuildContext context) {
    final styleProvider = Provider.of<StyleProvider>(context);
    final agentProvider = Provider.of<AgentProvider>(context);

    GeoPoint geo = agentProvider.agent.location['geopoint'];

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: styleProvider.BW,
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: styleProvider.WB,
        title: Text(
          '登録箇所確認',
          style: TextStyle(color: styleProvider.BW),
        ),
        elevation: 0,
      ),
      body: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: CameraPosition(
            target: LatLng(geo.latitude, geo.longitude), zoom: 15.5),
        markers: _markers,
        onMapCreated: (GoogleMapController controller) {
          _controller.complete(controller);
          setState(() {
            _markers.add(Marker(
              markerId: const MarkerId('marker_1'),
              position: LatLng(geo.latitude, geo.longitude),
            ));
          });
        },
        minMaxZoomPreference: const MinMaxZoomPreference(15, 25),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
      ),
    );
  }
}
