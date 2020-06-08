import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_open_whatsapp/flutter_open_whatsapp.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/src/shared/widgets/green_button_widget.dart';
import 'package:mobile/src/utils/detail_page_styles.dart';
import 'package:dio/dio.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../repositories/api_repository.dart';

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
  final String city;
  final String uf;
  final String email;
  final String whatsapp;
  List<Item> items;

  Point({
    this.id,
    this.image,
    this.imageUrl,
    this.name,
    this.city,
    this.uf,
    this.email,
    this.whatsapp,
    this.items,
  });

  factory Point.fromJson(Map json) => Point(
        id: json["id"],
        image: json["image"],
        imageUrl: json["image_url"],
        name: json["name"],
        city: json["city"],
        uf: json["uf"],
        email: json["email"],
        whatsapp: json["whatsapp"],
      );
}

class DetailPage extends StatefulWidget {
  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final ApiRepository client = ApiRepository();
  int id;
  Point point;

  void handleNavigateBack() {
    Navigator.pop(context);
  }

  void handleComposeEmail(Point point) {
    launch("mailto:${point.email}?subject=Interesse na coleta de resíduos");
  }

  void handleWhatsapp(Point point) {
    FlutterOpenWhatsapp.sendSingleMessage(
        point.whatsapp, "Tenho interesse sobre coleta de resíduos!");
  }

  Future<Point> getDetails(int id) async {
    Response res = await client.api.get("/points/$id");
    Point temp = Point.fromJson(res.data["point"]);
    temp.items =
        (res.data["items"] as List).map((e) => Item.fromJson(e)).toList();
    setState(() {
      this.point = temp;
    });
    return temp;
  }

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;

    final Map arguments = ModalRoute.of(context).settings.arguments;
    this.id = arguments["point_id"];

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Container(
        width: size.width,
        height: size.height,
        color: Colors.transparent,
        padding: EdgeInsets.fromLTRB(32.0, statusBarHeight + 20, 32.0, 0),
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
            const SizedBox(height: 32.0),
            FutureBuilder<Point>(
              future: getDetails(this.id),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: size.width,
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(snapshot.data.imageUrl),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24.0),
                    Text(snapshot.data.name, style: pointNameStyle),
                    const SizedBox(height: 8.0),
                    Text(snapshot.data.items.map((e) => e.title).join(", "),
                        style: pointItemStyle),
                    const SizedBox(height: 32.0),
                    Text("Endereço", style: addressTitleStyle),
                    const SizedBox(height: 8.0),
                    Text("${snapshot.data.city} / ${snapshot.data.uf}",
                        style: addressContentStyle),
                  ],
                );
              },
            )
          ],
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 20.0),
        decoration: BoxDecoration(
          color: Theme.of(context).backgroundColor,
          border: Border(
            top: BorderSide(
              color: Color(0xFFBBBBBB),
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            GreenButtonWidget(
              width: size.width * .4,
              height: 50,
              onPressed: () => handleWhatsapp(this.point),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.whatsapp,
                    size: 20,
                    color: Color(0xFFFFFFFF),
                  ),
                  const SizedBox(width: 8.0),
                  Text("Whatsapp", style: buttonTextStyle),
                ],
              ),
            ),
            GreenButtonWidget(
              width: size.width * .4,
              height: 50,
              onPressed: () => this.handleComposeEmail(this.point),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(
                    FeatherIcons.mail,
                    size: 20,
                    color: Color(0xFFFFFFFF),
                  ),
                  const SizedBox(width: 8.0),
                  Text("E-mail", style: buttonTextStyle),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
