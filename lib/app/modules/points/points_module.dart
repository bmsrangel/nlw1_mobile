import 'package:mobile/app/modules/points/points_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/modules/points/points_page.dart';
import 'package:mobile/app/shared/repositories/api_repository.dart';

class PointsModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind((i) => PointsBloc(
              uf: i.args.data["uf"],
              city: i.args.data["city"],
              repo: Modular.get<ApiRepository>(),
            )),
      ];

  @override
  List<Router> get routers => [
        Router(
          Modular.initialRoute,
          child: (_, args) => PointsPage(
            pointsBloc: Modular.get<PointsBloc>(),
          ),
        ),
      ];

  static Inject get to => Inject<PointsModule>.of();
}
