

import 'dart:ui' as ui;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/game_page.dart';
import 'package:location/location.dart';
import 'map_page.dart';
import 'theme.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;


class MapPage extends StatefulWidget {
  final List<LatLng> points;
  const MapPage({super.key, required this.points});

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

  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

 LocationData? currentLocation;


void getLocation(){
Location location = Location();

location.getLocation().then((location) {
currentLocation = location;
print(currentLocation);
},
);
location.onLocationChanged.listen(
  (newLoc) { 
    currentLocation= newLoc;
    setState(() {
      
    });
  });
  

}
@override
void initState(){
  
  getLocation();
 
  super.initState();
}
// LatLng passLocation(){
//   LatLng pin = LatLng(0,0);
//   Location location = Location();
//   location.getLocation().then((location){
// pin = LatLng(currentLocation!.latitude!,currentLocation!.longitude!);
// return pin;

//   });
//   return pin;
// }
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
   final String markerIdVal = 'Current lcoation';


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

bool inBounds(){
   List<mp.LatLng> mpPoints = <mp.LatLng>[];
  for(int i =0; i < points.length;i++){
   
    mpPoints.add(mp.LatLng(points[i].latitude,points[i].longitude));
  }
  return mp.PolygonUtil.containsLocation(mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!), mpPoints, true);
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
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
        },
        icon: const Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text("59:34:19",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 45, color: Theme.of(context).backgroundColor) )),
        backgroundColor: Color(0xaaea2a3d),
        elevation: 0,
        ),

      body:  currentLocation ==null ?
       Center(child: Text("Loading..."))
      : GoogleMap(
        markers: markers,
        polygons: polygons,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        
initialCameraPosition: initCameraPosition,
onMapCreated:(GoogleMapController controller){
  _mapController = controller;
  isMapCreated = true;
  changeMapMode();
  markers.add(Marker(markerId:const MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
infoWindow: InfoWindow(title: 'Current Location'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) ));
  setState(() {
    
     _drawPolygon();
     if(!inBounds()){
       showDialog(context: context, builder: (context) => CupertinoAlertDialog(
    title: Text("Boundary Breached"),
  content: Text("Please return the boundary or you will be Eliminated."),
  actions:[
    CupertinoDialogAction(child:Text("OK"),isDestructiveAction: true,),
    

     
  ]));
  }
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