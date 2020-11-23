import 'package:covid_19_nigeria/src/models/state_name.dart';
import 'package:covid_19_nigeria/src/pages/widgets/action_card.dart';
import 'package:covid_19_nigeria/src/pages/widgets/state_card.dart';
import 'package:covid_19_nigeria/src/pages/widgets/total_chart.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/bloc/states/data_state.dart';
import 'package:covid_19_nigeria/src/bloc/events/data_event.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class DataPage extends StatefulWidget {
  const DataPage({Key key}) : super(key: key);
  @override
  _DataPageState createState() => _DataPageState();
}

class _DataPageState extends State<DataPage> {
  var _dataBloc = DataBloc();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  String tot;
  List<StateName> _statename = StateName.getState();
  List<DropdownMenuItem<StateName>> _dropdownMenuItems;
  StateName _selectedstatename;
  String sname;
  List states;
  List day;

  @override
  void initState() {
    super.initState();
    print('Here!!');
    _dropdownMenuItems = buildDropdownMenuItems(_statename);
    _selectedstatename = _dropdownMenuItems[_dataBloc.id].value;
    sname = _dataBloc.stateName;
    print(_dropdownMenuItems[_dataBloc.id].value);
    _init();
    Future.delayed(Duration.zero, () {
      FetchData(_dataBloc);
      states = _dataBloc.state.states;
      day = _dataBloc.state.day;
    });
    _firebaseMessaging.configure(
      onMessage: (Map<String, dynamic> message) async {
          print("onMessage: $message");
      },
      onLaunch: (Map<String, dynamic> message) async {
          print("onLaunch: $message");
          // TODO optional
      },
      onResume: (Map<String, dynamic> message) async {
          print("onResume: $message");
          // TODO optional
      },
    );      
  }

  _init() async {
    if (!_dataBloc.initialized) {
      // For iOS request permission first.
      _firebaseMessaging.requestNotificationPermissions(); 

      // For testing purposes print the Firebase Messaging token
      String token = await _firebaseMessaging.getToken();
      Future.delayed(Duration.zero, () {
        _dataBloc.add(AddToken(token, _dataBloc));
      });
      print("FirebaseMessaging token: $token");
    }
  }

  List<DropdownMenuItem<StateName>> buildDropdownMenuItems(List statename) {
    List <DropdownMenuItem<StateName>> items = List();
    for (StateName statename in statename) {
      print(statename);
      items.add(
        DropdownMenuItem(
          value: statename,
          child: Text(statename.name,)
        ),
      );
    }
    return items;
  }

  onChangedDropdownItem(StateName selectedstatename) {
    states = _dataBloc.state.states;
    day = _dataBloc.state.day;
    setState(() {
      sname = selectedstatename.staten;
      print(sname);
      _selectedstatename = selectedstatename;
      sname == 'Overall' ? _dataBloc.add(SetOverall(sname,selectedstatename, _dataBloc)) : _dataBloc.add(ViewState(sname, states, day, selectedstatename, _dataBloc));
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      key: PageStorageKey('Page 1'),
      duration: Duration(milliseconds: 500),
      color: _dataBloc.darkModeOn ? Colors.black : Colors.white,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(65.0),
          child: AppBar(
            elevation: 0,
            title: Container(
              margin: EdgeInsets.all(15.0),
              width: 210,
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50,
                    width: 60,
                    child: SvgPicture.asset(
                      Covid.Header,
                      semanticsLabel: 'Acme Logo'
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 61),
                    width: 140,
                    height: 105,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Covid-19',
                          style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 28, fontWeight: FontWeight.bold, color: paleGreen),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10.0),
                          child: Text(
                            'Nigeria',
                            style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20, fontWeight: FontWeight.bold, color: paleGreen),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
            centerTitle: false,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  _dataBloc.darkModeOn ? FontAwesomeIcons.lightbulb : FontAwesomeIcons.solidLightbulb,
                  size: 18,
                ),
                onPressed: () {
                  _dataBloc
                    .add(DarkMode(!DataBloc().darkModeOn, _dataBloc));
                },
              ),
            ]
          ),
        ),
        body: BlocBuilder<DataBloc, DataState>(
          bloc: BlocProvider.of<DataBloc>(context),
          builder: (context, state) {
            if(state.state == LoadingState.loading)
              return Center(
                child: CircularProgressIndicator(),
              );
            else if(state.state == LoadingState.none)
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 10.0),
                    child: Column(
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(left: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                sname == 'Overall' ? '' : sname.toString()+' State',
                                style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.bold, fontSize: 35),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(bottom: 3, left: 5),
                                child: DropdownButton(
                                  underline: SizedBox(),
                                  value: _selectedstatename,
                                  items: _dropdownMenuItems,
                                  onChanged: onChangedDropdownItem,
                                  style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18, fontWeight: FontWeight.w500),
                                )
                              ),
                            ],
                          ),
                        ),
                        sname == 'Overall' ? overallDash(context, state, _dataBloc) : 
                        state.stateChart.length > 0 ? stateDash(context, state) : 
                        Container(
                          height: MediaQuery.of(context).size.height-250,
                          child: Center(
                            child: Text(
                              'No Cases Recorded Yet',
                              style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18)
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            else
              return Center(child: Text('There Was an Error'),);
          },
        ),
      ),
    );
  }
  Future<Null> _refresh() async {
    Future.delayed(Duration.zero, () {
      FetchData(_dataBloc);
      states = _dataBloc.state.states;
      day = _dataBloc.state.day;
    });
  }
}

Widget tableBody(int index, String stname, String acases, String rcases, String dcases, context, DataBloc bloc) {
  return Container(
    child: Card(
      elevation: 0,
      //color: bloc.darkModeOn ? darkCard : Colors.grey.shade100,
      margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
      child: Padding(
        padding: const EdgeInsets.only(left:10.0, top: 3.0, bottom: 10.0),
        child: Row(
          //mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(width: 20, child: Text(index.toString(), style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 14),)),
            SizedBox(width: 20,),
            Container(width: 120, child: Text(stname+' State', style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18),)),
            SizedBox(width: 25,),
            Container( width: 25.toDouble(), child: Text(acases, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center,)),
            SizedBox(width: 60,),
            Container(width: 20.toDouble(), child: Text(rcases, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16, fontWeight: FontWeight.w500), textAlign: TextAlign.center)),
            SizedBox(width: 60,),
            Container(width: 20.toDouble(), child: Text(dcases, style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16, fontWeight: FontWeight.w500),  textAlign: TextAlign.center)),
          ],
        ),
      ),
    ),
  );
}

Widget overallDash(context, DataState state, DataBloc bloc) => Column(
  //mainAxisAlignment: MainAxisAlignment.spaceAround,
  crossAxisAlignment: CrossAxisAlignment.center,
  children: <Widget>[
    TotalChart(data: state.chartData.reversed.toList()),
    SizedBox(height: 20,),
    newActions(context, state.total[0][0].overallConfirmedCases, state.total[0][0].overallActiveCases, state.total[0][0].overallNewConfirmedCases, state.total[0][0].overallDischargedCases, state.total[0][0].overallNewDischargedCases, state.total[0][0].overallDeaths, state.total[0][0].overallNewDeaths, bloc),
    SizedBox(height: 35,),
    Text(
      'Daily report as of '+state.ddate,
      style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 0.7),
    ),
    SizedBox(height: 12,),
    ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(10.0)),
      child:Column(
        children: <Widget>[
          Card(
            elevation: 0,
            //color: bloc.darkModeOn ? darkCard : Colors.grey.shade100,
            margin: EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10.0, 13.0, 13.0, 12.0),
              child: Row(
                //mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  // Text(
                  //   "No",
                  //   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0, color: Theme.of(context).scaffoldBackgroundColor == Color(0xffF3F3F3) ? Colors.black : Colors.white),
                  // ),
                  SizedBox(width: 38),
                  Text("State", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 18.0,),),
                  SizedBox(width: 80),
                  Text("New Cases", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17.0,),),
                  SizedBox(width: 15),
                  Text("Recovered", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17.0,),),
                  SizedBox(width: 15),
                  Text("Deaths", style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17.0),),
                ],
              ),
            ),
          ),
          Container(
            height: (state.states[0].length*32.4).toDouble(),
            child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              itemCount: state.states[0].length,
              itemBuilder: (context, index){
                return tableBody(index+1, state.states[0][index].state, state.states[0][index].totalNewConfirmedCases, state.states[0][index].totalNewDischargedCases, state.states[0][index].totalNewDeaths, context, bloc);
              },
            ),
          ),
        ],
      ),
    ),
  ],
);
Widget stateDash(context, DataState state) => Column(
  children: <Widget>[
    TotalChart(data: state.stateChart.reversed.toList()),
    SizedBox(height: 20,),
    stateActions(context, state.stateTotalCases, state.stateActiveCases[0], state.stateActiveCases[1], state.stateRecovered[0], state.stateRecovered[1], state.stateDeaths[0], state.stateDeaths[1]),
  ],
);

Widget stateActions(context, String overallConfirmedCases, String overallActiveCases, String overallActiveNewCases, String overallRecoveredCases, String overallNewRecoveredCases, String overallDeathCases, String overallNewDeathCases) => Column(
    children: <Widget>[
      StateCard(
        path: Covid.Cases_img,
        title: Covid.total,
        amount: overallConfirmedCases,
        newCases: '',
        color: purple,
      ),
      SizedBox(height: 10,),
      StateCard(
        path: Covid.Cases_img,
        title: Covid.active,
        amount: overallActiveCases,
        newCases: overallActiveNewCases,
        color: purple,
      ),
      SizedBox(height: 10,),
      StateCard(
        path: Covid.Recovered_img,
        title: Covid.recovered,
        amount: overallRecoveredCases,
        newCases: overallNewRecoveredCases,
        color: paleGreen,
      ),
      SizedBox(height: 10,),
      StateCard(
        path: Covid.Death_img,
        title: Covid.death,
        amount: overallDeathCases,
        newCases: overallNewDeathCases,
        color: red,
      ),
    ],
  );

Widget newActions(context, String overallConfirmedCases, String overallActiveCases, String overallNewActiveCases, String overallRecoveredCases, String overallNewRecoveredCases, String overallDeathCases,  String overallNewDeathCases, DataBloc bloc) => Wrap(
    alignment: WrapAlignment.center,
    spacing: 10.0,
    runSpacing: 10.0,
    children: <Widget>[
      ActionCard(
        path: Covid.Cases_img,
        title: Covid.total,
        amount: overallConfirmedCases,
        color: purple,
        bloc: bloc,
      ),
      ActionCard(
        path: Covid.Cases_img,
        title: Covid.active,
        amount: overallActiveCases,
        newc: overallNewActiveCases,
        color: purple,
        bloc: bloc,
      ),
      ActionCard(
        path: Covid.Recovered_img,
        title: Covid.recovered,
        amount: overallRecoveredCases,
        newc: overallNewRecoveredCases,
        color: paleGreen,
        bloc: bloc,
      ),
      ActionCard(
        path: Covid.Death_img,
        title: Covid.death,
        amount: overallDeathCases,
        newc: overallNewDeathCases,
        color: red,
        bloc: bloc,
      ),
    ],
  );
