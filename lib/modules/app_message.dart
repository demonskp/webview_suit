import 'dart:convert';

AppMessage appMessageFromJson(String str) =>
    AppMessage.fromJson(json.decode(str));

String appMessageToJson(AppMessage data) => json.encode(data.toJson());

class AppMessage {
  AppMessage({
    this.package,
    this.method,
    this.funid,
    this.data,
  });

  String? package;
  String? method;
  String? funid;
  String? data;

  factory AppMessage.fromJson(Map<String, dynamic> json) => AppMessage(
    package: json["package"],
    method: json["method"],
    funid: json["funid"],
    data: json["data"],
  );

  Map<String, dynamic> toJson() => {
    "package": package,
    "method": method,
    "funid": funid,
    "data": data,
  };

  @override
  String toString() {
    return toJson().toString();
  }
}
