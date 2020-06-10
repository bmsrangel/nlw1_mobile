import 'package:mobile/app/modules/detail/detail_bloc.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/modules/detail/detail_page.dart';
import 'package:mobile/app/shared/repositories/api_repository.dart';

class DetailModule extends ChildModule {
  @override
  List<Bind> get binds => [
        Bind(
          (i) => DetailBloc(
            id: i.args.data["point_id"],
            repo: Modular.get<ApiRepository>(),
          ),
        ),
      ];

  @override
  List<Router> get routers => [
        Router(
          Modular.initialRoute,
          child: (_, args) => DetailPage(
            detailBloc: Modular.get<DetailBloc>(),
          ),
        ),
      ];

  static Inject get to => Inject<DetailModule>.of();
}
