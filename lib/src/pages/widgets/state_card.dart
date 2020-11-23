import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class StateCard extends StatelessWidget {
  final String path;
  final String title;
  final String amount;
  final String newCases;
  final Color color;

  const StateCard({Key key, this.path, this.title, this.amount, this.newCases, this.color}) : super(key: key);
  

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: AnimatedContainer(
        duration: Duration(milliseconds: 500),
        decoration: BoxDecoration(
          color: DataBloc().darkModeOn ? darkCard: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: !DataBloc().darkModeOn ? [
            BoxShadow(
              color: Colors.grey[200],
              blurRadius: 10,
              spreadRadius: 5,
            )
          ] : null,
        ),
        child: Ink(
          height: MediaQuery.of(context).size.height * 0.115,
          width: MediaQuery.of(context).size.width * 0.93,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: color),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            amount,
                            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 25, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            newCases.length > 0 ?' ('+newCases+')' : '',
                            style: Theme.of(context).textTheme.headline4.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      // decoration: BoxDecoration(
                      //   border: Border.all(
                      //     color: Colors.red,
                      //   )
                      // ),
                      width: 60,
                      height: 40,
                      child: SvgPicture.asset(
                        path,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}