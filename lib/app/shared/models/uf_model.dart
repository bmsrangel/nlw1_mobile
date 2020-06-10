import 'dart:convert';

UfModel ufModelFromMap(String str) => UfModel.fromMap(json.decode(str));

String ufModelToMap(UfModel data) => json.encode(data.toMap());

class UfModel {
  UfModel({
    this.id,
    this.sigla,
    this.nome,
    this.regiao,
  });

  final int id;
  final String sigla;
  final String nome;
  final UfModel regiao;

  factory UfModel.fromMap(Map<String, dynamic> json) => UfModel(
        id: json["id"],
        sigla: json["sigla"],
        nome: json["nome"],
        regiao: json["regiao"] == null ? null : UfModel.fromMap(json["regiao"]),
      );

  Map<String, dynamic> toMap() => {
        "id": id,
        "sigla": sigla,
        "nome": nome,
        "regiao": regiao == null ? null : regiao.toMap(),
      };
}
