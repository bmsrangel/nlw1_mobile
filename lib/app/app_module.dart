import 'package:mobile/app/shared/repositories/ibge_repository.dart';
import 'package:mobile/app/shared/repositories/api_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'app_bloc.dart';
import 'app_widget.dart';
import 'modules/detail/detail_module.dart';
import 'modules/home/home_module.dart';
import 'modules/points/points_module.dart';

class AppModule extends MainModule {
  @override
  List<Bind> get binds => [
        Bind((i) => IbgeRepository()),
        Bind((i) => ApiRepository()),
        Bind((i) => AppBloc()),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute, module: HomeModule()),
        Router("/points", module: PointsModule()),
        Router("/detail", module: DetailModule())
      ];

  @override
  Widget get bootstrap => AppWidget();

  static Inject get to => Inject<AppModule>.of();
}
