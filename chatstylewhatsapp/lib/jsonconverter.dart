import 'dart:convert';

JsonData JsonDataFromJson(String str) => JsonData.fromJson(json.decode(str));

String JsonDataToJson(JsonData data) => json.encode(data.toJson());

class JsonData {
  List<Datum> data;

  JsonData({
    required this.data,
  });

  factory JsonData.fromJson(Map<String, dynamic> json) => JsonData(
    data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data.map((x) => x.toJson())),
  };
}

class Datum {
  String name;
  String dialCode;
  String code;

  Datum({
    required this.name,
    required this.dialCode,
    required this.code,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    name: json["name"],
    dialCode: json["dial_code"],
    code: json["code"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "dial_code": dialCode,
    "code": code,
  };
}
