

import 'dart:async';
import 'dart:convert';
import 'dart:html';
import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/Model/RoomInfo.dart';
import 'package:kryfto/game_page.dart';
import 'package:location/location.dart';
import 'Model/User.dart';
import 'countdown.dart';
import 'map_page.dart';
import 'theme.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:socket_io_client/socket_io_client.dart' as IO;


class MapPage extends StatefulWidget {
  final List<LatLng> points;
  final IO.Socket socket;
  final User user;
  final RoomInfo roomInfo;
  const MapPage({super.key, required this.points, required this.socket, required this.user, required this.roomInfo});

  @override
  State<MapPage> createState() => _MapPageState(points);
}

class _MapPageState extends State<MapPage> {

  List<LatLng> points;
  _MapPageState(this.points);
  static const initCameraPosition = CameraPosition(
    target: LatLng(-36.853940, 174.764620),
    zoom:16);
    bool isMapCreated = false; 
   late GoogleMapController _mapController;
    int _polygonIdCounter =1;
    int _markerCounter =1;
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

 LocationData? currentLocation;
  


Duration time = Duration(minutes: 30);
late Timer timer;
Duration? current;


  void startTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (_) => countDown());
    Timer check = new Timer.periodic(Duration(seconds:10), (_) => inBounds());
    current = time;
  }
  void countDown(){
    final second = 1;
    setState(() {

      final seconds = time.inSeconds - second;
      time = Duration(seconds: seconds);
    });
  }


 
void getLocation(){
Location location = Location();

location.getLocation().then((location) {
  currentLocation = location;

  widget.socket.emit("player location",jsonEncode({
    'Username:': widget.user.username,
    'Code': widget.user.roomcode,
    'Location': currentLocation,
  }));

  print(currentLocation);
},
);
location.onLocationChanged.listen(
  (newLoc) { 
    currentLocation= newLoc;
    widget.socket.emit("player location",jsonEncode({
    'Username:': widget.user.username,
    'Code': widget.user.roomcode,
    'Location': newLoc,
  }));
    setState(() {
      
    });
  });
  

}
@override
void initState(){
  
  
  getLocation();


  super.initState();
}





void _drawPolygon(){
  
  
   final String polygonIdVal = 'polygon_$_polygonIdCounter';
   _polygonIdCounter++;
  polygons.add(Polygon(
  polygonId: PolygonId(polygonIdVal),
  points: points,
  strokeWidth: 2,
  consumeTapEvents: true,
  strokeColor: Theme.of(context).primaryColorDark,
  fillColor: Theme.of(context).primaryColorLight.withAlpha(50)));
  
 }


 void _setMarker(LatLng point){
   final String markerIdVal = "Player $_markerCounter";
_markerCounter++;

   setState(() {
     markers.add(
       Marker(markerId: MarkerId(markerIdVal), 
       position: point,
       infoWindow: InfoWindow(title:markerIdVal),
      draggable: false,
   
      )
      
     );
     
   });
      
 }
showOverlay(BuildContext context) async {
  OverlayState? overlayState =Overlay.of(context);
OverlayEntry overlayEntry = OverlayEntry(builder: (context){
 return CupertinoAlertDialog(
    title: Text("Boundary Breached"),
  content: Text("Please return the boundary or you will be Eliminated."),
  );
});
  overlayState?.insert(overlayEntry);


await Future.delayed(Duration(seconds:5));

overlayEntry.remove();
}
void inBounds(){
   List<mp.LatLng> mpPoints = <mp.LatLng>[];
   bool inside = true;
  for(int i =0; i < points.length;i++){
   
    mpPoints.add(mp.LatLng(points[i].latitude,points[i].longitude));
  }

    inside = mp.PolygonUtil.containsLocation(mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!), mpPoints, true);
if(!inside){
  setState(() {
    showOverlay(context);
  });
}

  
}




  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }


changeMapMode(){
     getJsonFile("assets/map.json").then(setMapStyle);
  }

 Future<String> getJsonFile(String path) async{
  return await  rootBundle.loadString(path);
}

void setMapStyle(String mapStyle){
  _mapController.setMapStyle(mapStyle);
}


  @override
  Widget build(BuildContext context) {

if(isMapCreated){
  changeMapMode();
 
  
}




    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(centerTitle: true,
      title: Text(time.toString().substring(0,time.toString().length-7),
      style: GoogleFonts.righteous(textStyle:TextStyle(color: Theme.of(context).backgroundColor,
      fontSize: 35,
      ))),
      backgroundColor: ui.Color.fromARGB(199, 234, 42, 61),
      elevation: 0,),

      body: currentLocation ==null ? 
      Center(child: Text("Loading...",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor) )))
      :GoogleMap(
        markers: markers,
        polygons: polygons,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        
initialCameraPosition: initCameraPosition,

onMapCreated:(GoogleMapController controller){
  startTimer();
  
  _mapController = controller;
  isMapCreated = true;
  changeMapMode();
  _mapController.animateCamera(CameraUpdate.newCameraPosition(
                      CameraPosition(
                          target: LatLng(currentLocation!.latitude!,
                              currentLocation!.longitude!),
                          zoom: 16)));
  markers.add(Marker(markerId:const MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
infoWindow: InfoWindow(title: 'Current Location'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) ));
  
  setState(() {
    widget.roomInfo.playerLocations.forEach(((element) => _setMarker(LatLng(element!.latitude!,element!.longitude!))));

     _drawPolygon();
     
  });
 
  
    
 
  
}


      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Padding(
  padding: const EdgeInsets.all(20.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
      Container(height: 100, width:100
      ,child: FittedBox(
        child:FloatingActionButton(
      
        onPressed: () {
        
setState(() {
  
});
},
        child: const Icon(Icons.flag_circle),
         shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        backgroundColor: ui.Color.fromARGB(199, 234, 42, 61),
        elevation: 0,
       ),
      ),
      ),
      Container(height: 100, width:100


      ,child: FittedBox(

        child:FloatingActionButton(
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
      
setState(() {
  
});
},
        child: const Icon(Icons.chat_bubble),
        
        backgroundColor: ui.Color.fromARGB(199, 234, 42, 61),
        elevation: 0,
       ),
      ),
      ),
    ],
  ),
)
        
      
    );
  }

}