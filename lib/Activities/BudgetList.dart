
import 'dart:io';

import 'package:budgets/utils/CustomAlertDialog.dart';
import 'package:budgets/utils/csvGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:budgets/Activities/Test.dart';
import 'package:budgets/Activities/budgetDetails.dart';
import 'package:budgets/models/Budget.dart';
import 'package:budgets/utils/database_helper.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';


class BudgetList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return BudgetListState();
  }
}

class BudgetListState extends State<BudgetList> {
  DatabaseHelper databaseHelper = DatabaseHelper();
  List<Budget> budgetList;
  int count = 0;

  static const background = const Color(0xffF7F7F7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        backgroundColor: background,
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),

        title: Text(
          'Les Budgets',

          style: TextStyle(
            color: Colors.black,
          ),
          textScaleFactor: 1.3,
        ),
        centerTitle: true,
        elevation:1,
       // backgroundColor: Colors.green,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.file_download , color: Colors.grey,),
              tooltip: 'Télécharger les budgets',
            onPressed: () {
              _saveBudgetsToCsv(context) ;
              print('Click download');
            },
          ),
        ],
      ),
      body: getBudgetListView(),
      floatingActionButton:



      FloatingActionButton(

        onPressed: () {
          debugPrint('FAB Clicked');
          Budget budget ;


          Navigator.of(context).push(
            PageRouteBuilder(
                pageBuilder: (context, _, __) => _editItemDialod(Budget('', '', 0), 'Ajouter un budget') ,
                opaque: false),
          );

         // push(Budget('', '', 0), 'Add Budget');
        },
        tooltip: 'Ajouter un budget',
        child: Icon(Icons.add) ,
      //  backgroundColor: Colors.green,
      ),
    );
  }

  ListView getBudgetListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    _updateListView();

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return
          Card(
            color: background,
            shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
            elevation: 0.4,

          child: ListTile(

            leading: Image(
              image: AssetImage('images/money-bag.png'),
              width: 40,
              height: 40,
            ) ,
            title: Text(
              this.budgetList[position].title,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Open Sans',
                  fontSize: 20),
            ),
            subtitle: Text(this.budgetList[position].date , style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),),
            trailing: GestureDetector(
              child:
              Text("DA " + this.budgetList[position].initial.toString() , textAlign: TextAlign.right , style:  TextStyle(color:  Colors.blueGrey[500] , fontSize: 20 , fontWeight: FontWeight.bold),)

            ),
            onLongPress: () {

              _showDialog( context , this.budgetList[position]);
//              _deleteB(this.budgetList[position]) ;
//
//              Scaffold.of(context).showSnackBar(SnackBar(
//                content: Text('Budget Deleted Successfully '),
//                duration: Duration(seconds: 3),
//              ));

            },
            onTap: () {
              debugPrint("ListTile Tapped");
              push1(this.budgetList[position]);
            },
          ),
        );
      },
    );
  }

  void _showDialog(BuildContext context , Budget budget) {
    // flutter defined function
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Supprimer le budget"),
          content: new Text("Voulez-vous supprimer ce budget ?"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Oui"),
              onPressed: () {
                Navigator.of(context).pop();

                _deleteB(context , budget) ;
              },
            ),
            new FlatButton(
              child: new Text("Non"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


  void _saveBudgetsToCsv(BuildContext context) async {
    int result = await databaseHelper.saveBudgetsToCsv() ;
    if(result != 0) {
      print("Budgets to csv ...");
      //_showSnackBar(context, "Budgets stored to csv Successfully") ;
      _showAlertDialog("Télécharger les Budgets" , "Les Budgets sont stockés dans /stockage/Android/data/com.example.budgets") ;
    }

  }

  void _deleteB( BuildContext context ,  Budget budget) async {
    int result = await databaseHelper.deleteBudget(budget.id);
    int resultt =await databaseHelper.deleteItems(budget.id) ;
    if (result != 0 && resultt !=0) {
     // _showSnackBar(' Budget Deleted Successfully ');
      _updateListView();


    }
  }




  void _showSnackBar( String s) {
    final snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void push1(Budget budget) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      //return BudgetItemsList(budget, title);
      return Test(budget);
    }));
    if (result = true) {
      _updateListView();
    }
  }

  void push(
      Budget budget,
      String title,
      ) async {
    bool result =
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return BudgetDetails(budget, title);
      //return Test(budget.id) ;
    }));
    if (result = true) {
      _updateListView();
    }
  }

  void _updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Budget>> budgetListFuture = databaseHelper.getBudgetList();
      budgetListFuture.then((budgetList) {
        setState(() {
          this.budgetList = budgetList;
          this.count = budgetList.length;
        });
      });
    });
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  _editItemDialod(Budget budget ,  String title) {
    TextEditingController titleController = TextEditingController();
    TextEditingController initialController = TextEditingController();

    titleController.text = budget.title;

    initialController.text = budget.initial.toString();

    return CustomAlertDialog(
      title: Text("Ajouter un Budget"),

        content: new Container(
            width: 250.0,
            height: 270.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(40.0)),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                    padding:
                    EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: TextField(
                      controller: titleController,
                      onChanged: (value) {
                        updateTitle(budget, titleController.text);
                        debugPrint('Something changed in Title Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: 'Titre',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    )),
                Padding(
                    padding:
                    EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: initialController,
                      onChanged: (value) {
                        updateInitial(budget , initialController.text);
                        debugPrint('Something changed in Initial Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: 'Valeur',
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    )),
                Padding(
                    padding:
                    EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                              height: 40,
                              child: RaisedButton(
                                color: Colors.grey[200],
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(20.0),
                                    side: BorderSide(color: Colors.blueGrey[500])
                                ),
                                child: Text(
                                    'Supprimer',
                                  style: TextStyle(color: Colors.blueGrey[500]),
                                  textScaleFactor: 1.1,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _delete(budget);
                                    debugPrint("Delete button clicked");
                                  });
                                },
                              ),
                            )),
                        Container(
                          width: 10.0,
                        ),

                        Expanded(
                            child: Container(
                              height: 40,
                              child: RaisedButton(
                                color: Colors.blueGrey[500],
                                shape: new RoundedRectangleBorder(
                                    borderRadius: new BorderRadius.circular(10.0),
                                    //side: BorderSide(color: Colors.black)
                                ),
                                child: Text(
                                  'Enregistrer',
                                  textScaleFactor: 1.1,
                                  style: TextStyle(color: Colors.white),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _save(budget , titleController.text , initialController.text);
                                    debugPrint("Save button clicked");
                                  });
                                },
                              ),
                            )),


                      ],
                    ))
              ],
            )));
  }

  // Update the title of Note object
  void updateTitle(Budget budget , String title) {
    budget.title = title;
  }

  // Update the description of Note object
  void updateInitial(Budget budget , String initial) {
    budget.initial = double.parse(initial);
  }

  void _save(Budget budget , String title , String initial) async {
   Navigator.pop(context) ;

    budget.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (budget.id != null) {

      double daltaValue = budget.initial - double.parse(initial);

      if (daltaValue > 0) {
        budget.rest = budget.rest - daltaValue.abs();
        //item.value = double.parse(value);
      } else if (daltaValue < 0) {
        budget.rest = budget.rest + daltaValue.abs();
        //item.value = double.parse(value);
      } else {
        budget.rest = budget.rest;
        //item.value = double.parse(value);
      }


      // Case 1: Update operation
      result = await databaseHelper.updateBudget(budget);
    } else {
      // Case 2: Insert Operation
      if (title == "") {
        return;
      } else {
        budget.rest = budget.initial;
        result = await databaseHelper.insertBudget(budget);
      }
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Statut', 'Budget enregistré');
    } else {
      // Failure
      _showAlertDialog('Statut', "Problème d'enregistrement de budget");
    }
  }



  void _delete(Budget budget) async {
    Navigator.pop(context);

    // Casev 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (budget.id == null) {
      _showAlertDialog('Statut',  "Aucun budget n'a été supprimé");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteBudget(budget.id);
    if (result != 0) {
      _showAlertDialog('Statut', 'Budget supprimé');
    } else {
      _showAlertDialog('Statut', "Une erreur s'est produite lors de la suppression de budget");
    }
  }

}