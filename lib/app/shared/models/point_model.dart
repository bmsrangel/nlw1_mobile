import 'item_model.dart';

class PointModel {
  final int id;
  final String imageUrl;
  final String name;
  final String email;
  final String whatsapp;
  final String city;
  final String uf;
  final double latitude;
  final double longitude;
  List<ItemModel> items;

  PointModel(
      {this.id,
      this.imageUrl,
      this.name,
      this.city,
      this.uf,
      this.email,
      this.whatsapp,
      this.items,
      this.latitude,
      this.longitude});

  factory PointModel.fromMap(Map json) => PointModel(
        id: json["id"],
        imageUrl: json["image_url"],
        name: json["name"],
        city: json["city"],
        uf: json["uf"],
        email: json["email"],
        whatsapp: json["whatsapp"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}
