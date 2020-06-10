import 'package:flutter/widgets.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/shared/interfaces/ibge_interface.dart';
import 'package:mobile/app/shared/models/municipio_model.dart';
import 'package:mobile/app/shared/models/uf_model.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc extends Disposable {
  final ScrollController scroll$ = ScrollController();
  final IIbgeRepository _repo;

  HomeBloc(this._repo) {
    getUfs();
  }

  UfModel selectedUf;
  CityModel selectedCity;

  BehaviorSubject<List<UfModel>> _ufs$ = BehaviorSubject();
  Sink<List<UfModel>> get inUfs => _ufs$.sink;
  Stream<List<UfModel>> get outUfs => _ufs$.stream;

  BehaviorSubject<UfModel> _selectedUf$ = BehaviorSubject();
  Sink<UfModel> get inSelectedUf => _selectedUf$.sink;
  Stream<UfModel> get outSelectedUf => _selectedUf$.stream;

  BehaviorSubject<List<CityModel>> _cities$ = BehaviorSubject();
  Sink<List<CityModel>> get inCities => _cities$.sink;
  Stream<List<CityModel>> get outCities => _cities$.stream;

  BehaviorSubject<CityModel> _selectedCity$ = BehaviorSubject();
  Sink<CityModel> get inSelectedCity => _selectedCity$.sink;
  Stream<CityModel> get outSelectedCity => _selectedCity$.stream;

  Future<void> getUfs() async {
    try {
      List<UfModel> ufs = await _repo.getUfs();
      inUfs.add(ufs);
    } catch (e) {
      _ufs$.addError(e);
    }
  }

  Future<void> getCities(String uf) async {
    try {
      List<CityModel> cities = await _repo.getCitiesByUf(uf.toUpperCase());
      inCities.add(cities);
    } catch (e) {
      _cities$.addError(e);
    }
  }

  void handleEntrarButton() {
    this.selectedUf = _selectedUf$.value;
    this.selectedCity = _selectedCity$.value;
    Modular.to.pushNamed('/points', arguments: {
      "uf": selectedUf,
      "city": selectedCity,
    });
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _ufs$.close();
    _cities$.close();
    _selectedUf$.close();
    _selectedCity$.close();
  }
}
