


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
import 'countdown.dart';
import 'map_page.dart';
import 'theme.dart';

class MapSelectScreen extends StatelessWidget {
  const MapSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      
      home: MapSelectPage(),
    );
  }
}

class MapSelectPage extends StatefulWidget {
  const MapSelectPage({super.key});

  @override
  State<MapSelectPage> createState() => _MapPageSelectState();
}

class _MapPageSelectState extends State<MapSelectPage> {
  static const initCameraPosition = CameraPosition(
    target: LatLng(-36.853940, 174.764620),
    zoom:16);
    bool isMapCreated = false; 
   late GoogleMapController _mapController;
 
     BitmapDescriptor? markerbitmap;
 

    
  Set<Marker> markers = {};
  Set<Polygon> polygons = {};
  List<LatLng> lat_lng = <LatLng>[];

  int _polygonIdCounter =1 ;
  int _markerIdCounter =1;
  int _boundaryIDCounter =1; 

LocationData? currentLocation;
void getLocation(){
Location location = Location();

location.getLocation().then((location) {
currentLocation = location;
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
  addMarkers();
  super.initState();
}

  
  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }


void changeMapMode(){
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
 return Center(child:Count(start:10));
});
  overlayState?.insert(overlayEntry);


await Future.delayed(Duration(seconds:Count(start:10).start));

overlayEntry.remove();
}


 void _setMarker(LatLng point){
   final String markerIdVal = 'marker_$_markerIdCounter';
   final String markerTitleVal = 'Corner $_markerIdCounter';
   _markerIdCounter++;

   setState(() {
     markers.add(
       Marker(markerId: MarkerId(markerIdVal), 
       position: point,
       infoWindow: InfoWindow(title:markerTitleVal),
      draggable: true,
      )
      
     );
     
   });
 }
 
 void _setPolygon(){
   final String polygonIdVal = 'polygon_$_polygonIdCounter';
   _polygonIdCounter++;
polygons.add(Polygon(
  polygonId: PolygonId(polygonIdVal),
  points: lat_lng,
  strokeWidth: 2,
  consumeTapEvents: true,
  strokeColor: Theme.of(context).primaryColorDark,
  fillColor: Theme.of(context).primaryColorLight.withAlpha(50)));

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
        title: Text("Kryfto",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 40, color: Theme.of(context).backgroundColor) ),),
        backgroundColor: Color(0xaaea2a3d),
        elevation: 1,
        ),

      body: currentLocation ==null ? 
      Center(child: Text("Loading...",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 25, color: Theme.of(context).primaryColor) )))
      : GoogleMap(
        markers: markers,
        polygons: polygons,
        zoomControlsEnabled: false,
        myLocationButtonEnabled: false,
      
initialCameraPosition: initCameraPosition,
onMapCreated:(GoogleMapController controller) {
 
  _mapController = controller;
  isMapCreated = true;
  changeMapMode();
_mapController.animateCamera(
CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(currentLocation!.latitude!,currentLocation!.longitude!),zoom: 16)));
       

markers.add(Marker(markerId:const MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
infoWindow: InfoWindow(title: 'Current Location'),
icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueCyan) ));
  setState(() {
 
    
  });
  
},
onTap: (point) {
setState(() {
  lat_lng.add(point);
  _setPolygon();
  _setMarker(point);
});
},

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
  markers.remove(markers.last);
  polygons.remove(polygons.last);
  lat_lng.remove(lat_lng.last);
});
},
        child: const Icon(Icons.arrow_circle_left),
        backgroundColor: ui.Color.fromARGB(199, 234, 42, 61),
        elevation: 0,
       ),
      ),
      ),
      Container(height: 100, width:100
      ,child: FittedBox(
        child:FloatingActionButton(
      
        onPressed: () {
        
setState(() {
  showDialog(context: context, builder: (context) => CupertinoAlertDialog(
    title: Text("Confirm"),
  content: Text("Please confirm your Boundary Selection"),
  actions:[
  
    CupertinoDialogAction(child:Text("Cancel"),isDestructiveAction: true,onPressed:() => Navigator.pop(context)),
    CupertinoDialogAction(child:Text("Confirm"),isDefaultAction: true, onPressed:(){
      
      if(lat_lng.length>2){
       showOverlay(context); 
        Navigator.pop(context);
    Navigator.of(context).push(MaterialPageRoute(builder: (context) => MapPage(points:lat_lng))); 
   

    }
    
    else{
      Navigator.pop(context);
      showDialog(context: context, builder: (context) => CupertinoAlertDialog(
    title: Text("Invalid Boundary"),
  content: Text("Please create a boundary with at least 3 corners."),
  actions:[
    CupertinoDialogAction(child:Text("OK"),isDefaultAction: true,onPressed:() => Navigator.pop(context))
      
  ]));
    }
    }
),
  ]));
});
},
        child: const Icon(Icons.check),
        backgroundColor: ui.Color.fromARGB(198, 58, 234, 42),
        elevation: 0,
       ),
      ),
      ),
    ],
  ),
)
    );
  }
 



void addMarkers() async{
   final Uint8List markericon = await getBytesFromImage('images/pin.png', 40);
   markerbitmap = await BitmapDescriptor.fromBytes(markericon);
 
  }

  Future<Uint8List> getBytesFromImage(String path, int width) async{
ByteData data = await rootBundle.load(path);
ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetHeight: width);
ui.FrameInfo fi = await codec.getNextFrame();
return (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
  }

}
 