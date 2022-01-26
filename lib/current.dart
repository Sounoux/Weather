import 'package:flutter/material.dart';
import 'models/forcast.dart';
import 'models/location.dart';
import 'models/weather.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locations;
  final BuildContext context;
  const CurrentWeatherPage(this.locations, this.context, {Key? key})
      : super(key: key);

  @override
  _CurrentWeatherPageState createState() =>
      _CurrentWeatherPageState(locations, context);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  final List<Location> locations;
  final Location location;
  @override
  final BuildContext context;
  _CurrentWeatherPageState(this.locations, this.context)
      : location = locations[0];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(children: <Widget>[
          currentWeatherViews(locations, location, this.context),
          forcastViewsHourly(location),
          forcastViewsDaily(location),
        ]));
  }
}

Widget currentWeatherViews(
    List<Location> locations, Location location, BuildContext context) {
  Weather? _weather;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _weather = snapshot.data as Weather?;
        if (_weather == null) {
          return const Text("Error getting weather");
        } else {
          return Column(children: [
            createAppBar(locations, location, context),
            weatherBox(_weather!),
            weatherDetailsBox(_weather!),
          ]);
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
    future: getCurrentWeather(location),
  );
}

Widget forcastViewsHourly(Location location) {
  Forecast? _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data as Forecast?;
        if (_forcast == null) {
          return const Text("Error getting weather");
        } else {
          return hourlyBoxes(_forcast!);
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget forcastViewsDaily(Location location) {
  Forecast? _forcast;

  return FutureBuilder(
    builder: (context, snapshot) {
      if (snapshot.hasData) {
        _forcast = snapshot.data as Forecast?;
        if (_forcast == null) {
          return const Text("Error getting weather");
        } else {
          return dailyBoxes(_forcast!);
        }
      } else {
        return const Center(child: CircularProgressIndicator());
      }
    },
    future: getForecast(location),
  );
}

Widget createAppBar(
    List<Location> locations, Location location, BuildContext context) {
  return Container(
      padding: const EdgeInsets.only(left: 20, top: 5, bottom: 5, right: 20),
      margin:
          const EdgeInsets.only(top: 35, left: 15.0, bottom: 15.0, right: 15.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.all(Radius.circular(60)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            )
          ]),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text.rich(
            TextSpan(
              children: <TextSpan>[
                TextSpan(
                    text: '${location.city}, ',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 16)),
                TextSpan(
                    text: location.country,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal, fontSize: 16)),
              ],
            ),
          ),
          IconButton(
              onPressed: () async {
                showSearch(context: context, delegate: CitySearch());

                // final results = await
                //     showSearch(context: context, delegate: CitySearch());

                // print('Result: $results');
              },
              icon: const Icon(
                Icons.keyboard_arrow_down_rounded,
                color: Colors.black,
                size: 24.0,
                semanticLabel: 'Taper pour changer de ville',
              )),
        ],
      ));
}

class CitySearch extends SearchDelegate<Location> {
  List<Location>? locations;
  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            if (query.isEmpty) {
              close(
                  context,
                  Location(
                      city: "paris",
                      country: "france",
                      lat: "48.853",
                      lon: "2.349"));
            } else {
              query = '';
              showSuggestions(context);
            }
          },
        )
      ];

  @override
  Widget buildLeading(BuildContext context) => IconButton(
        icon: const Icon(Icons.arrow_back),
        onPressed: () => close(
            context,
            Location(
                city: "paris", country: "france", lat: "48.853", lon: "2.349")),
      );

  @override
  Widget buildResults(BuildContext context) => FutureBuilder<Weather?>(
        future: getWeather(city: query),
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(child: CircularProgressIndicator());
            default:
              print(snapshot.hasData);
              if (snapshot.hasError) {
                return Container(
                  color: Colors.black,
                  alignment: Alignment.center,
                  child: const Text(
                    'Quelque chose s est mal passé!',
                    style: TextStyle(fontSize: 28, color: Colors.white),
                  ),
                );
              } else {
                return CurrentWeatherPage(
                    locations = [
                      Location(
                          city: snapshot.data!.city,
                          country: snapshot.data!.country,
                          lat: snapshot.data!.lat.toString(),
                          lon: snapshot.data!.long.toString())
                    ],
                    context);
              }
          }
        },
      );

  @override
  Widget buildSuggestions(BuildContext context) => Container(
        color: Colors.black,
        child: FutureBuilder<List<String>>(
          future: searchCities(query: query),
          builder: (context, snapshot) {
            if (query.isEmpty) return buildNoSuggestions();
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              default:
                if (snapshot.hasError || snapshot.data!.isEmpty) {
                  return buildNoSuggestions();
                } else {
                  return buildSuggestionsSuccess(snapshot.data!);
                }
            }
          },
        ),
      );

  Widget buildSuggestionsSuccess(List<String> suggestions) => ListView.builder(
        itemCount: suggestions.length,
        itemBuilder: (context, index) {
          final suggestion = suggestions[index];
          final queryText = suggestion.substring(0, query.length);
          final remainingText = suggestion.substring(query.length);

          return ListTile(
            onTap: () {
              query = suggestion;
              showResults(context);
            },
            leading: const Icon(Icons.location_city),
            title: RichText(
              text: TextSpan(
                text: queryText,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
                children: [
                  TextSpan(
                    text: remainingText,
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      );

  Widget buildNoSuggestions() => const Center(
        child: Text(
          'Pas de suggestion!',
          style: TextStyle(fontSize: 28, color: Colors.white),
        ),
      );

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget weatherDetailsBox(Weather _weather) {
  return Container(
    padding: const EdgeInsets.only(left: 15, top: 25, bottom: 25, right: 15),
    margin: const EdgeInsets.only(left: 15, top: 5, bottom: 15, right: 15),
    decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          )
        ]),
    child: Row(
      children: [
        Expanded(
            child: Column(
          children: [
            const Text(
              "Vitesse",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey),
            ),
            Text(
              "${_weather.wind} km/h",
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black),
            )
          ],
        )),
        Expanded(
            child: Column(
          children: [
            const Text(
              "Humidité",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey),
            ),
            Text(
              "${_weather.humidity.toInt()}%",
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black),
            )
          ],
        )),
        Expanded(
            child: Column(
          children: [
            const Text(
              "Pression",
              textAlign: TextAlign.left,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                  color: Colors.grey),
            ),
            Text(
              "${_weather.pressure} hPa",
              textAlign: TextAlign.left,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 15,
                  color: Colors.black),
            )
          ],
        ))
      ],
    ),
  );
}

Widget weatherBox(Weather _weather) {
  return Stack(children: [
    Container(
      padding: const EdgeInsets.all(15.0),
      margin: const EdgeInsets.all(15.0),
      height: 160.0,
      decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/cloud4.jpg"),
            fit: BoxFit.cover,
          ),
          borderRadius: BorderRadius.all(Radius.circular(20))),
    ),
    Container(
        padding: const EdgeInsets.all(15.0),
        margin: const EdgeInsets.all(15.0),
        height: 160.0,
        decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20))),
        child: Row(
          children: [
            Expanded(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                  getWeatherIcon(_weather.icon),
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Text(
                        _weather.description,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 16,
                            color: Colors.white),
                      )),
                  Container(
                      margin: const EdgeInsets.all(5.0),
                      child: Text(
                        "Max:${_weather.high.toInt()}° Min:${_weather.low.toInt()}°",
                        textAlign: TextAlign.left,
                        style: const TextStyle(
                            fontWeight: FontWeight.normal,
                            fontSize: 13,
                            color: Colors.white),
                      )),
                ])),
            Column(children: <Widget>[
              Text(
                "${_weather.temp.toInt()}°",
                textAlign: TextAlign.left,
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 60,
                    color: Colors.white),
              ),
              Container(
                  margin: const EdgeInsets.all(0),
                  child: Text(
                    "Ressenti : ${_weather.feelsLike.toInt()}°",
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 13,
                        color: Colors.white),
                  )),
            ])
          ],
        ))
  ]);
}

Image getWeatherIcon(String _icon) {
  String path = 'assets/icons/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 70,
    height: 70,
  );
}

Image getWeatherIconSmall(String _icon) {
  String path = 'assets/icons/';
  String imageExtension = ".png";
  return Image.asset(
    path + _icon + imageExtension,
    width: 40,
    height: 40,
  );
}

Widget hourlyBoxes(Forecast _forecast) {
  return Container(
      margin: const EdgeInsets.symmetric(vertical: 0.0),
      height: 150.0,
      child: ListView.builder(
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          scrollDirection: Axis.horizontal,
          itemCount: _forecast.hourly.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 15, bottom: 15, right: 10),
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(Radius.circular(18)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset:
                            const Offset(0, 1), // changes position of shadow
                      )
                    ]),
                child: Column(children: [
                  Text(
                    "${_forecast.hourly[index].temp}°",
                    style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 17,
                        color: Colors.black),
                  ),
                  getWeatherIcon(_forecast.hourly[index].icon),
                  Text(
                    getTimeFromTimestamp(_forecast.hourly[index].dt),
                    style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                        color: Colors.grey),
                  ),
                ]));
          }));
}

String getTimeFromTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = DateFormat('h:mm a');
  return formatter.format(date);
}

String getDateFromTimestamp(int timestamp) {
  var date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
  var formatter = DateFormat('E, M/d/y');
  return formatter.format(date);
}

Widget dailyBoxes(Forecast _forcast) {
  return Expanded(
      child: ListView.builder(
          shrinkWrap: true,
          physics: const ClampingScrollPhysics(),
          padding: const EdgeInsets.only(left: 8, top: 0, bottom: 0, right: 8),
          itemCount: _forcast.daily.length,
          itemBuilder: (BuildContext context, int index) {
            return Container(
                padding: const EdgeInsets.only(
                    left: 10, top: 5, bottom: 5, right: 10),
                margin: const EdgeInsets.all(5),
                child: Row(children: [
                  Expanded(
                      child: Text(
                    getDateFromTimestamp(_forcast.daily[index].dt),
                    style: const TextStyle(fontSize: 14, color: Colors.black),
                  )),
                  Expanded(
                      child: getWeatherIconSmall(_forcast.daily[index].icon)),
                  Expanded(
                      child: Text(
                    "${_forcast.daily[index].high.toInt()}°/${_forcast.daily[index].low.toInt()}°",
                    textAlign: TextAlign.right,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  )),
                ]));
          }));
}

Future<List<String>> searchCities({required String query}) async {
  const limit = 3;
  String apiKey = "856b01315a5c75ab8c8f23eee3155494";
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

Future<Weather?> getWeather({required String city}) async {
  Weather? weather;
  String apiKey = "856b01315a5c75ab8c8f23eee3155494";
  final url =
      'https://api.openweathermap.org/data/2.5/weather?q=$city&units=metric&appid=$apiKey';

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  }

  return weather;
}

Future getCurrentWeather(Location location) async {
  Weather? weather;
  String city = location.city;
  String apiKey = "856b01315a5c75ab8c8f23eee3155494";
  var url =
      "https://api.openweathermap.org/data/2.5/weather?q=$city&appid=$apiKey&units=metric";

  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    weather = Weather.fromJson(jsonDecode(response.body));
  }

  return weather;
}

Future getForecast(Location location) async {
  Forecast? forecast;
  String apiKey = "856b01315a5c75ab8c8f23eee3155494";
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
