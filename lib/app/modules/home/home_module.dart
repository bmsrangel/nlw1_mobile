import 'package:flutter_modular/flutter_modular.dart';

import '../../shared/repositories/ibge_repository.dart';
import 'home_bloc.dart';
import 'home_page.dart';

class HomeModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => HomeBloc(Modular.get<IbgeRepository>())),
      ];

  @override
  List<Router> get routers => [
        Router(Modular.initialRoute,
            child: (_, args) => HomePage(homeBloc: Modular.get<HomeBloc>())),
      ];

  static Inject get to => Inject<HomeModule>.of();
}
