import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/game_page.dart';
import 'package:location/location.dart';
import 'theme.dart';

class MapScreen extends StatelessWidget {
  const MapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme(),
      
      home: MapPage(),
    );
  }
}

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  static const initCameraPosition = CameraPosition(
    target: LatLng(-36.853940, 174.764620),
    zoom:16);
    bool isMapCreated = false; 
   late GoogleMapController _mapController;
 
  Set<Marker> markers = {};
  
  LocationData? currentLocation;
void getLocation(){
Location location = Location();

location.getLocation().then((location) {
currentLocation = location;
},
);

}

@override
void initState(){
  getLocation();
  super.initState();
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
        title: Text("Kryfto",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 45, color: Theme.of(context).backgroundColor) )),
        backgroundColor: Color(0xaaea2a3d),
        elevation: 0,
        ),

      body:  GoogleMap(
        markers: markers,
        zoomControlsEnabled: true,
        myLocationButtonEnabled: false,
        
initialCameraPosition: initCameraPosition,
onMapCreated:(GoogleMapController controller){
  _mapController = controller;
  isMapCreated = true;
  changeMapMode();
  setState(() {
    
  });
  
}


      ),
      floatingActionButton: FloatingActionButton(
       
        onPressed: () async {

         _mapController.animateCamera(
CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(currentLocation!.latitude!,currentLocation!.longitude!),zoom: 20)));

markers.clear();
markers.add(Marker(markerId:const MarkerId("Current Location"),
position: LatLng(currentLocation!.latitude!,currentLocation!.longitude!),
 ));
setState(() {
  
});
},
        child: const Icon(Icons.person_pin_circle),
        backgroundColor: Color(0xaaea2a3d),
        
       ),
        
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }

}