import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/src/models/bat_item.dart';
import 'package:covid_19_nigeria/src/pages/data_page.dart';
import 'package:covid_19_nigeria/src/pages/news_page.dart';
import 'package:covid_19_nigeria/src/pages/tips_page.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:covid_19_nigeria/utils/covid.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class Home extends StatefulWidget {
  const Home({@required DataBloc dataBloc}) : _dataBloc = dataBloc;

  final DataBloc _dataBloc;
  @override
  _HomeState createState() => _HomeState(_dataBloc);
}

class _HomeState extends State<Home> {
  final DataBloc _dataBloc;
  _HomeState(this._dataBloc);

  int _index = 0;

  
  final List<Widget> pages = [
    DataPage(
      key: PageStorageKey('Page 1'),
    ),
    TipsPage(
      key: PageStorageKey('Page 2'),
    ),
    NewsPage()
  ];

  final PageStorageBucket bucket = PageStorageBucket();

  Widget _bottomNavBar(int index) => AnimatedContainer(
    duration: Duration(milliseconds: 500),
    child: BottomNavigationBar(
      onTap: (int index) => setState(() => _index = index),
      currentIndex: index,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: _dataBloc.darkModeOn ? Colors.white : Colors.black,
      unselectedItemColor: _dataBloc.darkModeOn ? Colors.white54 : Colors.grey.shade600,
      elevation: 10,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: index == 0 ? 30 : 28,
            height: index == 0 ? 30 : 28,
            child: SvgPicture.asset(
              Covid.Dashboard_dark,
              color: _dataBloc.darkModeOn ? index == 0 ? Colors.white : Colors.white54 : index == 0 ? Colors.black : Colors.grey.shade600,
            ),
          ),
          title: AnimatedContainer(
            margin: EdgeInsets.only(top: 5),
            duration: const Duration(milliseconds: 200),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  index == 0 ? paleGreen.withOpacity(0.7) : Colors.transparent
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: index == 1 ? 30 : 28,
            height: index == 1 ? 30 : 28,
            child: SvgPicture.asset(
              Covid.Information_dark,
              color: _dataBloc.darkModeOn ? index == 1 ? Colors.white : Colors.white54 : index == 1 ? Colors.black : Colors.grey.shade600,
            ),
          ),
          title: AnimatedContainer(
            margin: EdgeInsets.only(top: 5),
            duration: const Duration(milliseconds: 200),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  index == 1 ? paleGreen : Colors.transparent
            ),
          ),
        ),
        BottomNavigationBarItem(
          icon: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: index == 2 ? 30 : 28,
            height: index == 2 ? 30 : 28,
            child: SvgPicture.asset(
              Covid.News_dark,
              color: _dataBloc.darkModeOn ? index == 2 ? Colors.white : Colors.white54 : index == 2 ? Colors.black : Colors.grey.shade600,
            ),
          ),
          title: AnimatedContainer(
            margin: EdgeInsets.only(top: 5),
            duration: const Duration(milliseconds: 200),
            height: 6,
            width: 6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:  index == 2 ? paleGreen : Colors.transparent
            ),
          ),
        )
      ],
    ),
  );

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        body: PageStorage(
          bucket: bucket,
          child: pages[_index]
        ),
        bottomNavigationBar: BottomNavBar(
          bloc: _dataBloc,
          barItems: [
            BarItem(title: 'Dashboard', path: Covid.Dashboard_dark),
            BarItem(title: 'Tips', path: Covid.Information_dark),
            BarItem(title: 'News', path: Covid.News_dark),
          ],
          onChange: (index) {
            setState(() {
              _index = index;
              print(_index);
            });
          }
        ),
      ),
    );
  }
}

class BottomNavBar extends StatefulWidget {
  final List<BarItem> barItems;
  final DataBloc bloc;
  final Function onChange;

  const BottomNavBar({
    Key key,
    this.bloc,
    this.barItems,
    this.onChange
  }) : super(key: key);

  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {

  int selectedBar = 0;

  @override
  Widget build(BuildContext context) {
    return NavBar(
      barItems: widget.barItems,
      animationDuration: const Duration(milliseconds: 250),
      bloc: widget.bloc,
      onBarTap: (index) {
        setState(() {
          selectedBar = index;
          widget.onChange(selectedBar);
        });
      }
    );
  }
}

class NavBar extends StatefulWidget {
  final List<BarItem> barItems;
  final Duration animationDuration;
  final DataBloc bloc;
  final Function onBarTap;

  const NavBar({Key key, this.barItems, this.animationDuration, this.bloc, this.onBarTap}) : super(key: key);

  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> with TickerProviderStateMixin {

  int selectedBarIndex = 0;

  List<Widget> _navBarItems() {
    List<Widget> _barItems = List();
    for(int i=0; i<widget.barItems.length; i++) {
      BarItem item = widget.barItems[i];
      bool isActive = selectedBarIndex == i;
      _barItems.add(
        InkWell(
          splashColor: Colors.transparent,
          onTap: () {
            setState(() {
              selectedBarIndex = i;
              widget.onBarTap(selectedBarIndex);
            });
          },
          child: AnimatedContainer(
            duration: widget.animationDuration,
            width: item.title == 'Dashboard' ? 150 : 120,
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: isActive ? paleGreen.withOpacity(0.15) : Colors.transparent,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                AnimatedContainer(
                  duration: widget.animationDuration,
                  width: isActive ? 28 : 26,
                  height: isActive ? 28 : 26,
                  child: SvgPicture.asset(
                    item.path,
                    color: isActive ? paleGreen : widget.bloc.darkModeOn ? Colors.white54 : Colors.grey.shade600,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                AnimatedSize(
                  duration: widget.animationDuration,
                  curve: Curves.easeInOut,
                  vsync: this,
                  child: Text(
                    isActive ? item.title : '',
                    style: Theme.of(context).textTheme.headline5.copyWith(fontWeight: FontWeight.w500, fontSize: 18, color: paleGreen),
                  ),
                ),
              ],
            ),
          )
        )
      );
    }
    return _barItems;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      color: widget.bloc.darkModeOn ? Colors.grey[900] : Colors.grey[100],
      child: Material(
        elevation: 20.0,
        child: Padding(
          padding: EdgeInsets.only(
            top: 10.0,
            bottom: 15.0,
            left: 14.0,
            right: 14.0
          ),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: _navBarItems(),
          ),
        ),
      ),
    );
  }
}