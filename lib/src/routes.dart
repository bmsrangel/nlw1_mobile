import 'package:flutter/widgets.dart';

import 'pages/detail/detail_page.dart';
import 'pages/home/home_page.dart';
import 'pages/points/points_page.dart';

final Map<String, WidgetBuilder> routes = {
  "home": (BuildContext context) => HomePage(),
  "points": (BuildContext context) => PointsPage(),
  "detail": (BuildContext context) => DetailPage(),
};
