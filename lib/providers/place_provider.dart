import 'dart:async';
import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:geolocator/geolocator.dart' as geolocator;
import 'package:mapbox_place_picker/mapbox_place_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:http/http.dart' as http;

class PlaceProvider extends ChangeNotifier {
  PlaceProvider(
    String apiKey,
    String mapBoxToken,
    String? proxyBaseUrl,
    // Map<String, dynamic> apiHeaders,
  ) {
    // places = GoogleMapsPlaces(
    //   apiKey: apiKey,
    //   baseUrl: proxyBaseUrl,
    //   httpClient: httpClient,
    //   apiHeaders: apiHeaders as Map<String, String>?,
    // );

    // geocoding = GoogleMapsGeocoding(
    //   apiKey: apiKey,
    //   baseUrl: proxyBaseUrl,
    //   httpClient: httpClient,
    //   apiHeaders: apiHeaders as Map<String, String>?,
    // );
  }

  static PlaceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<PlaceProvider>(context, listen: listen);

  // late GoogleMapsPlaces places;
  // late GoogleMapsGeocoding geocoding;
  String? sessionToken;
  bool isOnUpdateLocationCooldown = false;
  geolocator.LocationAccuracy? desiredAccuracy;
  bool isAutoCompleteSearching = false;

  Future<void> updateCurrentLocation(bool forceAndroidLocationManager) async {
    try {
      await Permission.location.request();
      if (await Permission.location.request().isGranted) {
        final position = await geolocator.Geolocator.getCurrentPosition(
            desiredAccuracy:
                desiredAccuracy ?? geolocator.LocationAccuracy.best);

        currentPosition =
            Position(position.latitude, position.longitude, position.altitude);
      } else {
        currentPosition = null;
      }
    } catch (e) {
      // print(e);
      currentPosition = null;
    }

    notifyListeners();
  }

  Position? _currentPoisition;
  Position? get currentPosition => _currentPoisition;
  set currentPosition(Position? newPosition) {
    _currentPoisition = newPosition;
    notifyListeners();
  }

  Timer? _debounceTimer;
  Timer? get debounceTimer => _debounceTimer;
  set debounceTimer(Timer? timer) {
    _debounceTimer = timer;
    notifyListeners();
  }

  Future<MapBoxLocation> getMapBoxAdddressByLocation({
    required double latitude,
    required double longitude,
  }) async {
    final response = await http.get(
      Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/$latitude,$longitude.json?access_token=pk.eyJ1Ijoiam9vbnRlY2giLCJhIjoiY2x2d2xrczI4MjgxcTJscWlpMW00bHE2YSJ9.uFpogwl2TNBo7ksJAFxNCg'),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final json = jsonDecode(response.body);
      return MapBoxLocation.fromJson(json);
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Failed to load data');
    }
  }

  String removeExtraSpacesAndPeriods(String input) {
    // Remove extra spaces and periods using regular expressions
    return input.replaceAll(RegExp(r'\s+|\.'), ' ').trim();
  }

  Future<MapBoxLocation> getMapBoxAdddressByText({
    required String searchText,
  }) async {
    final response = await http.get(
      Uri.parse(
          'https://api.mapbox.com/geocoding/v5/mapbox.places/${removeExtraSpacesAndPeriods(searchText).replaceAll(' ', '%20')}.json?access_token=pk.eyJ1Ijoiam9vbnRlY2giLCJhIjoiY2x2d2xrczI4MjgxcTJscWlpMW00bHE2YSJ9.uFpogwl2TNBo7ksJAFxNCg'),
    );

    if (response.statusCode == 200) {
      // If the server returns a 200 OK response, parse the JSON
      final json = jsonDecode(response.body);
      return MapBoxLocation.fromJson(json);
    } else {
      // If the server did not return a 200 OK response, throw an error.
      throw Exception('Failed to load data');
    }
  }

  Position? _previousCameraPosition;
  Position? get prevCameraPosition => _previousCameraPosition;

  setPrevCameraPosition(Position? prePosition) {
    _previousCameraPosition = prePosition;
  }

  Position? _currentCameraPosition;
  Position? get cameraPosition => _currentCameraPosition;

  setCameraPosition(Position? newPosition) {
    _currentCameraPosition = newPosition;
  }

  Features? _selectedPlace;
  Features? get selectedPlace => _selectedPlace;
  set selectedPlace(Features? result) {
    _selectedPlace = result;
    notifyListeners();
  }

  SearchingState _placeSearchingState = SearchingState.Idle;
  SearchingState get placeSearchingState => _placeSearchingState;
  set placeSearchingState(SearchingState newState) {
    _placeSearchingState = newState;
    notifyListeners();
  }

  MapboxMap? _mapboxMap;
  MapboxMap? get mapboxMap => _mapboxMap;

  // GoogleMapController? _mapController;
  // GoogleMapController? get mapController => _mapController;
  // set mapController(GoogleMapController? controller) {
  //   _mapController = controller;
  //   notifyListeners();
  // }

  onMapCreated(MapboxMap mapboxMap) {
    _mapboxMap = mapboxMap;
    notifyListeners();
  }

  PinState _pinState = PinState.Preparing;
  PinState get pinState => _pinState;
  set pinState(PinState newState) {
    _pinState = newState;
    notifyListeners();
  }

  bool _isSeachBarFocused = false;
  bool get isSearchBarFocused => _isSeachBarFocused;
  set isSearchBarFocused(bool focused) {
    _isSeachBarFocused = focused;
    notifyListeners();
  }

  String _mapType = MapboxStyles.MAPBOX_STREETS;

  String get mapType => _mapType;

  setMapType(String mapType, {bool notify = false}) {
    _mapType = mapType;
    if (notify) notifyListeners();
  }

  // switchMapType() {
  //   _mapType = MapType.values[(_mapType.index + 1) % MapType.values.length];
  //   if (_mapType == MapType.none) _mapType = MapType.normal;

  //   notifyListeners();
  // }
}
