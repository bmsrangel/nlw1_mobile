import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../interfaces/ibge_interface.dart';
import '../models/municipio_model.dart';
import '../models/uf_model.dart';

class IbgeRepository extends Disposable implements IIbgeRepository {
  Dio _dio = Dio(BaseOptions(
    baseUrl: "https://servicodados.ibge.gov.br/api/v1/localidades",
  ));
  @override
  Future<List<CityModel>> getCitiesByUf(String uf) async {
    try {
      Response response =
          await this._dio.get("/estados/$uf/municipios", queryParameters: {
        "orderBy": "nome",
      });
      return (response.data as List)
          .map((city) => CityModel.fromMap(city))
          .toList();
    } on DioError catch (e) {
      throw e.message;
    }
  }

  @override
  Future<List<UfModel>> getUfs() async {
    try {
      Response response = await this._dio.get("/estados", queryParameters: {
        "orderBy": "nome",
      });
      return (response.data as List).map((uf) => UfModel.fromMap(uf)).toList();
    } on DioError catch (e) {
      throw e.message;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
