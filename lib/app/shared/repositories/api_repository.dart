import 'package:dio/dio.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/shared/models/item_model.dart';
import 'package:mobile/app/shared/models/point_model.dart';

import '../../utils/constants.dart' as consts;
import '../interfaces/api_interface.dart';

class ApiRepository extends Disposable implements IApiRepository {
  Dio _dio = Dio(BaseOptions(baseUrl: consts.baseUrl));

  @override
  Future<List<ItemModel>> getItems() async {
    try {
      Response response = await this._dio.get("/items");
      return (response.data as List).map((e) => ItemModel.fromMap(e)).toList();
    } on DioError catch (e) {
      throw e.message;
    }
  }

  @override
  Future<PointModel> getPointDetailsById(int id) async {
    try {
      Response response = await this._dio.get("/points/$id");
      PointModel point = PointModel.fromMap(response.data["point"]);
      point.items = (response.data["items"] as List)
          .map((e) => ItemModel.fromMap(e))
          .toList();
      return point;
    } on DioError catch (e) {
      throw e.message;
    }
  }

  @override
  Future<List<PointModel>> getPoints(
      String uf, String city, List<int> selectedItems) async {
    try {
      Response response = await this._dio.get("/points", queryParameters: {
        "city": city,
        "uf": uf,
        "items": selectedItems,
      });
      return (response.data as List).map((e) => PointModel.fromMap(e)).toList();
    } on DioError catch (e) {
      throw e.message;
    }
  }

  //dispose will be called automatically
  @override
  void dispose() {}
}
