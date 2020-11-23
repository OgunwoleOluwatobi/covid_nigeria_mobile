import 'package:bloc/bloc.dart';
import 'package:covid_19_nigeria/src/bloc/events/data_event.dart';
import 'package:covid_19_nigeria/src/bloc/states/data_state.dart';
import 'package:covid_19_nigeria/src/models/state_name.dart';
import 'package:flutter/material.dart';

class DataBloc extends Bloc<DataEvent, DataState> {
  static final DataBloc _dataBlocSingleton = DataBloc._internal();

  factory DataBloc(){
    return _dataBlocSingleton;
  }

  DataBloc._internal();

  bool darkModeOn;
  bool initialized;
  int nindex = 0;
  bool nomore = false;
  List<StateName> _statename = StateName.getState();
  StateName selectedState;
  String stateName = 'Overall';
  int id = 0;

  @override
  DataState get initialState => DataState.initial();

  @override
  Stream<DataState> mapEventToState(
    DataEvent event,
  ) async* {
    final newState = DataState(state);
    if (event is DarkMode) {
      yield newState;
    }
    if (event is FetchData) {
      newState.state = LoadingState.loading;
      yield newState;
    }
    if (event is FetchDataSuccess) {
      newState.state = LoadingState.none;
      newState.states = event.states;
      newState.day = event.day;
      newState.total = event.total;
      newState.dayTotal = event.daytot;
      newState.totalCases = event.totalCases;
      newState.chartData = event.chartData;
      newState.ddate = event.ddate;
      print(newState.chartData);
      yield newState;
    }
    if(event is ViewState) {
      newState.state = LoadingState.loading;
      newState.stateTotalCases = event.totalCases;
      newState.stateActiveCases = event.activeCases;
      newState.stateRecovered = event.recovered;
      newState.stateDeaths = event.deaths;
      newState.stateChart = event.stateChart;
      newState.state = LoadingState.none;
      print(event.totalCases);
      yield newState;
    }
    if(event is FetchNews) {
      newState.state = LoadingState.loading;
      yield newState;
    }
    if(event is FetchNewsSuccess) {
      newState.state = LoadingState.none;
      newState.newsData = event.newsData;
      newState.imgurl = event.imgurl;
      newState.headline = event.headline;
      newState.posturl = event.postUrl;
      newState.list = event.list;
      yield newState;
    }
    if(event is FetchMoreNews) {
      //newState.state = LoadingState.loading;
      yield newState;
    }
    if(event is FetchMoreNewsSuccess) {
      newState.state = LoadingState.none;
      newState.list = event.list;
      yield newState;
    }
  }
}

@override
  void onTransition(Transition transition) {
    print(transition);
  }

  @override
  void onError(Object error, StackTrace stacktrace) {
    print(error);
  }
