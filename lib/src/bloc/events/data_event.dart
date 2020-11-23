import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/models/chart_data.dart';
import 'package:covid_19_nigeria/src/models/state_name.dart';
import 'package:covid_19_nigeria/src/models/states_data.dart';
import 'package:covid_19_nigeria/src/models/total_data.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:intl/intl.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

abstract class DataEvent{}

class FetchData extends DataEvent {
  List states = [];
  List day = [];
  List daytot = [];
  List total = [];
  List totalCases = [];
  List<ChartData> _chartData = [];
  FetchData(DataBloc bloc) {
    List<StatesData> hold;
    List<TotalData> holdtot;
    fetch(bloc, hold, holdtot);
  }

  void fetch(DataBloc bloc, List<StatesData> hold, List<TotalData> holdtot) async{
    ChartData data;
    print('here!!!');
    List dates = [];

    DateTime now = DateTime.now();
    String datenow = DateFormat('ddMMyy').format(now);
    print(datenow);
    final db = Firestore.instance;
    Future <List <DocumentSnapshot>> list() async {
     var data = await db.collection('covid').orderBy('id', descending: true).limit(7).getDocuments();
     var tokent = data.documents;
     return tokent;
   }
    Future <List <DocumentSnapshot>> tot() async {
     var data = await db.collection('total').orderBy('id', descending: true).limit(7).getDocuments();
     var tokent = data.documents;
     return tokent;
   }
   list().then((data) async {
     data.forEach((val){
       print(val.documentID);
       dates.add(val.documentID);
       final ddt = List.from(val['data']).map((json) => StatesData.fromJson(json)).toList();
       final dday = val['day'];
       hold = ddt;
       states.add(hold);
       day.add(dday);
     });
   }).then((value) async{
   tot().then((data) async {
     data.forEach((val){
       print(val.documentID);
       final ddt = List.from(val['data']).map((json) => TotalData.fromJson(json)).toList();
       final dday = val['day'];
       holdtot = ddt;
       print(val['data'][0]['overallActiveCases']);
       totalCases.add(val['data'][0]['overallActiveCases'].toString());
       total.add(holdtot);
       daytot.add(dday);
     });
     print('Enter Chart');
     print(totalCases);
      
   }).then((value) async{
        print(totalCases);
        for (var i = 0; i < totalCases.length; i++) {
          print('Chart!!!');
          data = i == 0 ? new ChartData(day: daytot[i], amount: int.parse(totalCases[i]), barColor: charts.ColorUtil.fromDartColor(paleGreen), numb : totalCases.length-(i+1)) : new ChartData(day: daytot[i], amount: int.parse(totalCases[i]), barColor: charts.ColorUtil.fromDartColor(paleGreen.withOpacity(0.5)), numb: totalCases.length-(i+1));
            print(data);
          _chartData.add(data);
        }
        var datte = dates[0].toString().split('');
        print(datte);
        var inputFormat = DateFormat("dd/MM/yy");
        var date1 = inputFormat.parse(datte[0].toString()+''+datte[1].toString()+'/'+datte[2].toString()+''+datte[3].toString()+'/'+datte[4].toString()+''+datte[5].toString());
        var outputFormat = DateFormat("EEE MMM d, yy");
        String doc_name = outputFormat.format(date1).toString();
        // int dt = (int.parse(datenow) - int.parse(dates[0]))~/10000;
        // print((int.parse(datenow) - int.parse(dates[0])));
        // print('The subtraction is: '+dt.toString());
        // DateTime noww = DateTime.now().subtract(Duration(days: dt));
        // String doc_name = DateFormat('dd-MM-yyyy').format(noww);
        bloc.add(FetchDataSuccess(states, day, total, daytot, totalCases, _chartData, doc_name));
      });});
   
  }
}

class FetchDataLoading extends DataEvent {}

class FetchDataSuccess extends DataEvent {
  String ddate;
  List states = [];
  List day = [];
  List daytot = [];
  List total = [];
  List totalCases = [];
  List<ChartData> chartData;

  FetchDataSuccess(this.states, this.day, this.total, this.daytot, this.totalCases, this.chartData, this.ddate);
}

class FetchDataFailed extends DataEvent {}

class DarkMode extends DataEvent {
  final bool darkOn;

  DarkMode(this.darkOn, DataBloc bloc){
    try {
      bloc.darkModeOn = darkOn;
      Covid.prefs.setBool(Covid.darkModePref, darkOn);
    } catch (_,stackTrace) {
      print('$_ $stackTrace');
    }
  }

  @override
  String toString() => 'DarkMode';
}

class ViewState extends DataEvent{
  String state;
  String totalCases;
  List states;
  List day;
  List activeCases = [];
  List recovered = [];
  List deaths = [];
  StateName selectedstate;
  List<ChartData> stateChart = [];
  ChartData data;

  @override
  String toString() => 'ViewState';

  ViewState(this.state, this.states, this.day, this.selectedstate, DataBloc bloc){
    for (var i = 0; i < states.length; i++) {
      for (var j = 0; j < states[i].length; j++) {
        if(states[i][j].state == state) {
          if(i == 0) {
            totalCases = states[i][j].totalConfirmedCases;
            activeCases.add(states[i][j].totalActiveCases);
            activeCases.add(states[i][j].totalNewConfirmedCases);
            recovered.add(states[i][j].totalDischargedCases);
            recovered.add(states[i][j].totalNewDischargedCases);
            deaths.add(states[i][j].totalDeaths);
            deaths.add(states[i][j].totalNewDeaths);
          }

          data = i == 0 ? new ChartData(day: day[i], amount: int.parse(states[i][j].totalActiveCases), barColor: charts.ColorUtil.fromDartColor(paleGreen), numb : states.length - (i+1)) : new ChartData(day: day[i], amount: int.parse(states[i][j].totalActiveCases), barColor: charts.ColorUtil.fromDartColor(paleGreen.withOpacity(0.5)), numb: states.length - (i+1));
            print(data);
          stateChart.add(data);
        }
      }
    }
    bloc.selectedState = selectedstate;
    bloc.stateName = state;
    bloc.id = selectedstate.id;
  }
}

class SetOverall extends DataEvent {
  StateName selectedstate;
  String state;

  SetOverall(this.state, this.selectedstate, DataBloc bloc){
    bloc.id = selectedstate.id;
    bloc.stateName = state;
    print(selectedstate.id);
  }

}

class FetchNews extends DataEvent{
  List newsData = [];
  List<String> imgurl = [];
  List headline = [];
  List postUrl = [];

  FetchNews(DataBloc bloc){
    fetch(bloc);
  }

  void fetch(DataBloc bloc){
    final db = Firestore.instance;
    DocumentSnapshot lit;
    bloc.state.newsData.clear();
    Future <List <DocumentSnapshot>> list() async {
      var data  = await db.collection('news').orderBy('id').limit(12).getDocuments();
      var docs = data.documents;
      bloc.nomore = false;
      lit = docs.last;
      return docs;
    }
    list().then((value) async {
      value.forEach((val) {
        final newsvalue = (val['content']);
        print(val['content']);
        //newsd = newsvalue;
        //print(newsd);
        newsData.add(newsvalue);
      });
    }).then((value) async {
      for (var i = 0; i < 5; i++) {
        imgurl.add(newsData[i]['imgLink']);
        headline.add(newsData[i]['headline']);
        postUrl.add(newsData[i]['postUrl']);
      }
      print(newsData);
      bloc.add(FetchNewsSuccess(newsData, imgurl, headline, postUrl, lit));
    });
  }
}

class FetchNewsSuccess extends DataEvent {
  List newsData;
  List<String> imgurl;
  List headline;
  List postUrl;
  DocumentSnapshot list;
  FetchNewsSuccess(this.newsData, this.imgurl, this.headline, this.postUrl, this.list);
}

class FetchMoreNews extends DataEvent{
  List newsData = [];

  FetchMoreNews(DataBloc bloc){
    fetch(bloc);
  }

  void fetch(DataBloc bloc){
    final db = Firestore.instance;
    DocumentSnapshot lit;
    Future <List <DocumentSnapshot>> list() async {
      var data  = await db.collection('news').startAfter([bloc.state.list['id']]).orderBy('id').limit(12).getDocuments();
      var docs = data.documents;
      if(docs.length < 11) {
        bloc.nomore = true;
        print("DFFDFDFDFDFDFDF");
        print(bloc.nomore);
      }
      if(!bloc.nomore){
        lit = docs.last;
      }
      return docs;
    }
    list().then((value) async {
      value.forEach((val) {
        final newsvalue = (val['content']);
        //print(val['id']);
        //newsd = newsvalue;
        //print(newsd);
        bloc.state.newsData.add(newsvalue);
      });
      bloc.add(FetchMoreNewsSuccess(newsData, lit));
    });
  }
}

class FetchMoreNewsSuccess extends DataEvent {
  List newsData;
  DocumentSnapshot list;
  FetchMoreNewsSuccess(this.newsData, this.list);
}

class AddToken extends DataEvent {
  String token;
  AddToken(this.token, DataBloc bloc){
    add(bloc);
  }

  add(DataBloc bloc) async {
    final db = Firestore.instance;
    var tokenn = db.collection('DeviceTokens');
    await tokenn.add({
      'token': '$token',
      'createdAt': FieldValue.serverTimestamp(),
      'platform': Platform.operatingSystem
    }).then((value) {
      bloc.initialized = true;
      Covid.prefs.setBool(Covid.initialized, true);
    });
  }
}

class Youtube extends DataEvent{
  List<YoutubePlayerController> controllers = ['https://www.youtube.com/watch?v=G-wB_IANUzw&t=2s','https://www.youtube.com/watch?v=DCdxsnRF1Fk', 'https://www.youtube.com/watch?v=7tgm8KBlCtE'].map<YoutubePlayerController>(
    (link) => YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(link),
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    ),
  ).toList();
}