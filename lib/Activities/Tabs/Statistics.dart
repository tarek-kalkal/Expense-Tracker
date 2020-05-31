import 'package:budgets/models/Budget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';


class Statistics extends StatelessWidget {

  Budget budget ;
  Statistics (Budget budget) {
    this.budget=budget ;

  }


static const background = const Color(0xffF7F7F7);


  @override
  Widget build(BuildContext context) {

    var initial = budget.initial ;
    var rest = budget.rest ;
    var spend ;
    var percent ;
    var progresseBarColor ;
    var p ;

    if(rest >= 0 ) {
      spend = initial - rest ;
      percent = (spend * 100) / initial;
    }
    else if (rest < 0) {
      spend = initial - rest ;
      percent = 100 ;
    }

    if (percent < 80) {
      progresseBarColor = Colors.blue ;
    }
    else {
      progresseBarColor = Colors.red ;
    }

    p=double.parse((percent).toStringAsFixed(2));


    return Scaffold (
      backgroundColor: background,

      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 10 ,left: 10 , top: 15),
            child: Column(
              children: <Widget>[
                Container (
                alignment: Alignment.topLeft,
                  child:
                Text ( budget.title ,  style: TextStyle(
                  fontSize: 25 , fontFamily: 'Open Sans' , fontWeight: FontWeight.bold
                ),)

                ),

                Padding (
                  padding: EdgeInsets.only(top: 10 , bottom:  5 ),
                child :
                Row(

                  children: <Widget>[
                    Expanded (
                      child:

                    Text("Cash" , style:  TextStyle(
                      color: Colors.black38,
                      fontSize: 20 , fontWeight: FontWeight.w500
                    ),)
                      )
                    ,
                    Expanded (
                    child:
                    Text("DA" + "$initial" , textAlign: TextAlign.right , style:  TextStyle(color:  Colors.blue , fontSize: 24 , fontWeight: FontWeight.bold),)
                      )
                  ],
                ) ) ,

                Row(
                  children: <Widget>[
                    Expanded (child:
                    Text("Le reste" , style:  TextStyle(
                      color: Colors.black38,
                        fontSize: 20 , fontWeight: FontWeight.w500
                    ),))

                    ,
                    Expanded (child:
                    Text("DA" + "$rest" , textAlign : TextAlign.right, style:  TextStyle(color:  Colors.black , fontSize: 24 , fontWeight: FontWeight.bold),)
                      )
                      ],
                ) ,

                Container(
                  margin: EdgeInsets.only(top: 15 , right:5, left: 5 , bottom:  10),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 1,
                  color: Colors.grey[300]
                  ,
                ) ,

                Container (
                    alignment: Alignment.topLeft,
                    child:
                      Text ( "L'USAGE" ,  style: TextStyle(
                        fontSize: 20 , fontFamily: 'Open Sans' , fontWeight: FontWeight.bold
                    ),)

                ),

                Padding(
                  padding: EdgeInsets.all(15.0),
                  child: new LinearPercentIndicator(
                    width: MediaQuery.of(context).size.width - 50,
                    animation: true,
                    backgroundColor: Colors.grey[300],
                    lineHeight: 30.0,
                    animationDuration: 2000,
                    percent: percent/100,
                    center: Text("$p" + "%"),
                    linearStrokeCap: LinearStrokeCap.roundAll,
                    progressColor: progresseBarColor,
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(top: 10 , right:5, left: 5 , bottom:  10),
                  width: MediaQuery.of(context).size.width - 50,
                  height: 1,
                  color: Colors.grey[300]
                  ,
                ) ,

                Container (
                    alignment: Alignment.topLeft,
                    child:
                    Text ( "LE CASH FLOW" ,  style: TextStyle(
                        fontSize: 20 , fontFamily: 'Open Sans' , fontWeight: FontWeight.bold
                    ),)

                ),

                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: new LinearPercentIndicator(
                            width: 100 ,
                            animation: false,
                            backgroundColor: Colors.grey[300],
                            lineHeight: 25.0,
                            animationDuration: 2000,
                            percent: 1,
                             //Text(),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.blue,
                          ),
                        ),

                        Text("DA " + "$initial"  , style:  TextStyle(
                            color: Colors.black38,
                            fontSize: 18 , fontWeight: FontWeight.w500
                        ),)


                      ],
                    ),

                    Row(
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.all(15.0),
                          child: new LinearPercentIndicator(
                            width: 100 ,
                            animation: true,
                            backgroundColor: Colors.grey[300],
                            lineHeight: 25.0,
                            animationDuration: 2000,
                            percent: percent /100,
                            //Text(),
                            linearStrokeCap: LinearStrokeCap.roundAll,
                            progressColor: Colors.red,
                          ),
                        ),

                          Text("DA " + "$spend" + "  Utilisé" , style:  TextStyle(
                            color: Colors.black38,
                            fontSize: 18 , fontWeight: FontWeight.w500
                        ),)


                      ],
                    )
                  ],
                )




              ],
            ),
          )
        ],
      ),
    ) ;
  }



}