import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';
import 'package:mobile/app/shared/interfaces/api_interface.dart';
import 'package:mobile/app/shared/models/municipio_model.dart';
import 'package:mobile/app/shared/models/point_model.dart';
import 'package:mobile/app/shared/models/uf_model.dart';
import 'package:rxdart/rxdart.dart';

import '../../shared/models/item_model.dart';

class PointsBloc extends Disposable {
  final MapController mapController = MapController();

  final UfModel uf;
  final CityModel city;
  final IApiRepository repo;
  PointsBloc({this.uf, this.city, this.repo}) {
    this.getItems();
    this.getUserLocation();
  }

  List<Marker> markers = [];
  List<ItemModel> items = [];
  List<PointModel> points;
  List<int> selectedItems = [];

  Location location = Location();
  LocationData locationData;
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  BehaviorSubject<List<ItemModel>> _items$ =
      BehaviorSubject<List<ItemModel>>.seeded([]);
  Sink<List<ItemModel>> get inItems => _items$.sink;
  Stream<List<ItemModel>> get outItems => _items$.stream;

  BehaviorSubject<List<PointModel>> _points$ =
      BehaviorSubject<List<PointModel>>();
  Sink<List<PointModel>> get inPoints => _points$.sink;
  Stream<List<PointModel>> get outPoints => _points$.stream;

  BehaviorSubject<List<int>> _selectedItems$ = BehaviorSubject<List<int>>();
  Sink<List<int>> get inSelectedItems => _selectedItems$.sink;
  Stream<List<int>> get outSelectedItems => _selectedItems$.stream;

  void handleNavigateBack() {
    Modular.to.pop();
  }

  void handleNavigateToDetail(int id) {
    Modular.to.pushNamed("/detail", arguments: {"point_id": id});
  }

  void handleSelectItem(int id) async {
    int alreadySelected = selectedItems.indexWhere((element) => element == id);
    List<int> filteredItems;
    if (alreadySelected >= 0) {
      filteredItems = selectedItems..removeWhere((element) => element == id);
      selectedItems = filteredItems;
    } else {
      selectedItems.add(id);
    }
    inSelectedItems.add(selectedItems);
    await getPoints();
  }

  Future<void> getUserLocation() async {
    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }
    LocationData temp = await location.getLocation();
    mapController.move(LatLng(temp.latitude, temp.longitude), 15);
  }

  Future<void> getItems() async {
    try {
      this.items = await this.repo.getItems();
      inItems.add(items);
    } catch (e) {
      _items$.addError(e);
    }
  }

  Future<void> getPoints() async {
    this.points =
        await repo.getPoints(this.uf.sigla, this.city.nome, selectedItems);
    inPoints.add(points);
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _items$.close();
    _points$.close();
    _selectedItems$.close();
  }
}
