import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class RoomInfo {
  List<LatLng> corners;
  String roomCode;
  List<LocationData> playerLocations;
  int playTime;
  int hideTime;
  RoomInfo(this.corners, this.roomCode, this.playerLocations, this.hideTime, this.playTime);
}
