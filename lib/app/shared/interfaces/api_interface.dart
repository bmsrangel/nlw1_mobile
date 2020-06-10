import '../models/item_model.dart';
import '../models/point_model.dart';

abstract class IApiRepository {
  Future<List<ItemModel>> getItems();
  Future<List<PointModel>> getPoints(
      String uf, String city, List<int> selectedItems);
  Future<PointModel> getPointDetailsById(int id);
}
