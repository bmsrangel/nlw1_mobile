import 'dart:convert';

CityModel cityModelFromMap(String str) => CityModel.fromMap(json.decode(str));

String cityModelToMap(CityModel data) => json.encode(data.toMap());

class CityModel {
  CityModel({
    this.id,
    this.nome,
  });

  final int id;
  final String nome;

  factory CityModel.fromMap(Map<String, dynamic> json) => CityModel(
        id: json["id"],
        nome: json["nome"],
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "nome": nome,
      };
}
