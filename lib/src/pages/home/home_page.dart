import "package:flutter/material.dart";
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

import '../../utils/home_page_styles.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ScrollController _scroll$ = ScrollController();
  final TextEditingController _uf$ = TextEditingController();
  final TextEditingController _city$ = TextEditingController();

  @override
  void initState() {
    _scroll$.addListener(() {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        _scroll$.animateTo(
          MediaQuery.of(context).viewInsets.bottom - 50,
          duration: Duration(milliseconds: 80),
          curve: Curves.easeInOut,
        );
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _scroll$.dispose();
    _city$.dispose();
    _uf$.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      body: Stack(
        children: <Widget>[
          Image.asset(
            "assets/home-background.png",
            width: 274,
            height: 368,
            fit: BoxFit.contain,
          ),
          SingleChildScrollView(
            controller: _scroll$,
            child: Container(
              padding: EdgeInsets.all(32),
              width: size.width,
              height: size.height,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset("assets/logo.png"),
                  Container(
                    margin: const EdgeInsets.only(top: 64.0),
                    constraints: BoxConstraints(
                      maxWidth: 260,
                    ),
                    child: Text(
                      "Seu marketplace de coleta de resíduos",
                      style: titleStyle,
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    constraints: BoxConstraints(
                      maxWidth: 260,
                    ),
                    child: Text(
                      "Ajudamos pessoas a encontrarem pontos de coleta de forma eficiente.",
                      style: descriptionStyle,
                    ),
                  ),
                  const SizedBox(height: 50.0),
                  Container(
                    height: 60,
                    child: TextField(
                      controller: _uf$,
                      autocorrect: false,
                      maxLength: 2,
                      textCapitalization: TextCapitalization.characters,
                      decoration: InputDecoration(
                        counter: SizedBox(),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xFFFFFFFF),
                        filled: true,
                        hintText: "Digite a UF",
                        hintStyle: inputTextStyle,
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 60,
                    child: TextField(
                      autocorrect: false,
                      controller: _city$,
                      textCapitalization: TextCapitalization.words,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                          borderSide: BorderSide.none,
                        ),
                        fillColor: Color(0xFFFFFFFF),
                        filled: true,
                        hintText: "Digite a Cidade",
                        hintStyle: inputTextStyle,
                      ),
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32.0),
        height: 75,
        alignment: Alignment.topCenter,
        color: Theme.of(context).backgroundColor,
        child: InkWell(
          onTap: () => Navigator.pushNamed(context, 'points', arguments: {
            "uf": _uf$.text,
            "city": _city$.text,
          }),
          child: Stack(
            alignment: Alignment.centerLeft,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                width: size.width,
                height: 60,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Color(0xFF34CB79),
                ),
                child: Text(
                  "Entrar",
                  style: buttonTextStyle,
                ),
              ),
              Container(
                width: 60,
                height: 60,
                padding: const EdgeInsets.only(top: 8.0, bottom: 10.0),
                decoration: BoxDecoration(
                  color: Color.fromARGB(25, 0, 0, 0),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    bottomLeft: Radius.circular(10),
                  ),
                ),
                child: Icon(
                  FeatherIcons.arrowRight,
                  size: 24,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
