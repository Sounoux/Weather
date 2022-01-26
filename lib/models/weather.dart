class Weather {
  final double lat;
  final double long;
  final String country;
  final String city;
  final double temp;
  final double feelsLike;
  final double low;
  final double high;
  final String description;
  final double pressure;
  final double humidity;
  final double wind;
  final String icon;

  Weather(
      {required this.city,
      required this.country,
      required this.lat,
      required this.long,
      required this.temp,
      required this.feelsLike,
      required this.low,
      required this.high,
      required this.description,
      required this.pressure,
      required this.humidity,
      required this.wind,
      required this.icon});

  factory Weather.fromJson(Map<String, dynamic> json) {
    (json);
    return Weather(
      long: json['coord']['lon'].toDouble(),
      lat: json['coord']['lat'].toDouble(),
      country: json['sys']['country'],
      city: json['name'],
      temp: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      low: json['main']['temp_min'].toDouble(),
      high: json['main']['temp_max'].toDouble(),
      description: json['weather'][0]['description'],
      pressure: json['main']['pressure'].toDouble(),
      humidity: json['main']['humidity'].toDouble(),
      wind: json['wind']['speed'].toDouble(),
      icon: json['weather'][0]['icon'],
    );
  }
}
