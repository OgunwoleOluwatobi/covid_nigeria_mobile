import 'package:covid_19_nigeria/src/bloc/blocs/data_bloc.dart';
import 'package:covid_19_nigeria/styles/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ActionCard extends StatelessWidget {
  final String path;
  final String title;
  final String amount;
  final String newc;
  final Color color;
  final DataBloc bloc;

  const ActionCard({Key key, this.path, this.title, this.amount, this.newc, this.color, this.bloc}) : super(key: key);
  

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
          height: MediaQuery.of(context).size.height * 0.1,
          width: MediaQuery.of(context).size.width * 0.45,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(height: 7,),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.headline6.copyWith(fontSize: 20, fontWeight: FontWeight.w600, color: color),
                    ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 5.0),
                      child: Row(
                        children: <Widget>[
                          Text(
                            amount,
                            style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 22, fontWeight: FontWeight.w600),
                          ),
                          Text(
                            newc != null ? ' +'+newc : '',
                            style: Theme.of(context).textTheme.headline5.copyWith(fontSize: 18, fontWeight: FontWeight.w600, color: bloc.darkModeOn ? Colors.white70 : Colors.black54),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(left: 4),
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