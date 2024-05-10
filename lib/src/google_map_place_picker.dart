import 'package:flutter/material.dart';

import 'package:mapbox_place_picker/mapbox_place_picker.dart';
import 'package:mapbox_place_picker/providers/place_provider.dart';
import 'package:mapbox_place_picker/src/components/animated_pin.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

typedef SelectedPlaceWidgetBuilder = Widget Function(
  BuildContext context,
  Features? selectedPlace,
  SearchingState state,
  bool isSearchBarFocused,
);

typedef PinBuilder = Widget Function(
  BuildContext context,
  PinState state,
);

class GoogleMapPlacePicker extends StatelessWidget {
  const GoogleMapPlacePicker({
    Key? key,
    // required this.initialTarget,
    required this.appBarKey,
    this.selectedPlaceWidgetBuilder,
    this.pinBuilder,
    this.onSearchFailed,
    this.onMoveStart,
    this.onMapCreated,
    this.debounceMilliseconds,
    this.enableMapTypeButton,
    this.enableMyLocationButton,
    this.onToggleMapType,
    this.onMyLocation,
    this.onPlacePicked,
    this.usePinPointingSearch,
    this.usePlaceDetailSearch,
    this.selectInitialPosition,
    this.language,
    this.forceSearchOnZoomChanged,
    this.hidePlaceDetailsWhenDraggingPin,
  }) : super(key: key);

  // final LatLng initialTarget;
  final GlobalKey appBarKey;

  final SelectedPlaceWidgetBuilder? selectedPlaceWidgetBuilder;
  final PinBuilder? pinBuilder;

  final ValueChanged<String>? onSearchFailed;
  final VoidCallback? onMoveStart;
  final MapCreatedCallback? onMapCreated;
  final VoidCallback? onToggleMapType;
  final VoidCallback? onMyLocation;
  final ValueChanged<Features>? onPlacePicked;

  final int? debounceMilliseconds;
  final bool? enableMapTypeButton;
  final bool? enableMyLocationButton;

  final bool? usePinPointingSearch;
  final bool? usePlaceDetailSearch;

  final bool? selectInitialPosition;

  final String? language;

  final bool? forceSearchOnZoomChanged;
  final bool? hidePlaceDetailsWhenDraggingPin;

  _searchByCameraLocation(PlaceProvider provider) async {
    // We don't want to search location again if camera location is changed by zooming in/out.
    // bool hasZoomChanged = provider.cameraPosition != null &&
    //     provider.prevCameraPosition != null &&
    //     provider.cameraPosition!.zoom != provider.prevCameraPosition!.zoom;

    bool hasZoomChanged =
        provider.cameraPosition != null && provider.prevCameraPosition != null;
    final delta = await provider.mapboxMap?.getPrefetchZoomDelta();
    print(delta);
    if (forceSearchOnZoomChanged == false && hasZoomChanged) {
      provider.placeSearchingState = SearchingState.Idle;
      return;
    }

    provider.placeSearchingState = SearchingState.Searching;

// provider.se
    // final GeocodingResponse response =
    //     await provider.geocoding.searchByLocation(
    //   Location(
    //       lat: provider.cameraPosition!.target.latitude,
    //       lng: provider.cameraPosition!.target.longitude),
    //   language: language,
    // );

    // if (response.errorMessage?.isNotEmpty == true ||
    //     response.status == "REQUEST_DENIED") {
    //   print("Camera Location Search Error: " + response.errorMessage!);
    //   if (onSearchFailed != null) {
    //     onSearchFailed!(response.status);
    //   }
    //   provider.placeSearchingState = SearchingState.Idle;
    //   return;
    // }

    // final List<geocoder.Placemark> placeMarks =
    //     await geocoder.placemarkFromCoordinates(
    //   provider.cameraPosition?.lat.toDouble() ?? 0,
    //   provider.cameraPosition?.lng.toDouble() ?? 0,

    // );

    // PickResult result = PickResult.fromGeocodingResult(response.results[0]);

    // result.city = placeMarks.first.locality;
    // result.country = placeMarks.first.country;
    // provider.selectedPlace = result;

    provider.placeSearchingState = SearchingState.Idle;
  }

  // _onMapCreated(PlaceProvider provider, MapboxMap mapboxMap) {
  //   provider.onMapCreated(mapboxMap) = mapboxMap;
  //   mapboxMap.style;
  // }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        _buildGoogleMap(context),
        _buildPin(),
        _buildFloatingCard(),
        _buildMapIcons(context),
      ],
    );
  }

  Widget _buildGoogleMap(BuildContext context) {
    return Selector<PlaceProvider, String>(
        selector: (_, provider) => provider.mapType,
        builder: (_, data, __) {
          PlaceProvider provider = PlaceProvider.of(context, listen: false);
          // CameraPosition initialCameraPosition =
          //     CameraPosition(target: initialTarget, zoom: 15);

          return MapWidget(
            key: const ValueKey("mapWidget"),
            cameraOptions: CameraOptions(
              center: Point(
                coordinates: Position(
                  0,
                  43.70908256335716,
                ),
              ),
              zoom: 15,
            ),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            textureView: true,

            onMapCreated: provider.onMapCreated,
            // onStyleLoadedListener: _onStyleLoadedCallback,
            // onCameraChangeListener: _onCameraChangeListener,
            onMapIdleListener: (data) {
              _searchByCameraLocation(provider);
              print("MapIdleEventData: timestamp: ${data.timestamp}");
            },
            // onMapLoadedListener: _onMapLoadedListener,
            // onMapLoadErrorListener: _onMapLoadingErrorListener,
            // onRenderFrameStartedListener: _onRenderFrameStartedListener,
            // onRenderFrameFinishedListener: _onRenderFrameFinishedListener,
            // onSourceAddedListener: _onSourceAddedListener,
            // onSourceDataLoadedListener: _onSourceDataLoadedListener,
            // onSourceRemovedListener: _onSourceRemovedListener,
            // onStyleDataLoadedListener: _onStyleDataLoadedListener,
            // onStyleImageMissingListener: _onStyleImageMissingListener,
            // onStyleImageUnusedListener: _onStyleImageUnusedListener,
            // onResourceRequestListener: _onResourceRequestListener,
            onLongTapListener: (coordinate) {},
            onScrollListener: (context) {},
            onCameraChangeListener: (data) {
              print("onCameraChangeListener: timestamp: ${data.timestamp}");
            },
          );

          // return GoogleMap(
          //   myLocationButtonEnabled: false,
          //   compassEnabled: false,
          //   mapToolbarEnabled: false,
          //   initialCameraPosition: initialCameraPosition,
          //   mapType: data,
          //   myLocationEnabled: true,
          //   onMapCreated: (GoogleMapController controller) {
          //     provider.mapController = controller;
          //     provider.setCameraPosition(null);
          //     provider.pinState = PinState.Idle;

          //     // When select initialPosition set to true.
          //     if (selectInitialPosition ?? false) {
          //       provider.setCameraPosition(initialCameraPosition);
          //       _searchByCameraLocation(provider);
          //     }
          //   },
          //   onCameraIdle: () {
          //     if (provider.isAutoCompleteSearching) {
          //       provider.isAutoCompleteSearching = false;
          //       provider.pinState = PinState.Idle;
          //       return;
          //     }

          //     // Perform search only if the setting is to true.
          //     if (usePinPointingSearch!) {
          //       // Search current camera location only if camera has moved (dragged) before.
          //       if (provider.pinState == PinState.Dragging) {
          //         // Cancel previous timer.
          //         if (provider.debounceTimer?.isActive ?? false) {
          //           provider.debounceTimer!.cancel();
          //         }
          //         provider.debounceTimer =
          //             Timer(Duration(milliseconds: debounceMilliseconds!), () {
          //           _searchByCameraLocation(provider);
          //         });
          //       }
          //     }

          //     provider.pinState = PinState.Idle;
          //   },
          //   onCameraMoveStarted: () {
          //     provider.setPrevCameraPosition(provider.cameraPosition);

          //     // Cancel any other timer.
          //     provider.debounceTimer?.cancel();

          //     // Update state, dismiss keyboard and clear text.
          //     provider.pinState = PinState.Dragging;

          //     // Begins the search state if the hide details is enabled
          //     if (hidePlaceDetailsWhenDraggingPin ?? false) {
          //       provider.placeSearchingState = SearchingState.Searching;
          //     }

          //     onMoveStart?.call();
          //   },
          //   onCameraMove: (CameraPosition position) {
          //     provider.setCameraPosition(position);
          //     provider.placeSearchingState = SearchingState.Idle;
          //   },
          //   // gestureRecognizers make it possible to navigate the map when it's a
          //   // child in a scroll view e.g ListView, SingleChildScrollView...
          //   gestureRecognizers: Set()
          //     ..add(Factory<EagerGestureRecognizer>(
          //         () => EagerGestureRecognizer())),
          // );
        });
  }

  Widget _buildPin() {
    return Center(
      child: Selector<PlaceProvider, PinState>(
        selector: (_, provider) => provider.pinState,
        builder: (context, state, __) {
          if (pinBuilder == null) {
            return _defaultPinBuilder(context, state);
          } else {
            return Builder(
                builder: (builderContext) =>
                    pinBuilder!(builderContext, state));
          }
        },
      ),
    );
  }

  Widget _defaultPinBuilder(BuildContext context, PinState state) {
    if (state == PinState.Preparing) {
      return Container();
    } else if (state == PinState.Idle) {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.place, size: 36, color: Colors.red),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    } else {
      return Stack(
        children: <Widget>[
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimatedPin(
                    child: Icon(Icons.place, size: 36, color: Colors.red)),
                SizedBox(height: 42),
              ],
            ),
          ),
          Center(
            child: Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.black,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      );
    }
  }

  Widget _buildFloatingCard() {
    return Selector<PlaceProvider,
        Tuple4<Features?, SearchingState, bool, PinState>>(
      selector: (_, provider) => Tuple4(
          provider.selectedPlace,
          provider.placeSearchingState,
          provider.isSearchBarFocused,
          provider.pinState),
      builder: (context, data, __) {
        if ((data.item1 == null && data.item2 == SearchingState.Idle) ||
            data.item3 == true ||
            data.item4 == PinState.Dragging &&
                this.hidePlaceDetailsWhenDraggingPin!) {
          return Container();
        } else {
          if (selectedPlaceWidgetBuilder == null) {
            return _defaultPlaceWidgetBuilder(context, data.item1, data.item2);
          } else {
            return Builder(
                builder: (builderContext) => selectedPlaceWidgetBuilder!(
                    builderContext, data.item1, data.item2, data.item3));
          }
        }
      },
    );
  }

  Widget _defaultPlaceWidgetBuilder(
      BuildContext context, Features? data, SearchingState state) {
    return FloatingCard(
      bottomPosition: MediaQuery.of(context).size.height * 0.05,
      leftPosition: MediaQuery.of(context).size.width * 0.025,
      rightPosition: MediaQuery.of(context).size.width * 0.025,
      width: MediaQuery.of(context).size.width * 0.9,
      borderRadius: BorderRadius.circular(12.0),
      elevation: 4.0,
      color: Theme.of(context).cardColor,
      child: state == SearchingState.Searching
          ? _buildLoadingIndicator()
          : _buildSelectionDetails(context, data!),
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      height: 48,
      child: const Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  Widget _buildSelectionDetails(BuildContext context, Features result) {
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      // primary: Colors.grey[300],

      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(4.0),
      ),
    );
    return Container(
      margin: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Text(
            result.placeName ?? '',
            style: const TextStyle(fontSize: 18),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            style: raisedButtonStyle,
            child: const Text(
              "Select here",
              style: TextStyle(fontSize: 16),
            ),
            onPressed: () {
              onPlacePicked!(result);
            },
          ),
          // RaisedButton(
          //   padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
          //   child: Text(
          //     "Select here",
          //     style: TextStyle(fontSize: 16),
          //   ),
          //   shape: RoundedRectangleBorder(
          //     borderRadius: BorderRadius.circular(4.0),
          //   ),
          //   onPressed: () {
          //     onPlacePicked!(result);
          //   },
          // ),
        ],
      ),
    );
  }

  Widget _buildMapIcons(BuildContext context) {
    final RenderBox appBarRenderBox =
        appBarKey.currentContext!.findRenderObject() as RenderBox;

    return Positioned(
      top: appBarRenderBox.size.height,
      right: 15,
      child: Column(
        children: <Widget>[
          enableMapTypeButton!
              ? Container(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onToggleMapType,
                    child: const Icon(Icons.layers),
                  ),
                )
              : Container(),
          const SizedBox(height: 10),
          enableMyLocationButton!
              ? SizedBox(
                  width: 35,
                  height: 35,
                  child: RawMaterialButton(
                    shape: const CircleBorder(),
                    fillColor: Theme.of(context).brightness == Brightness.dark
                        ? Colors.black54
                        : Colors.white,
                    elevation: 8.0,
                    onPressed: onMyLocation,
                    child: Icon(Icons.my_location),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }
}
