import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/bloc/events/data_event.dart';
import 'package:covid_19_nigeria/src/bloc/states/data_state.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  var _dataBloc = DataBloc();

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: PageStorageKey('Page 2'),
      duration: Duration(milliseconds: 500),
      color: _dataBloc.darkModeOn ? Colors.black : Colors.white,
      child: Scaffold(
        appBar: null,
        body: BlocBuilder<DataBloc, DataState>(
          bloc: BlocProvider.of<DataBloc>(context),
          builder: (context, state) {
            if(state.state == LoadingState.loading)
              return Center(
                child: CircularProgressIndicator(),
              );
            if(state.state == LoadingState.none)
              return SingleChildScrollView(
                child: Container(
                  margin: EdgeInsets.only(top: 20.0),
                  padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stacks(),
                      SizedBox(height: 20,),
                      TipsRow(),
                      SizedBox(height: 20,),
                      Stack(
                        children: <Widget>[
                          Container(
                            width: MediaQuery.of(context).size.width*0.95,
                            height: 160,
                          ),
                          Positioned(
                            top: 30,
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.95,
                              height: 130,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: tipsGreen,
                              ),
                            ),
                          ),
                          Positioned(
                            child: Container(
                              height: 160,
                              width: MediaQuery.of(context).size.width*0.45,
                              child: SvgPicture.asset(
                                Covid.Nurse
                              ),
                            ),
                          ),
                          Positioned(
                            top: 55,
                            left: MediaQuery.of(context).size.width*0.44,
                            child: Container(
                              width: MediaQuery.of(context).size.width*0.95 - MediaQuery.of(context).size.width*0.45,
                              child: Center(
                                child: Text(
                                  'Notice any Symtoms contact the NCDC on:\n 0800 9700 0010,\n+234 708 7110 839',
                                  style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18, color: Colors.white, fontWeight: FontWeight.w600, letterSpacing: 0.8), 
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20,),
                      Text(
                        'Related Videos',
                        style: Theme.of(context).textTheme.headline5,
                      ),
                      SizedBox(height: 5,),
                      Container(
                        height: 750,
                        child: state.controllers == null ? SizedBox() : ListView.separated(
                          physics: NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return ClipRRect(
                              borderRadius: BorderRadius.all(Radius.circular(8.0)),
                              child:YoutubePlayer(
                                key: ObjectKey(state.controllers[index]),
                                controller: state.controllers[index],
                                actionsPadding: EdgeInsets.only(left: 16.0),
                                bottomActions: [
                                  CurrentPosition(),
                                  SizedBox(width: 10.0),
                                  ProgressBar(isExpanded: true),
                                  SizedBox(width: 10.0),
                                  RemainingDuration(),
                                  FullScreenButton(),
                                ],
                              )
                            );
                          },
                          itemCount: state.controllers.length,
                          separatorBuilder: (context, _) => SizedBox(height: 10.0),
                        ),
                      )
                    ],
                  ),
                ),
              );
          }
        )
      ),
    );
  }
}

class Tips extends StatelessWidget {
  final String path;
  final String text;

  const Tips({Key key, this.path, this.text}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(50),
            color: paleGreen
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(20),
              height: MediaQuery.of(context).size.height*0.3,
              width: MediaQuery.of(context).size.width*0.2,
              child: Image.asset(
                path,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.high,
              ),),
          ),
        ),
        SizedBox(height: 10,),
        Container(
          width: 90,
          child: Center(
            child: Text(
              text,
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ],
    );
  }
}

class Stacks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width,
          height: 180,
        ),
        Positioned(
          top: 25,
          child: Container(
            width: MediaQuery.of(context).size.width*0.92,
            height: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              color: tipsGreen,
            ),
          ),
        ),
        Positioned(
          top: 68,
          left: 60,
          child: Text(
            'Health Tips',
            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 40,fontWeight: FontWeight.bold, color: Colors.white),
          ),
        ),
        Positioned(
          top: 25,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
        Positioned(
          top: 120,
          left: 8,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
        Positioned(
          left: MediaQuery.of(context).size.width*0.3,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
        Positioned(
          top: 115,
          left: MediaQuery.of(context).size.width*0.5,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
        Positioned(
          top: 25,
          left: MediaQuery.of(context).size.width*0.7,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
        Positioned(
          top: 74,
          left: MediaQuery.of(context).size.width*0.84,
          child: Container(
            width: 50,
            height: 50,
            child: SvgPicture.asset(
              Covid.Header
            ),
          ),
        ),
      ],
    ); 
  }
}

class TipsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Tips(
            path: Covid.Wash,
            text: Covid.washText,
          ),
          Tips(
            path: Covid.Mask,
            text: Covid.maskText,
          ),
          Tips(
            path: Covid.Social_distance,
            text: Covid.distanceText,
          )
        ],
      ),
    );
  }
}
