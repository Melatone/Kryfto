import 'package:google_maps_flutter/google_maps_flutter.dart';

class RoomInfo {
  List<LatLng> corners;
  String roomCode;
  int totalPlayer;
  int maxSeeker;

  RoomInfo(this.corners, this.maxSeeker, this.totalPlayer, this.roomCode);
}
