import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'models/forcast.dart';
import 'models/location.dart';
import 'models/weather.dart';
import 'api.dart';
import 'search.dart';
import 'package:intl/intl.dart';

class CurrentWeatherPage extends StatefulWidget {
  final List<Location> locations;
  final BuildContext context;
  late String unit = '';
  CurrentWeatherPage(this.locations, this.context, this.unit, {Key? key})
      : super(key: key);

  @override
  _CurrentWeatherPageState createState() =>
      _CurrentWeatherPageState(locations, context, unit);
}

class _CurrentWeatherPageState extends State<CurrentWeatherPage> {
  late String unit = '';
  final List<Location> locations;
  final Location location;
  late List<bool> isSelected;

  onButtonPressed(int value) {
    if (value == 0) {
      setState(() {
        unit = '';
      });
    } else if (value == 1) {
      setState(() {
        unit = 'metric';
      });
    } else if (value == 2) {
      setState(() {
        unit = 'imperial';
      });
    }
  }

  @override
  void initState() {
    isSelected = [true, false, false];
    super.initState();
  }

  @override
  final BuildContext context;
  _CurrentWeatherPageState(this.locations, this.context, this.unit)
      : location = locations[0];
  String dropdownValue = '';
  late String valueMenu = '${location.city}, ${location.country}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey[100],
        body: ListView(children: <Widget>[
          currentWeatherViews(locations, location, this.context, unit),
          forcastViewsHourly(location, unit),
          forcastViewsDaily(location, unit),
        ]));
  }

  Widget currentWeatherViews(List<Location> locations, Location location,
      BuildContext context, String unit) {
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
      future: WeatherApi.getCurrentWeather(location, unit),
    );
  }

  Widget createAppBar(
      List<Location> locations, Location location, BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
                onPressed: () async {
                  showSearch(context: context, delegate: CitySearch());
                },
                icon: const Icon(
                  CupertinoIcons.map_fill,
                  color: Colors.black,
                )),
            Row(
              children: <Widget>[
                Container(
                    padding: const EdgeInsets.only(
                        left: 20, top: 0, bottom: 0, right: 20),
                    margin: const EdgeInsets.only(
                        top: 35, left: 15.0, bottom: 15.0, right: 15.0),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(60)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(0, 3),
                          )
                        ]),
                    child: Row(children: [
                      const Icon(
                        Icons.star_border,
                        color: Colors.black,
                        size: 24.0,
                      ),
                      DropdownButton<String>(
                        value: valueMenu,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? newValue) {
                          setState(() {
                            valueMenu = newValue!;
                          });
                        },
                        items: <String>[
                          '${location.city}, ${location.country}',
                          'Two',
                          'Free',
                          'Four'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ]))
              ],
            ),
            Row(children: <Widget>[
              RotatedBox(
                quarterTurns: 1,
                child: ToggleButtons(
                  children: const <Widget>[
                    RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Kelvin K',
                          ),
                        )),
                    RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Celsius °C',
                          ),
                        )),
                    RotatedBox(
                        quarterTurns: 3,
                        child: Padding(
                          padding: EdgeInsets.all(5.0),
                          child: Text(
                            'Fahrenheit °F',
                          ),
                        )),
                  ],
                  // logic for button selection below
                  onPressed: (int index) {
                    setState(() {
                      for (int i = 0; i < isSelected.length; i++) {
                        isSelected[i] = i == index;
                        onButtonPressed(index);
                      }
                    });
                  },

                  isSelected: isSelected,
                ),
              )
            ])
          ],
        ));
  }
}

Widget forcastViewsHourly(Location location, String unit) {
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
    future: WeatherApi.getForecast(location, unit),
  );
}

Widget forcastViewsDaily(Location location, String unit) {
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
    future: WeatherApi.getForecast(location, unit),
  );
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
                      child: (_weather.description.contains('rain'))
                          ? Text(
                              _weather.description,
                              style: const TextStyle(
                                  fontWeight: FontWeight.normal,
                                  fontSize: 16,
                                  color: Colors.red),
                            )
                          : Text(
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
