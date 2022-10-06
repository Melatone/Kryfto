import 'dart:async';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'package:location/location.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;




class Rose extends StatefulWidget {
 
  const Rose({Key? key, required this.points}) : super(key: key);
   final List<LatLng> points;
  @override
  State<Rose> createState() => _RoseState(points);
}

class _RoseState extends State<Rose> {
  
 List<LatLng> points;
  _RoseState(this.points);
  double? heading;

  
  
static const initCameraPosition = CameraPosition(
    target: LatLng(-36.853940, 174.764620),
    zoom:16);
    bool isMapCreated = false; 
   late GoogleMapController _mapController;
    int _polygonIdCounter =1;

  Set<Marker> markers = {};
  Set<Polygon> polygons = {};

 LocationData? currentLocation;
  

@override
void initState(){
  getLocation();
  FlutterCompass.events!.listen((event) {
    setState(() {
      heading = event.heading;
    });
    
  });
  
  super.initState();
}
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
  Widget build(BuildContext context) {

    return Scaffold(
     extendBodyBehindAppBar: true,
      appBar: AppBar(
      
    
      centerTitle: true,
      backgroundColor: Color(0xbbf2f2f2),
      title: Text(time.toString().substring(0,time.toString().length-7),
      style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 35, 
    color: Theme.of(context).primaryColorLight)))),
      backgroundColor: Theme.of(context).primaryColor,
      body: Center(child: Column(children: <Widget> [
       
       Container(
        
         width: 390,
         height: 420,
         decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
         child: 
         currentLocation ==null ? 
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
    
     _drawPolygon();
     
  });
  
}
      ),),

        Spacer(flex: 1),
        Text("Nearest Player: ",
      style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 25, 
    color: Theme.of(context).backgroundColor))),
        Stack(
          alignment: Alignment.center,
          children:<Widget>[ Image.asset("images/Cross.png", width: 300,height: 300),
       
        Transform.rotate(angle: ((heading ?? 0) * (pi / 180) * -1),
        child:  Image.asset("images/Arrow.png", width: 85,height: 85)),
        ]
                
        ),
        Spacer(flex: 3),
      
       
      ],))
      ,
       
    );
  }
}

