class Location{
  double latitude;
  double longitude;
  String time;
  String date;

  Location.fromJson(Map<String,dynamic> json):
  latitude = json['latitude'],
  longitude = json['longitude'],
  time = json['time'],
  date = json['date'];

  Map<String,dynamic> toJson() => {
    "latitude" : latitude,
    "longitude" : longitude,
    "time" : time,
    "date" : date
  };

  Location(this.latitude,this.longitude,this.time,this.date);
}