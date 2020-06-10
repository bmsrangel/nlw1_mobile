import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobile/app/shared/models/municipio_model.dart';
import 'package:mobile/app/shared/models/uf_model.dart';

import 'home_bloc.dart';
import 'home_page_styles.dart';

class HomePage extends StatefulWidget {
  final String title;
  final HomeBloc homeBloc;
  const HomePage({Key key, this.title = "Home", this.homeBloc})
      : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(bloc: this.homeBloc);
}

class _HomePageState extends State<HomePage> {
  final HomeBloc bloc;

  _HomePageState({this.bloc});

  @override
  void initState() {
    bloc.scroll$.addListener(() {
      if (MediaQuery.of(context).viewInsets.bottom > 0) {
        bloc.scroll$.animateTo(
          MediaQuery.of(context).viewInsets.bottom - 50,
          duration: Duration(milliseconds: 80),
          curve: Curves.easeInOut,
        );
      }
    });
    super.initState();
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
            controller: bloc.scroll$,
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
                    child: StreamBuilder<List<UfModel>>(
                      stream: bloc.outUfs,
                      initialData: [],
                      builder: (_, snapshot) {
                        return StreamBuilder(
                          stream: bloc.outSelectedUf,
                          initialData: null,
                          builder: (_, snapshot2) {
                            return DropdownButton<UfModel>(
                              isExpanded: true,
                              hint: Text("Selecione a UF"),
                              value: snapshot2.data,
                              onChanged: (value) async {
                                bloc.inSelectedUf.add(value);
                                await bloc.getCities(value.sigla);
                              },
                              items: snapshot.data
                                  .map<DropdownMenuItem<UfModel>>(
                                      (e) => DropdownMenuItem(
                                            child: Text(e.sigla),
                                            value: e,
                                          ))
                                  .toList(),
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Container(
                    height: 60,
                    child: StreamBuilder<List<CityModel>>(
                      stream: bloc.outCities,
                      initialData: [],
                      builder: (_, snapshot) {
                        return StreamBuilder(
                          stream: bloc.outSelectedCity,
                          initialData: null,
                          builder: (_, snapshot2) {
                            return DropdownButton(
                              isExpanded: true,
                              hint: Text("Selecione a cidade"),
                              onChanged: (value) {
                                bloc.inSelectedCity.add(value);
                              },
                              value: snapshot2.data,
                              items: snapshot.data
                                  .map<DropdownMenuItem>(
                                      (e) => DropdownMenuItem(
                                            child: Text(e.nome),
                                            value: e,
                                          ))
                                  .toList(),
                            );
                          },
                        );
                      },
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
          onTap: bloc.handleEntrarButton,
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
