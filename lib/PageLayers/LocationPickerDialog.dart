import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';

class LocationPickerDialog extends StatefulWidget {

  late LatLng? currentLocation;

  Future<void> Function(LatLng latLng)? setLocation;


  LocationPickerDialog({this.currentLocation, this.setLocation});

  @override
  _LocationPickerDialogState createState() => _LocationPickerDialogState();
}

class _LocationPickerDialogState extends State<LocationPickerDialog> {
  late GoogleMapController mapController;
  late LatLng currentLocation; // San Francisco
  late String searchQuery = "";
  Set<Marker> markers = {};
  late GoogleMapsPlaces places;
  List<Prediction> searchResults = [];


  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;

    _moveCamera(currentLocation);
  }

  void _moveCamera(LatLng location) {
    mapController.animateCamera(CameraUpdate.newCameraPosition(
      CameraPosition(
        target: location,
        zoom: 14.0,
      ),
    ));
  }

  Future<void> _getPlacesPredictions(String input) async {
    if (input.isEmpty && searchQuery.trim().isEmpty) {
      setState(() {
        searchResults = [];
      });
      return;
    }


    final placesResponse = await places.autocomplete(
      input,
    );

    if (placesResponse.isOkay) {
      searchResults = await placesResponse.predictions;
      setState(() {
      });
    }else{
      print(placesResponse.errorMessage);
    }
  }

  void _addMarker(LatLng location) {
    markers.clear();
    markers.add(
      Marker(
        markerId: MarkerId("selected-location"),
        position: location,
      ),
    );
    if(widget.setLocation != null){
      widget.setLocation!(location);
    }

  }

  void _selectPlace(Prediction place) async {
    final details = await places.getDetailsByPlaceId(place.placeId!);
    final location = LatLng(
      details.result.geometry!.location.lat,
      details.result.geometry!.location.lng,
    );

    _moveCamera(location);
    _addMarker(location);
  }


  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    currentLocation = widget.currentLocation ?? const LatLng(37.7749, -122.4194);

    places = GoogleMapsPlaces(apiKey:"AIzaSyB27woGrthGPEuCJcOIuN1C4MfCbW--PHc");

  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),

      child: Container(
        height: MediaQuery.of(context).size.height * 0.7,
        width: MediaQuery.of(context).size.width*.8,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              width: MediaQuery.of(context).size.width*.7,
              child: Autocomplete<Prediction>(
                optionsBuilder: (TextEditingValue value) {
                  return searchResults.where((result) =>
                      result.description!
                          .toLowerCase()
                          .contains(value.text.toLowerCase()));
                },
                optionsViewBuilder: (context1, onSelected, options) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: (MediaQuery.of(context).size.width*.7)-16,
                      child: Material(
                        child: ListView.builder(
                          itemCount: options.length,
                          itemBuilder: (BuildContext context1, int index) {
                            final Prediction option = options.elementAt(index);
                            return GestureDetector(
                              onTap: () {
                                onSelected(option);
                              },
                              child: ListTile(
                                title: Text(option.description!),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
                onSelected: (place) {
                  _selectPlace(place);
                },
                fieldViewBuilder: (BuildContext context,
                    TextEditingController fieldTextEditingController,
                    FocusNode fieldFocusNode,
                    VoidCallback onFieldSubmitted) {
                  return TextField(
                    controller: fieldTextEditingController,
                    focusNode: fieldFocusNode,
                    decoration: InputDecoration(
                      hintText: "Search for a location",
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) async {
                      searchQuery = value;
                      await _getPlacesPredictions(value);
                      setState(() {

                      });
                    },
                    onEditingComplete: () {
                      _getPlacesPredictions(searchQuery);
                    },
                    onTap: () {
                      _getPlacesPredictions(searchQuery);
                    },

                  );
                },
                displayStringForOption: (option) => option.description!,

              ),
            ),
            Expanded(
              child: GoogleMap(
                myLocationEnabled: true,
                myLocationButtonEnabled: true,

                mapType: MapType.normal,
                onMapCreated: (controller) {
                  _onMapCreated(controller);
                },
                markers: markers,
                initialCameraPosition: CameraPosition(
                  target: currentLocation,
                  zoom: 14.0,
                ),
                onTap: (LatLng location) {
                  setState(() {
                    _addMarker(location);
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop(markers.first.position);
                },
                child: Text("Select Location"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}