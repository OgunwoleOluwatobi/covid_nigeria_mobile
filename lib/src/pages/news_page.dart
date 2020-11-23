import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/bloc/events/data_event.dart';
import 'package:covid_19_nigeria/src/bloc/states/data_state.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

Future<void> _launchUrl(String url) async {
  if(await canLaunch(url)) {
    await launch(
      url,
      forceSafariVC: true,
      forceWebView: true,
      headers: <String, String>{'header_key': 'header_value'},
    );
  } else {
    throw 'Could not launch $url';
  }
}

class NewsPage extends StatefulWidget {
  const NewsPage({Key key}) : super(key: key);

  @override
  _NewsPageState createState() => _NewsPageState();
}

class _NewsPageState extends State<NewsPage> {
  var _dataBloc = DataBloc();
  ScrollController _scrollController = ScrollController();
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() { 
    super.initState();
    _scrollController.addListener(() {
      //print('HHHHHHHHHHHHHHHHHHHHHHHHHH');
      //print(_scrollController.position.pixels);
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
          if(!_dataBloc.nomore) {
            _dataBloc.add(FetchMoreNews(_dataBloc));
          }
      }
    });
    Future.delayed(Duration.zero, () {
      if(_dataBloc.state.newsData.length == 0){
        FetchNews(_dataBloc);
      }
    });
    
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    Widget newsUI(String image, String title, String url){
      final makeListCard = ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0,),
        leading: Container(
          width: 100,
          //padding: EdgeInsets.only(right: 3.0),
          // decoration: new BoxDecoration(
          //   border: new Border(
          //     right: new BorderSide(width: 1.0, color: _dataBloc.darkModeOn ? Colors.white24 : Colors.black38),
          //   ),
          //   borderRadius: BorderRadius.circular(10.0)
          // ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(3.0)),
            child: CachedNetworkImage(imageUrl: image, fit: BoxFit.cover),
          )
        ),
        title: Row(
          children: <Widget>[
            //Icon(Icons.linear_scale, color: Colors.greenAccent),
            Expanded(
              flex: 5,
              child: Padding(
                padding: EdgeInsets.only(top: 7),
                child: new Text(
                title,
                style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 16, fontWeight: FontWeight.w600, letterSpacing: 0.8,),
              )),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(left: 5.0, top: 5),
          child: Text(
            'source: Channels Television',
            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 13),
          ),
        ),
        //trailing: Icon(Icons.keyboard_arrow_right, color: Theme.of(context).iconTheme.color, size: 20.0,),
        onTap: () {
          _launchUrl(url);
        },
      );

      return new Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
        elevation: 0,
        //color: Colors.white30,
        margin: EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
        child: makeListCard
      );
    }

    return AnimatedContainer(
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
                    margin: EdgeInsets.only(top: 60),
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
                            'News Feed',
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
          bloc: _dataBloc,
          builder: (context, state) {
            if(state.state == LoadingState.loading)
              return Center(
                child: Shimmer.fromColors(
                  direction: ShimmerDirection.ltr,
                  period: Duration(seconds: 2),
                  child: Column(
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.grey[100],
                        ),
                        width: MediaQuery.of(context).size.width * 0.89,
                        height: 200,
                      ),
                      Container(
                        height: 500,
                        child: ListView.builder(
                          physics: NeverScrollableScrollPhysics(),
                          itemCount: 5,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
                              child: Row(
                                children: <Widget>[
                                  Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: Colors.grey[100],
                                    ),
                                    width: MediaQuery.of(context).size.width * 0.3,
                                    height: 70,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.47,
                                            height: 10,
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.black,
                                            ),
                                            width: MediaQuery.of(context).size.width * 0.3,
                                            height: 8,
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            );
                          }
                        ),
                      )
                    ],
                  ),
                  baseColor: _dataBloc.darkModeOn ? Colors.grey[400] : Colors.grey[400],
                  highlightColor: _dataBloc.darkModeOn ? Colors.grey[200] : Colors.grey[200]
                )
              );
            if(state.state == LoadingState.none)
              return RefreshIndicator(
                key: _refreshIndicatorKey,
                onRefresh: _refresh,
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal:10.0, vertical: 5.0),
                    child: state.newsData.length > 0 ? Column(
                      children: <Widget>[
                        SizedBox(height: 20,),
                        CarouselSlider(
                          options: CarouselOptions(
                            autoPlay: true,
                            viewportFraction: 0.83,
                            height: 230,
                            aspectRatio: 2.0,
                            enlargeCenterPage: true,
                          ),
                          items: imageSliders(state.imgurl, state.headline, state.posturl, _dataBloc, context),
                        ),
                        SizedBox(height: 20,),
                        Container(
                          height: ((state.newsData.length-5) * 101).toDouble(),
                          child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: state.newsData.length-5,
                            itemBuilder: (context, i){
                              //return index > 4 ? newsUI(state.newsData[index]['imgLink'], state.newsData[index]['headline']) : null;
                              return i == state.newsData.length-6 ? Container(
                                //color: Colors.black,
                                width: _dataBloc.nomore ? 0 : 20,
                                height: _dataBloc.nomore ? 0 : 20,
                                child: _dataBloc.nomore ? SizedBox(height: 0,) : CupertinoActivityIndicator(),
                              ) : newsUI(state.newsData[i+5]['imgLink'], state.newsData[i+5]['headline'], state.newsData[i+5]['postUrl']);
                              //return Text('kdnkjndknkd');
                            },
                          ),
                        ),
                      ],
                    )
                    : 
                    Center(
                      child: Shimmer.fromColors(
                        direction: ShimmerDirection.ltr,
                        period: Duration(seconds: 2),
                        child: Column(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.grey[100],
                              ),
                              width: MediaQuery.of(context).size.width * 0.89,
                              height: 200,
                            ),
                            Container(
                              height: 500,
                              child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: 5,
                                itemBuilder: (context, index) {
                                  return Container(
                                    padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 15.0),
                                    child: Row(
                                      children: <Widget>[
                                        Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10.0),
                                            color: Colors.grey[100],
                                          ),
                                          width: MediaQuery.of(context).size.width * 0.3,
                                          height: 70,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(14.0),
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.47,
                                                  height: 10,
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(top: 10),
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                  ),
                                                  width: MediaQuery.of(context).size.width * 0.3,
                                                  height: 8,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  );
                                }
                              ),
                            )
                          ],
                        ),
                        baseColor: _dataBloc.darkModeOn ? Colors.grey[400] : Colors.grey[400],
                        highlightColor: _dataBloc.darkModeOn ? Colors.grey[300] : Colors.grey[200]
                      )
                    ),
                  ),
                ),
              );
          }
        ),
      ),
    );
  }
  Future<Null> _refresh() async {
    Future.delayed(Duration.zero, () {
      FetchNews(_dataBloc);
    });
  }
}

List<Widget> imageSliders(List imgurl, List headline, List urls, DataBloc bloc, context){ 
  return imgurl.map((item) => Container(
  child: Container(
    margin: EdgeInsets.all(0),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(8.0)),
      child: GestureDetector(
        onTap: () {
          _launchUrl(urls[imgurl.indexOf(item)]);
        },
        child: Stack(
          children: <Widget>[
            CachedNetworkImage(imageUrl: item, fit: BoxFit.cover, width: 1000.0, height: 250,),
            Positioned(
              bottom: 0.0,
              left: 0.0,
              right: 0.0,
              child: Container(
                decoration: BoxDecoration(
                  gradient: bloc.darkModeOn ? LinearGradient(
                    colors: [
                      Color.fromARGB(200, 255, 255, 255),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ): LinearGradient(
                    colors: [
                      Color.fromARGB(200, 0, 0, 0),
                      Color.fromARGB(0, 0, 0, 0)
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
                padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                child: Text(
                  headline[imgurl.indexOf(item)],
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      )
    ),
  ),
)).toList();}
