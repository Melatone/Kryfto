import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/login_page.dart';
import 'package:kryfto/map_page.dart';
import 'package:location/location.dart';
import 'Model/RoomInfo.dart';
import 'Model/User.dart';
import 'Model/player.dart';
import 'game_page.dart';
import 'map_select_page.dart';
import 'home_page.dart';
import 'theme.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:maps_toolkit/maps_toolkit.dart' as mp;
import 'package:socket_io_client/socket_io_client.dart' as IO;



class Rose extends StatefulWidget {
 
  
  final List<LatLng> points;
  final IO.Socket socket;
  final User user;
  final RoomInfo roomInfo;
  List<PlayerModel> playersItems;
  final int timeLimit;
   Rose({Key? key, required this.points, required this.socket, required this.user, required this.roomInfo, required this.playersItems, required this.timeLimit}) : super(key: key);
  @override
  State<Rose> createState() => _RoseState(points);
}

class _RoseState extends State<Rose> {
  
 List<LatLng> points;
  _RoseState(this.points);
  double? heading;
static const initCameraPosition = CameraPosition(
    target: LatLng(-36.853940, 174.764620),
    zoom:16, );
    bool isMapCreated = false; 
   late GoogleMapController _mapController;
    int _polygonIdCounter =1;
    int _markerCounter =1;
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  double angle =0;
 LocationData? currentLocation;
 int playerCount =0;
 List<LatLng> hiders = <LatLng>[];

 late mp.LatLng closest ; 
 late LatLng nearest ;
 int distance = 0 ;



@override
void initState(){
  Location location = Location();

    location.getLocation().then(
      (location) {
        currentLocation = location;
        initCompass();
      },
    );
  
  getLocation();
initCounter();
 
  super.initState();
}

 void initCounter(){
   playerCount=0;
   widget.playersItems.forEach((element) { 
     if(!element.Seeker){
     playerCount++;
     }
   });
 }
late Timer timer;
Duration? current = Duration(minutes:30);

  void startTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (_) => countDown());
    Timer check = new Timer.periodic(Duration(seconds:10), (_) => inBounds());


     
      
    
    current = Duration(minutes:widget.timeLimit);
  }
  void countDown(){ 
    final second = 1;
    setState(() {

      final seconds = current!.inSeconds - second;
      current = Duration(seconds: seconds);
    });
  }

  
 void _setMarker(LatLng point){
   final String markerIdVal = "Player $_markerCounter";
_markerCounter++;

   setState(() {
     markers.remove(markers.last);
     markers.add(
       Marker(markerId: MarkerId(markerIdVal), 
       position: point,
       infoWindow: InfoWindow(title:markerIdVal),
      draggable: false,
   
      )
      
     );
     
   });
      
 }
void calcCompass(){
 
List<mp.LatLng> hidden = <mp.LatLng>[];
for(int i=0; i < hiders.length; i++){
  hidden.add(mp.LatLng(hiders[i].latitude, hiders[i].longitude));
print(hidden);
}


for(int i =1; i < hiders.length; i ++){
if(mp.SphericalUtil.computeDistanceBetween(hidden[i],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!)) < 
mp.SphericalUtil.computeDistanceBetween(hidden[0],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!))){
  closest = hidden[i];
  print(closest);
    nearest = LatLng(hidden[i].latitude,hidden[i].longitude);
    setState(() {
       markers.remove(markers.last);
  distance = mp.SphericalUtil.computeDistanceBetween(hidden[0],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!)).toInt();
      angle = mp.SphericalUtil.computeHeading(mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!),closest).toDouble();  
  _setMarker(nearest);
  
});
}
else if(mp.SphericalUtil.computeDistanceBetween(hidden[i],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!)) > 
mp.SphericalUtil.computeDistanceBetween(hidden[0],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!))) {
  closest = hidden[0];
  print(closest);
  nearest = LatLng(hidden[0].latitude,hidden[0].longitude);
  setState(() {
 markers.remove(markers.last);
    distance = mp.SphericalUtil.computeDistanceBetween(hidden[i],mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!)).toInt();
    angle = mp.SphericalUtil.computeHeading(mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!),closest).toDouble();
      
  _setMarker(nearest);
});
}
else{
  closest = closest;
  nearest = nearest;
}
}
  print(angle);
 FlutterCompass.events!.listen((event) {
    setState(() {
      heading = event.heading! - angle;
    });
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
 void initCompass(){
   mp.LatLng closest = mp.SphericalUtil.computeOffset(mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!), 5.5, 0); 
   nearest = LatLng(closest.latitude,closest.longitude);
  distance = mp.SphericalUtil.computeDistanceBetween(closest,mp.LatLng(currentLocation!.latitude!,currentLocation!.longitude!)).toInt();

 }

void initPlayer(){
  widget.socket.on("player location", (msg){
      msg= jsonDecode(msg);
    
    print(msg['Location'][0]);
    print(msg['Location'][1]);
    
    hiders.add(LatLng(msg['Location'][0],msg['Location'][1]));
    _setMarker(LatLng(msg['Location'][0],msg['Location'][1]));
});
}

void getLocation(){
Location location = Location();

location.onLocationChanged.listen(
  (newLoc) { 
    currentLocation= newLoc;
    calcCompass();
    setState(() {
    markers.remove("Current Location");
         markers.add(Marker(markerId:MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
infoWindow: InfoWindow(title: 'Current Location'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) ));

initCounter();
initPlayer();
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
      title: Text(current.toString().substring(0,current.toString().length-7),
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
         currentLocation == null ? 
      Center(child: Text("Loading...",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor) )))
      :Stack(children: [
      GoogleMap(
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
                          zoom: 15)));
  

markers.add(Marker(markerId:const MarkerId("Compass"),
position: LatLng(nearest!.latitude!,nearest!.longitude!),
infoWindow: InfoWindow(title: 'Compass Init'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueAzure) ));
  setState(() {
    
     _drawPolygon();
     
  });
  
  
}
      ),
      
      Container(alignment: Alignment.bottomCenter,child: distance! >5 ? Row(children: [
      Spacer(),
        Text("$playerCount",
      style: GoogleFonts.righteous(textStyle:TextStyle(
      fontSize: 35,
      ))),
      const Icon(Icons.person,size :50),
      Spacer(),
      ],
      ):
      ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            minimumSize: const Size(200, 60),
            maximumSize: const Size(280, 60),
            primary: Theme.of(context).primaryColorDark,
          ),
          child: Text(
            "Eliminate",
            style: GoogleFonts.righteous(
                textStyle:
                    TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          ),
          onPressed: () {
            
                   
          },
        )
      ),
    ],
    ),
    ),

        Spacer(flex: 1),
        Text("Nearest Player: $distance m",
      style:
     GoogleFonts.righteous(
    textStyle: TextStyle(
    fontSize: 25, 
    color: Theme.of(context).backgroundColor))),
        Stack(
          alignment: Alignment.center,
          children:<Widget>[ Image.asset("images/Cross.png", width: 300,height: 300),
       
        Transform.rotate(angle: ((heading ?? 0 ) * (pi / 180) * -1),
        child:  Image.asset("images/Arrow.png", width: 85,height: 85)),
        ]
                
        ),
        Spacer(flex: 3),
      
       
      ],)
      ),
    );
  }
}
  
