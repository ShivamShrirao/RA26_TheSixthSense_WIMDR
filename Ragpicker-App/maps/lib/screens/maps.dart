import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_database/firebase_database.dart';
import 'Marks.dart';
import 'captureImg.dart';
import 'package:maps/services/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

const double CAMERA_ZOOM = 13;
const double CAMERA_TILT = 0;
const double CAMERA_BEARING = 30;

class _MyAppState extends State<MyApp> {

  Completer<GoogleMapController> _controller = Completer();

  static const LatLng _center = const LatLng(22.5726, 88.3639);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;
  MapType _currentMapType = MapType.normal;
  Position position;
  Widget _child;
  List<Placemark> placemark;
  String _address,area,pincode;
  double _lat,_lng;
  Map<MarkerId, Marker> markers = <MarkerId, Marker> {};
  List<Marker> marksList = [];

  @override
  void initState(){
    //_child = SpinKitDualRing("Getting Location");
//    getCurrentLocation();
//    populateClients();
    super.initState();

    DatabaseReference marksRef = FirebaseDatabase.instance.reference().child("Detected");

    marksRef.once().then((DataSnapshot snap){
      var KEYS = snap.value.keys;
      var DATA = snap.value;

      marksList.clear();

      for(var individualKey in KEYS) {
        Marks marks = new Marks(
          DATA[individualKey]['latitude'],
          DATA[individualKey]['longitude'],
          DATA[individualKey]['Area'],
          DATA[individualKey]['Pincode'],
        );
        marksList.add(Marker(
          markerId: MarkerId('marker'),
          onTap: (){
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Capture(marks.latitude,marks.longitude,marks.area,marks.pincode)));
          },
          position: LatLng(marks.latitude,marks.longitude),
        ),);
      }

      setState(() {
        print('Length - $marksList.length');
      });
    });
  }

//  void getCurrentLocation() async {
//    Position res = await Geolocator().getCurrentPosition();
//    setState(() {
//      position = res;
//      _lat = position.latitude;
//      _lng = position.longitude;
//    });
//    await getAddress(_lat,_lng);
//  }
//
//  void getAddress(double latitude, double longitude) async{
//    placemark = await Geolocator().placemarkFromCoordinates(latitude, longitude);
//    _address = placemark[0].name.toString() + "," + placemark[0].locality.toString() + ", Postal code - " + placemark[0].postalCode.toString();
//    setState(() {
//      _child = mapWidget();
//    });
//  }

//  populateClients(){
//    Firestore.instance.collection('Waste details').getDocuments().then((docs){
//      if(docs.documents.isNotEmpty){
//        for(int i=0;i<docs.documents.length;++i){
//          initMarker(docs.documents[i].data,docs.documents[i].documentID);
//        }
//      }
//    });
//  }

//  void initMarker(request,requestId){
//    var markerIdVal = requestId;
//    final MarkerId markerId = MarkerId(markerIdVal);
//    final Marker marker = Marker(
//      markerId: markerId,
//      position: LatLng(request['location'].latitude,request['location'].longitude),
//      infoWindow: InfoWindow(title: "Fetched Markers",snippet: request["address"]),
//    );
//    setState(() {
//      markers[markerId] = marker;
//      print(markerId);
//    });
//  }
//
  void _onMapCreated(GoogleMapController controller){
    _controller.complete(controller);
  }
//
//  void _onMapTypeButtonPressed(){
//    setState(() {
//      _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
//    });
//  }
//
  void _onCameraMove(CameraPosition position){
    _lastMapPosition = position.target;
  }
//
//  void _onAddMarkerButtonPressed(){
//    setState(() {
//      _markers.add(Marker(
//        markerId: MarkerId(_lastMapPosition.toString()),
//        position: _lastMapPosition,
//        infoWindow: InfoWindow(
//
//        ),
//      ));
//    });
//  }

//  Widget button(Function function,IconData icon){
//    return FloatingActionButton(
//      onPressed: function,
//      materialTapTargetSize: MaterialTapTargetSize.padded,
//      backgroundColor: Colors.blue,
//      child: Icon(
//        icon,
//        size: 36.0,
//      ),
//    );
//  }

  @override
  Widget build(BuildContext context){

//    CameraPosition initialLocation = CameraPosition(
//        zoom: CAMERA_ZOOM,
//        bearing: CAMERA_BEARING,
//        tilt: CAMERA_TILT,
//        target: SOURCE_LOCATION
//    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
//        appBar: AppBar(
//          title: Text('Maps Sample App'),
//          backgroundColor: Colors.lightGreen,
//        ),
        /*onMapCreated: method that is called on map creation and takes a MapController as a parameter.
          initialCameraPosition: required parameter that sets the starting camera position. Camera position describes which part of the world you want the map to point at.
          mapController: manages camera function (position, animation, zoom). This pattern is similar to other controllers available in Flutter, for example TextEditingController.*/
        body: Stack(
        children: <Widget>[
          Container(
          child: marksList.length == 0 ? new Text('No markers found') :
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: LatLng(18.4446,73.7846),
              zoom: 12.0,
            ),
            mapType: _currentMapType,
            markers: Set.from(marksList),
            onCameraMove: _onCameraMove,
          ),
        ),
    ],
      ),
      ),
    );
  }

//  Set<Marker> _createMarker(){
//    return <Marker>[
//      Marker(
//        markerId: MarkerId("home"),
//        position: LatLng(position.latitude,position.longitude),
//        icon: BitmapDescriptor.defaultMarker,
//        infoWindow: InfoWindow(title: "home",snippet: _address),
//      ),
//    ].toSet();
//  }

//  Widget mapWidget(){
//    return Stack(
//      children: <Widget>[
//        GoogleMap(
//          onMapCreated: _onMapCreated,
//          initialCameraPosition: CameraPosition(
//            target: LatLng(position.latitude,position.longitude),
//            zoom: 12.0,
//          ),
//          mapType: _currentMapType,
//          markers: Set<Marker>.of(markers.values),
//          onCameraMove: _onCameraMove,
//        ),
//        Padding(
//          padding: EdgeInsets.all(16.0),
//          child: Align(
//            alignment: Alignment.topRight,
//            child: Column(
//              children: <Widget>[
//                button(_onMapTypeButtonPressed,Icons.map),
//                SizedBox(height: 16.0,),
//                button(_onAddMarkerButtonPressed,Icons.add_location),
//
//              ],
//            ),
//          ),
//        ),
//      ],
//    );
//  }
}