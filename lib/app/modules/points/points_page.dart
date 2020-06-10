import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong/latlong.dart';
import 'package:mobile/app/shared/models/item_model.dart';
import 'package:mobile/app/shared/models/point_model.dart';

import 'points_bloc.dart';
import 'points_page_styles.dart';

class PointsPage extends StatefulWidget {
  final String title;

  final PointsBloc pointsBloc;

  const PointsPage({Key key, this.title = "Points", this.pointsBloc})
      : super(key: key);

  @override
  _PointsPageState createState() => _PointsPageState(bloc: this.pointsBloc);
}

class _PointsPageState extends State<PointsPage> {
  final String uf;
  final String city;
  final PointsBloc bloc;

  _PointsPageState({this.uf, this.city, this.bloc});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        padding: EdgeInsets.fromLTRB(32.0, statusBarHeight + 20, 32.0, 0),
        width: size.width,
        height: size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              icon: Icon(
                FeatherIcons.arrowLeft,
                size: 20,
                color: Color(0xFF34CB79),
              ),
              onPressed: this.bloc.handleNavigateBack,
            ),
            const SizedBox(height: 24.0),
            Text(
              "Bem vindo.",
              style: titleStyle,
            ),
            const SizedBox(height: 4.0),
            Text(
              "Encontre no mapa um ponto de coleta.",
              style: descriptionStyle,
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: StreamBuilder<List<PointModel>>(
                  stream: bloc.outPoints,
                  initialData: [],
                  builder: (context, snapshot) {
                    return FlutterMap(
                      mapController: this.bloc.mapController,
                      options: MapOptions(
                        center: LatLng(-21.7573971, -45.3109657),
                        zoom: 15.0,
                      ),
                      layers: [
                        TileLayerOptions(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c']),
                        MarkerLayerOptions(
                            markers: this.buildMarkers(snapshot.data)),
                      ],
                    );
                  }),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).backgroundColor,
        height: 168,
        padding: EdgeInsets.only(bottom: 32.0, top: 16.0),
        child: StreamBuilder<List<ItemModel>>(
            stream: bloc.outItems,
            initialData: [],
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(child: CircularProgressIndicator());
              return ListView.builder(
                itemCount: snapshot.data.length,
                scrollDirection: Axis.horizontal,
                padding: EdgeInsets.symmetric(horizontal: 20.0),
                itemBuilder: (_, index) {
                  return InkWell(
                    onTap: () =>
                        this.bloc.handleSelectItem(snapshot.data[index].id),
                    child: StreamBuilder<List<int>>(
                        stream: bloc.outSelectedItems,
                        initialData: [],
                        builder: (context, snapshot2) {
                          return Container(
                            padding: const EdgeInsets.fromLTRB(
                                16.0, 20.0, 16.0, 16.0),
                            margin: const EdgeInsets.only(right: 8.0),
                            height: 120,
                            width: 120,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                width: snapshot2.data
                                        .contains(snapshot.data[index].id)
                                    ? 2
                                    : 0,
                                color: snapshot2.data
                                        .contains(snapshot.data[index].id)
                                    ? Color(0xFF34CB79)
                                    : Colors.transparent,
                              ),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                SvgPicture.network(
                                  snapshot.data[index].imageUrl,
                                  width: 42,
                                  height: 42,
                                ),
                                Text(snapshot.data[index].title),
                              ],
                            ),
                          );
                        }),
                  );
                },
              );
            }),
      ),
    );
  }

  List<Marker> buildMarkers(List<PointModel> points) {
    return points
        .map(
          (point) => Marker(
            width: 100.0,
            height: 80.0,
            point: LatLng(point.latitude, point.longitude),
            builder: (ctx) => InkWell(
              onTap: () => bloc.handleNavigateToDetail(point.id),
              child: Container(
                width: 100.0,
                height: 70.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  color: Color(0xFF34CB79),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.network(
                      point.imageUrl,
                      width: 100.0,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      point.name,
                      style: mapMarkerStyle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ),
        )
        .toList();
  }
}
