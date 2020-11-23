import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/models/chart_data.dart';
import 'package:covid_19_nigeria/src/models/state_name.dart';
import 'package:covid_19_nigeria/src/models/states_data.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

enum LoadingState { none, loading, error }

class DataState {
  List states = [];
  List day = [];
  List total = [];
  List dayTotal = [];
  List totalCases = [];
  String stateTotalCases;
  List stateActiveCases = [];
  List stateRecovered = [];
  List stateDeaths = [];
  List newsData = [];
  List<ChartData> stateChart = [];
  List<ChartData> chartData;
  List<String> imgurl = [];
  List headline = [];
  List posturl = [];
  StateName selectedState;
  String ddate;
  DocumentSnapshot list;

  List<YoutubePlayerController> controllers = ['https://www.youtube.com/watch?v=G-wB_IANUzw&t=2s','https://www.youtube.com/watch?v=DCdxsnRF1Fk', 'https://www.youtube.com/watch?v=7tgm8KBlCtE'].map<YoutubePlayerController>(
    (link) => YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(link),
      flags: YoutubePlayerFlags(
        autoPlay: false,
      ),
    ),
  ).toList();

  LoadingState state = LoadingState.loading;

  DataState.initial();
  DataState(DataState currentState){
    this.state = currentState.state;
    this.states = currentState.states;
    this.day = currentState.day;
    this.total = currentState.total;
    this.dayTotal = currentState.dayTotal;
    this.totalCases = currentState.totalCases;
    this.stateTotalCases = currentState.stateTotalCases;
    this.stateActiveCases = currentState.stateActiveCases;
    this.stateRecovered = currentState.stateRecovered;
    this.stateDeaths = currentState.stateDeaths;
    this.stateChart = currentState.stateChart;
    this.chartData = currentState.chartData;
    this.newsData = currentState.newsData;
    this.imgurl = currentState.imgurl;
    this.headline = currentState.headline;
    this.posturl = currentState.posturl;
    this.ddate = currentState.ddate;
    this.list = currentState.list;
  }
}