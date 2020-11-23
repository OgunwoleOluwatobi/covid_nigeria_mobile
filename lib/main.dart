import 'dart:async';

import 'package:covid_19_nigeria/src/bloc/states/data_state.dart';
import 'package:covid_19_nigeria/src/pages/news_page.dart';
import 'package:covid_19_nigeria/src/pages/tips_page.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/pages/data_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

import 'home.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitDown, DeviceOrientation.portraitUp]);

  Covid.prefs = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DataBloc dataBloc;

  @override
  void initState() { 
    super.initState();
    setupApp();
  }

  setupApp() {
    dataBloc = DataBloc();
    dataBloc.darkModeOn = Covid.prefs.getBool(Covid.darkModePref) ?? false;
    dataBloc.initialized = Covid.prefs.getBool(Covid.initialized) ?? false;
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => dataBloc,
      child: BlocBuilder<DataBloc, DataState>(
        builder: (context, state){
          return MaterialApp(
            title: 'Covid Nigeria',
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              //* Custom Google Font
              fontFamily: Covid.google_sans_family,
              primarySwatch: Colors.red,
              primaryColor: dataBloc.darkModeOn ? Colors.black : Colors.white,
              disabledColor: Colors.grey,
              cardColor: dataBloc.darkModeOn ? darkCard : Colors.white,
              canvasColor: dataBloc.darkModeOn ? Colors.grey[900] : Colors.grey[50],
              brightness: dataBloc.darkModeOn ? Brightness.dark : Brightness.light,
              buttonTheme: Theme.of(context).buttonTheme.copyWith(
                colorScheme: dataBloc.darkModeOn ? ColorScheme.dark() : ColorScheme.light(),
              ),
              bottomAppBarColor: dataBloc.darkModeOn ? darkCard : Colors.white,
              scaffoldBackgroundColor: dataBloc.darkModeOn ? Colors.black : Colors.white,
              appBarTheme: AppBarTheme(
                elevation: 0.0
              ),
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            home: Splash(),//Home(dataBloc: dataBloc,),
          );
        }
      )
    );
  }
}

class Splash extends StatefulWidget {
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  var bloc = DataBloc();

  @override
  void initState() { 
    super.initState();
    Timer(
      Duration(seconds: 3), 
      () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Home(dataBloc: bloc,))),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: paleGreen,
      child: Center(
        child: Stack(
          children: <Widget>[
            SvgPicture.asset(
              Covid.Splash,
              color: Colors.white,
            ),
            Positioned(
              top: 163,
              left: 130,
              child: Text(
                'Nigeria',
                style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 38, fontWeight: FontWeight.w900, color: Colors.white)
              ),
            ),
          ],
        ),
      ),
    );
  }
}