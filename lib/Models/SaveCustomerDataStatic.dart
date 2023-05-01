import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class SaveCustomerDataStatic{
  static Position? currentLocation;



  static Future<List<Map<String, dynamic>>> getDistanceAndDuration(List<Map<String, double>> origins, List<Map<String, double>> destinations) async {
    const apiKey = 'AIzaSyB27woGrthGPEuCJcOIuN1C4MfCbW--PHc';
    final url = 'https://maps.googleapis.com/maps/api/distancematrix/json?units=imperial&key=$apiKey';

    final request = {
      'origins': origins.map((origin) => '${origin['latitude']},${origin['longitude']}').join('|'),
      'destinations': destinations.map((destination) => '${destination['latitude']},${destination['longitude']}').join('|'),
    };

    final response = await http.post(Uri.parse(url), body: request);
    final data = jsonDecode(response.body);
    print(response.body);
    if (data['status'] != 'OK') {
      throw Exception('Error calculating distance and duration');
    }else{
      print(response);
    }

    final results = <Map<String, dynamic>>[];
    final rows = data['rows'];

    for (var i = 0; i < rows.length; i++) {
      final elements = rows[i]['elements'];

      for (var j = 0; j < elements.length; j++) {
        final element = elements[j];

        if (element['status'] == 'OK') {
          final distance = element['distance']['text'];
          final duration = element['duration']['text'];
          final result = {
            'origin': origins[i],
            'destination': destinations[j],
            'distanceText': distance,
            'durationText': duration,
            'distanceValue': element['distance']['value'],
            'durationValue': element['duration']['value'],
          };
          results.add(result);
        } else {
          results.add({'error': element['status']});
        }
      }
    }

    return results;
  }


  static Future<void> testMethod() async {




    final locations = [
      {'latitude': 40.712776, 'longitude': -74.005974}, // New York, NY
      {'latitude': 34.052235, 'longitude': -118.243683}, // Los Angeles, CA
      {'latitude': 41.878114, 'longitude': -87.629798}, // Chicago, IL
      {'latitude': 29.760427, 'longitude': -95.369803}, // Houston, TX
      {'latitude': 39.952583, 'longitude': -75.165222}, // Philadelphia, PA
    ];

    final results = await getDistanceAndDuration(locations, locations);

    print('Results:');
    for (final result in results) {
      print('${result['origin']['latitude']},${result['origin']['longitude']} -> ${result['destination']['latitude']},${result['destination']['longitude']}');
      if (result['distanceText'] != null) {
        print('Distance: ${result['distanceText']}, Duration: ${result['durationText']}');
      } else {
        print('Error calculating distance and duration');
      }
    }

  }
}