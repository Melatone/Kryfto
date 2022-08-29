import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geolocator_apple/geolocator_apple.dart';
import 'package:geolocator_android/geolocator_android.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:kryfto/game_page.dart';
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
Position position = await  _determinePosition();
         _mapController.animateCamera(
CameraUpdate.newCameraPosition(CameraPosition(target:LatLng(position.latitude,position.longitude),zoom: 20)));

markers.clear();
markers.add(Marker(markerId:const MarkerId("Current Location"),position: LatLng(position.latitude,position.longitude) ));
setState(() {
  
});
},
        child: const Icon(Icons.person_pin_circle),
        backgroundColor: Color(0xaaea2a3d),
        
       ),
        
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
Future<Position> _determinePosition() async  {
  bool serviceEnabled;
  LocationPermission permission;
  serviceEnabled = await Geolocator.isLocationServiceEnabled();
if(!serviceEnabled){
  return Future.error('Location services is disabled');

}
permission = await Geolocator.checkPermission();

if(permission ==LocationPermission.denied){
  return Future.error('Location permission denied');

}
if(permission == LocationPermission.deniedForever){
return Future.error('Location permissions denied forever.');
}

Position position  =  await Geolocator.getCurrentPosition();
return position;
}
}