import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/app_module.dart';
import 'package:mobile/app/modules/points/points_bloc.dart';
import 'package:mobile/app/modules/points/points_module.dart';

void main() {
  Modular.init(AppModule());
  Modular.bindModule(PointsModule());
  PointsBloc bloc;

  // setUp(() {
  //     bloc = PointsModule.to.get<PointsBloc>();
  // });

  // group('PointsBloc Test', () {
  //   test("First Test", () {
  //     expect(bloc, isInstanceOf<PointsBloc>());
  //   });
  // });
}
