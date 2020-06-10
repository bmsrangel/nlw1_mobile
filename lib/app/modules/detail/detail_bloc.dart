import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:mobile/app/shared/interfaces/api_interface.dart';
import 'package:mobile/app/shared/models/point_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:url_launcher/url_launcher.dart';

class DetailBloc extends Disposable {
  final int id;
  final IApiRepository repo;

  PointModel point;
  BehaviorSubject<PointModel> _point$ = BehaviorSubject<PointModel>();
  Sink<PointModel> get inPoint => _point$.sink;
  Stream<PointModel> get outPoint => _point$.stream;

  DetailBloc({this.id, this.repo}) {
    this.getDetails();
  }

  void handleNavigateBack() {
    Modular.to.pop();
  }

  void handleComposeEmail(PointModel point) {
    launch("mailto:${point.email}?subject=Interesse na coleta de resíduos");
  }

  void handleWhatsapp(PointModel point) {
    FlutterOpenWhatsapp.sendSingleMessage(
        point.whatsapp, "Tenho interesse sobre coleta de resíduos!");
  }

  Future getDetails() async {
    try {
      this.point = await this.repo.getPointDetailsById(this.id);
      print(this.point);
      this.inPoint.add(this.point);
    } catch (e) {
      _point$.addError(e);
    }
  }

  //dispose will be called automatically by closing its streams
  @override
  void dispose() {
    _point$.close();
  }
}
