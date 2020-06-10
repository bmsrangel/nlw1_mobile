import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobile/app/modules/detail/detail_bloc.dart';
import 'package:mobile/app/modules/detail/detail_page_styles.dart';
import 'package:mobile/app/shared/models/point_model.dart';
import 'package:mobile/app/shared/widgets/green_button_widget.dart';

class DetailPage extends StatefulWidget {
  final String title;
  final DetailBloc detailBloc;
  const DetailPage({Key key, this.title = "Detail", this.detailBloc})
      : super(key: key);

  @override
  _DetailPageState createState() => _DetailPageState(bloc: detailBloc);
}

class _DetailPageState extends State<DetailPage> {
  final DetailBloc bloc;

  _DetailPageState({this.bloc});

  @override
  Widget build(BuildContext context) {
    double statusBarHeight = MediaQuery.of(context).viewPadding.top;
    Size size = MediaQuery.of(context).size;

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
              onPressed: bloc.handleNavigateBack,
              // onPressed: bloc.handleNavigateBack,
            ),
            const SizedBox(height: 32.0),
            StreamBuilder<PointModel>(
              stream: bloc.outPoint,
              builder: (_, snapshot) {
                if (!snapshot.hasData)
                  return Center(
                    child: CircularProgressIndicator(),
                  );
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
                          image: CachedNetworkImageProvider(
                              snapshot.data.imageUrl),
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
              onPressed: () => this.bloc.handleWhatsapp(this.bloc.point),
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
              onPressed: () => this.bloc.handleComposeEmail(this.bloc.point),
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
