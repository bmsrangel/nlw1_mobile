import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:latlong/latlong.dart';
import 'package:location/location.dart';

import '../../repositories/api_repository.dart';
import '../../utils/points_page_styles.dart';

class Item {
  final int id;
  final String title;
  final String imageUrl;

  Item({this.id, this.title, this.imageUrl});

  factory Item.fromJson(Map json) =>
      Item(id: json["id"], title: json["title"], imageUrl: json["image_url"]);
}

class Point {
  final int id;
  final String image;
  final String imageUrl;
  final String name;
  final double latitude;
  final double longitude;

  Point({
    this.id,
    this.image,
    this.imageUrl,
    this.name,
    this.latitude,
    this.longitude,
  });

  factory Point.fromJson(Map json) => Point(
        id: json["id"],
        image: json["image"],
        imageUrl: json["image_url"],
        name: json["name"],
        latitude: json["latitude"],
        longitude: json["longitude"],
      );
}

class PointsPage extends StatefulWidget {
  @override
  _PointsPageState createState() => _PointsPageState();
}

class _PointsPageState extends State<PointsPage> {
  final ApiRepository client = ApiRepository();
  List<Point> points = [];
  List<Item> items = [];
  List<int> selectedItems = [];
  List<Marker> markers = [];
  String city;
  String uf;

  Location location = Location();
  LocationData locationData;
  MapController mapController = MapController();
  bool _serviceEnabled;
  PermissionStatus _permissionGranted;

  @override
  void initState() {
    getUserLocation();
    client.api.get("/items").then((value) {
      List<Item> temp =
          (value.data as List).map((e) => Item.fromJson(e)).toList();
      setState(() {
        items = [...temp];
      });
    });
    super.initState();
  }

  void handleNavigateBack() {
    Navigator.pop(context);
  }

  void handleNavigateToDetail(int id) {
    Navigator.pushNamed(context, 'detail', arguments: {"point_id": id});
  }

  void handleSelectItem(int id) {
    int alreadySelected = selectedItems.indexWhere((element) => element == id);
    List<int> filteredItems;
    if (alreadySelected >= 0) {
      filteredItems = selectedItems..removeWhere((element) => element == id);
      setState(() {
        selectedItems = filteredItems;
      });
    } else {
      setState(() {
        selectedItems.add(id);
      });
    }
    getPoints(this.uf, this.city);
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

  void getPoints(String uf, String city) {
    client.api.get("/points", queryParameters: {
      "city": city,
      "uf": uf,
      "items": selectedItems,
    }).then((value) {
      markers.clear();
      List<Point> temp =
          (value.data as List).map((e) => Point.fromJson(e)).toList();
      temp.forEach((element) {
        markers.add(
          Marker(
            width: 100.0,
            height: 80.0,
            point: LatLng(element.latitude, element.longitude),
            builder: (ctx) => InkWell(
              onTap: () => handleNavigateToDetail(element.id),
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
                      element.imageUrl,
                      width: 100.0,
                      height: 45,
                      fit: BoxFit.cover,
                    ),
                    Text(
                      element.name,
                      style: mapMarkerStyle,
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> arguments = ModalRoute.of(context).settings.arguments;
    this.uf = arguments["uf"];
    this.city = arguments["city"];
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;

    getPoints(this.uf, this.city);

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
              onPressed: handleNavigateBack,
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
              child: FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  center: LatLng(-21.7573971, -45.3109657),
                  zoom: 15.0,
                ),
                layers: [
                  TileLayerOptions(
                      urlTemplate:
                          "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c']),
                  MarkerLayerOptions(markers: this.markers),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomSheet: Container(
        color: Theme.of(context).backgroundColor,
        height: 168,
        padding: EdgeInsets.only(bottom: 32.0, top: 16.0),
        child: ListView.builder(
          itemCount: this.items.length,
          scrollDirection: Axis.horizontal,
          padding: EdgeInsets.symmetric(horizontal: 20.0),
          itemBuilder: (_, index) {
            return InkWell(
              onTap: () => handleSelectItem(this.items[index].id),
              child: Container(
                padding: const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                margin: const EdgeInsets.only(right: 8.0),
                height: 120,
                width: 120,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(
                    width: this.selectedItems.contains(this.items[index].id)
                        ? 2
                        : 0,
                    color: this.selectedItems.contains(this.items[index].id)
                        ? Color(0xFF34CB79)
                        : Colors.transparent,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    SvgPicture.network(
                      this.items[index].imageUrl,
                      width: 42,
                      height: 42,
                    ),
                    Text(this.items[index].title),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
