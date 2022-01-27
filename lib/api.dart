import 'dart:convert';
import 'package:http/http.dart' as http;
import 'models/location.dart';
import 'models/weather.dart';
import 'models/forcast.dart';

class WeatherApi {
  static const apiKey = '856b01315a5c75ab8c8f23eee3155494';

  static Future<List<String>> searchCities({required String query}) async {
    const limit = 3;
    final url =
        'https://api.openweathermap.org/geo/1.0/direct?q=$query&limit=$limit&appid=$apiKey';

    final response = await http.get(Uri.parse(url));
    final body = json.decode(response.body);

    return body.map<String>((json) {
      final city = json['name'];
      final country = json['country'];

      return '$city, $country';
    }).toList();
  }

  static Future<Weather?> getWeather({required String city}) async {
    Weather? weather;
    final url =
        'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    }

    return weather;
  }

  static Future getCurrentWeather(Location location) async {
    Weather? weather;
    String city = location.city;
    var url =
        "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      weather = Weather.fromJson(jsonDecode(response.body));
    }

    return weather;
  }

  static Future getForecast(Location location) async {
    Forecast? forecast;
    String lat = location.lat;
    String lon = location.lon;
    var url =
        "https://api.openweathermap.org/data/2.5/onecall?lat=$lat&lon=$lon&appid=$apiKey&units=metric";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      forecast = Forecast.fromJson(jsonDecode(response.body));
    }

    return forecast;
  }
}
