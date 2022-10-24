

import 'dart:async';
import 'dart:convert';

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
import 'package:kryfto/elimination.dart';
import 'package:kryfto/end_screen.dart';
import 'package:kryfto/game_page.dart';
import 'package:location/location.dart';
import 'Model/User.dart';
import 'Model/player.dart';
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
  List<PlayerModel> playersItems; 
  final int timeLimit;
  MapPage({super.key, required this.points, required this.socket, required this.user, required this.roomInfo, required this.playersItems, required this.timeLimit});
 
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
  int playerCount =0;
 LocationData? currentLocation;
  



late Timer timer;
Duration current = Duration(minutes: 30);

  void startTimer(){
    timer = new Timer.periodic(Duration(seconds: 1), (_) => countDown());
    Timer check = new Timer.periodic(Duration(seconds:10), (_) => inBounds());
    Timer loc = new Timer.periodic(Duration(seconds:5), (_) => drawPoints());
    current = Duration(minutes:widget.timeLimit);
  }
  void countDown(){
    final second = 1;
    setState(() {

      final seconds = current!.inSeconds - second;
      current = Duration(seconds: seconds);
    });
  }


 
void getLocation(){
Location location = Location();



location.onLocationChanged.listen(
  (newLoc) { 
    currentLocation= newLoc;
    
    setState(() {
      markers.remove("Current Location");
         markers.add(Marker(markerId:MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
infoWindow: InfoWindow(title: 'Current Location'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) ));


    });
  });
  

}
@override
void initState(){
  
  
  getLocation();
initCounter();

if(playerCount==0){
Navigator.pop(context);
Navigator.of(context).push(MaterialPageRoute(builder :(context)=> End(
                    socket: widget.socket,
                    user: widget.user,
                    playersItems: widget.playersItems,
                       operator: 1, timeLeft: current
                  )));
}
else if(current.inSeconds<1){
  Navigator.pop(context);
  Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  End(
                    socket: widget.socket,
                    user: widget.user,
                    playersItems: widget.playersItems,
                       operator: 0, timeLeft: current
                  )));
}
 widget.socket.on("eliminate", (msg) {
      final result = json.decode(msg);
      this.setState(() {
        widget.playersItems.forEach(
          (element) {
            if (widget.user.username == result['Username']) {
              print(element.Username);
              print(result['Username']);
             
              Navigator.pop(context);
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>  Elimination(points: widget.points,
                    socket: widget.socket,
                    user: widget.user,
                    roomInfo: RoomInfo(widget.points, widget.roomcode,
                        widget.hideLimit, widget.timeLimit,
                        ),playersItems: widget.playersItems,
                        timeLimit: widget.timeLimit,
                  )));
              }
             
            }
          
        );
      });
    });

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
 String markerIdVal = "Player ";

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

 void initCounter(){
   playerCount=0;
   widget.playersItems.forEach((element) { 
     if(!element.Seeker){
     playerCount++;
     }
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

void drawPoints(){
  initCounter();
  widget.socket.emit("player location",jsonEncode({
    'Username:': widget.user.username,
    'Code': widget.roomCode,
    'Location': LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
  }));
  
  setState(() {
    widget.socket.on("player location", (msg){
      msg= jsonDecode(msg);
    
 
  
    if(LatLng(msg['Location'][0],msg['Location'][1])!= LatLng(currentLocation!.latitude!, currentLocation!.longitude!)){
    _setMarker(LatLng(msg['Location'][0],msg['Location'][1]));
    }

   
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


  @override
  Widget build(BuildContext context) {

if(isMapCreated){
  changeMapMode();
 
  
}




    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(centerTitle: true,
      title: Text(current.toString().substring(0,current.toString().length-7),
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
        zoomControlsEnabled: false,
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
 
  
  setState(() {
 

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
        widget.socket.emit("player taunt",jsonEncode({
    'Username:': widget.user.username,
    'Code': widget.roomCode,
    'Location': LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
  }));
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
      Container(child:Row(children: [
      
        Text("$playerCount",
      style: GoogleFonts.righteous(textStyle:TextStyle(
      fontSize: 35,
      ))),
      const Icon(Icons.person,size :50),
      ],)),
      Container(height: 100, width:100


      ,child: FittedBox(

        child:FloatingActionButton(
      shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        onPressed: () {
      
setState(() {
   Navigator.pop(context);
Navigator.of(context).push(MaterialPageRoute(builder :(context)=> End(
                    socket: widget.socket,
                    user: widget.user,
                    playersItems: widget.playersItems,
                       operator: 1, timeLeft: current
                  )));

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