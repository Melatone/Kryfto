import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  
  late GoogleMapController _mapController;


  @override
  void dispose(){
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        leading: IconButton(onPressed: (){ Navigator.push(context, MaterialPageRoute(builder: (context) => const GamePage()));
        },
        icon: Icon(Icons.arrow_back_ios)),
        centerTitle: true,
        title: Text("Kryfto",style: GoogleFonts.righteous(textStyle: TextStyle(fontSize: 45, color: Theme.of(context).backgroundColor) )),
        backgroundColor: Color(0xaaea2a3d),
        elevation: 0,
        ),

      body:  GoogleMap(
        zoomControlsEnabled: false,
        
initialCameraPosition: initCameraPosition,
onMapCreated:(GoogleMapController controller){
  _mapController = controller;
  changeMapMode();
  setState(() {
    
  });
}

      ),
      floatingActionButton: FloatingActionButton(
        onPressed:  () => _mapController.animateCamera(
CameraUpdate.newCameraPosition(initCameraPosition)),
        child: const Icon(Icons.center_focus_strong),
        backgroundColor: Color(0xaaea2a3d),),
      
    );
  }
Future<String> getJsonFile(String path) async{
  return await rootBundle.loadString(path);
}

void setMapStyle(String mapStyle){
  _mapController.setMapStyle(mapStyle);
}

  changeMapMode(){
     getJsonFile("assets/map.json").then(setMapStyle);
  }
}