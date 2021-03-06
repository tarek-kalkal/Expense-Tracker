import 'package:budgets/Activities/Tabs/Expenses.dart';
import 'package:budgets/Activities/Tabs/Statistics.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:budgets/Activities/AddItem.dart';
import 'package:budgets/models/Budget.dart';
import 'package:budgets/models/Item.dart';
import 'package:budgets/utils/database_helper.dart';
import 'package:sqflite/sqflite.dart';

class Test extends StatefulWidget {
  String title;
  Budget budget;
  Test(Budget budget) {
    this.budget = budget;
  }

  @override
  State<StatefulWidget> createState() {
    return TestState(budget);
  }
}

class TestState extends State<Test> {
  Budget budget;

  TestState(Budget budget) {
    this.budget = budget;
  }
  //int bid = this.budget.id ;

  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Item> itemList;
  int count = 0;
  double _total;
  double rest;
 ///const Color(0xffedede)
  static const background = const Color(0xffF7F7F7);

  //double rest = budget.initial -  ;

  @override
  Widget build(BuildContext context) {
    return
      DefaultTabController(
        length: 2,
        child:

      Scaffold(
      backgroundColor: background,

      appBar: AppBar(
        elevation:0,
        iconTheme: IconThemeData(
          size: 30,
          color: Colors.black, //change your color here
        ),
        title: Text(
         // budget.title + "  Rest = " + budget.rest.toString() + " \$",
          "Aperçu" ,
          style: TextStyle(color: Colors.black),
          textScaleFactor: 1.3,
        ),
        actions: <Widget>[
          IconButton(
            iconSize: 30,
            icon: Icon(Icons.file_download),
            color: Colors.grey,

            tooltip: "Télécharger les éléments de ce budget",
            onPressed: () {
              _saveItemsToCsv(context) ;
              print('Click search');
            },
          ),
        ],
        bottom: TabBar (tabs: <Widget>[
          Text ("LES FRAIS"
            ,style: TextStyle(
              fontSize: 18,
            color: Colors.black
          ),) ,
          Text("LES STATISTICS" ,style: TextStyle(
              fontSize: 18,
              color: Colors.black
          ),) ,

        ],

        ) ,
        centerTitle: true,
        backgroundColor: background,
      ),

      body:
          TabBarView(
            children: <Widget>[
              Expenses(budget) ,
              Statistics(budget),
            ],
          )


    )
      );
  }

  void _saveItemsToCsv(BuildContext context) async {

    double spent = budget.initial - budget.rest ;
    String spentString = "la valeur dépensée = " + spent.toString() ;

    Item item = new Item( "la valeur initiale + la valeur dépensée :" , spent.toString()  , budget.initial) ;
    //Item item2 = new Item("_title", "_date" , 50);
    item.bid = budget.id ;
//    //item.id= 0 ;
//    Item item ;
//    item =new Item() ;
//    item.title = "la valeur initial :" ;
//    item.value = budget.initial ;
//    item.bid = null ;
//
//    item.date = "la valeur dépensée = |" + spent.toString()  ;

 //   int resultt = await databaseHelper.insertItem(Item(  "la valeur initial :" + spentString , budget.initial.toString() , 0    ));

    int resultt = await databaseHelper.insertItem(item);
    if (resultt != 0) {
      // Success
      int result = await databaseHelper.saveItemsToCsv(budget) ;
      if(result != 0) {

      int deletResult = await databaseHelper.deleteLastItem() ;
      if(deletResult!= 0) {
        print(" items to csv ...");

        _showAlertDialog("Télécharger les éléments" , "Les Éléments de ce budget sont stockés dans /stockage/Android/data/com.example.budgets") ;
      }

      }

    } else {
      // Failure
      _showAlertDialog('Statut', "Problème d'enregistrement de l'élément");
    }

//    int result = await databaseHelper.saveItemsToCsv(budget) ;
//    if(result != 0) {
//      print(" items to csv ...");
//      //_showSnackBar(context, "Budgets stored to csv Successfully") ;
//      _showAlertDialog("Télécharger les éléments" , "Les Éléments de ce budget sont stockés dans /stockage/Android/data/com.example.budgets") ;
//    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }


}