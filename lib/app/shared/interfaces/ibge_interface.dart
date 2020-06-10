import '../models/municipio_model.dart';
import '../models/uf_model.dart';

abstract class IIbgeRepository {
  Future<List<UfModel>> getUfs();
  Future<List<CityModel>> getCitiesByUf(String uf);
}
