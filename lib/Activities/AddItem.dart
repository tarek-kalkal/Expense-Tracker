import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:intl/number_symbols_data.dart';
import 'package:budgets/models/Budget.dart';
//import 'package:money/models/Budget.dart';
import 'package:budgets/models/Item.dart';
import 'package:budgets/utils/database_helper.dart';

class Additem extends StatefulWidget {
  final String appbarTitle;
  //final int bi ;
  final Budget budget;
  final Item item;

  Additem(this.budget, this.item, this.appbarTitle);

  @override
  State<StatefulWidget> createState() {
    return AddItemState(this.budget, this.item, this.appbarTitle);
  }
}

class AddItemState extends State<Additem> {
  String appbarTitle;
  //int bid;
  Item item;
  Budget budget;

  DatabaseHelper helperItems = DatabaseHelper();

  AddItemState(this.budget, this.item, this.appbarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController valueController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = item.title;

    valueController.text = item.value.toString();

    return Scaffold(
          backgroundColor: Colors.grey[200],
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[500],
            title: Text(
              "Ajouter un Élément",
              style: TextStyle(color: Colors.white),
            ),
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
              onPressed: () {
                moveToLastScreen();
              },
            ),
            elevation: 10.0,
          ),
          body: ListView(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      updateTitle();
                      debugPrint('Something changed in Title Text Field');
                    },
                    decoration: InputDecoration(

                        labelText: "Titre de l'élément",
                        border: OutlineInputBorder(

                            borderRadius: BorderRadius.circular(15.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: valueController,
                    onChanged: (value) {
                      updateInitial();
                      debugPrint('Something changed in Initial Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Valeur',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  )),
              Padding(
                  padding: EdgeInsets.only(top: 20.0, left: 10.0, right: 10.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                          child: Container(
                            height: 40,
                            child: RaisedButton(
                              color: Colors.blueGrey[500],
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.black)),
                              child: Text(
                                'Enregistrer',
                                textScaleFactor: 1.7,
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  _save(titleController.text);
                                  debugPrint("Save button clicked");
                                });
                              },
                            ),
                          )),
                      Container(
                        width: 5.0,
                      ),
                      Expanded(
                          child: Container(
                            height: 40,
                            child: RaisedButton(
                              color: Colors.grey[200],
                              shape: new RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(18.0),
                                  side: BorderSide(color: Colors.blueGrey[500])),
                              child: Text(
                                'Supprimer',
                                style: TextStyle(color: Colors.blueGrey[500]),
                                textScaleFactor: 1.7,
                              ),
                              onPressed: () {
                                setState(() {
                                  _delete();
                                  debugPrint("Delete button clicked");
                                });
                              },
                            ),
                          )),
                    ],
                  ))
            ],
          ),
        );
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  // Update the title of Note object
  void updateTitle() {
    item.title = titleController.text;
    debugPrint("item title $titleController.text");
  }

  // Update the description of Note object
  void updateInitial() {
    double daltaValue = item.value - double.parse(valueController.text);
    //item.value = double.parse(valueController.text) ;
  }

  void _save(String title) async {
    moveToLastScreen();
    item.bid = budget.id;
    item.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    int resultb;
    if (item.id != null) {
      // Case 1: Update operation
      double daltaValue = item.value - double.parse(valueController.text);

      if (daltaValue > 0) {
        budget.rest = budget.rest + daltaValue.abs();
        item.value = double.parse(valueController.text);
      } else if (daltaValue < 0) {
        budget.rest = budget.rest - daltaValue.abs();
        item.value = double.parse(valueController.text);
      } else {
        budget.rest = budget.rest;
        item.value = double.parse(valueController.text);
      }
      resultb = await helperItems.updateBudget(budget);
      result = await helperItems.updateItem(item);
    } else {
      // Case 2: Insert Operation
      if (title == "") {
        return;
      } else{
        item.value = double.parse(valueController.text);

        debugPrint("hhhhh");
        budget.rest = budget.rest - item.value;
        resultb = await helperItems.updateBudget(budget);
        result = await helperItems.insertItem(item);
      }
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Statu', 'Élément enregistré');
    } else {
      // Failure
      _showAlertDialog('Statu', "Problème d'enregistrement de note");
    }
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );
    showDialog(context: context, builder: (_) => alertDialog);
  }

  void _delete() async {
    moveToLastScreen();

    // Casev 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (item.id == null) {
      _showAlertDialog('Statu', "Aucun élément n'a été supprimé");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helperItems.deleteItem(item.id);
    budget.rest = budget.rest - item.value;
    await helperItems.updateBudget(budget);
    if (result != 0) {
      _showAlertDialog('Statu', 'Élément supprimé');
    } else {
      _showAlertDialog('Statu', "Une erreur s'est produite lors de la suppression de la note");
    }
  }
}