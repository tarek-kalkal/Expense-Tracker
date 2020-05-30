import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:budgets/models/Budget.dart';
import 'package:budgets/utils/database_helper.dart';

class BudgetDetails extends StatefulWidget {
  final String appbarTitle;
  final Budget budget;

  BudgetDetails(this.budget, this.appbarTitle);

  @override
  State<StatefulWidget> createState() {
    return BudgetDetailsState(this.budget, this.appbarTitle);
  }
}

class BudgetDetailsState extends State<BudgetDetails> {
  String appbarTitle;
  Budget budget;

  DatabaseHelper helper = DatabaseHelper();

  BudgetDetailsState(this.budget, this.appbarTitle);

  TextEditingController titleController = TextEditingController();
  TextEditingController initialController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    titleController.text = budget.title;

    initialController.text = budget.initial.toString();
    return WillPopScope(
        onWillPop: () {
          // debugPrint('back button is pressed');
          moveToLastScreen();
        },
        child: Scaffold(
          //backgroundColor: Colors.blueGrey[500],
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[500],
            title: Text(appbarTitle,style: TextStyle(color: Colors.white)),
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
              // First element
              /* Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: ListTile(
                    title: DropdownButton(
                        items: _priorities.map((String dropDownStringItem) {
                          return DropdownMenuItem<String>(
                            value: dropDownStringItem,
                            child: Text(dropDownStringItem),
                          );
                        }).toList(),
                        value: getPriorityAsString(note.priority),
                        onChanged: (valueSelectedByUser) {
                          setState(() {
                            updatePriorityAsInt(valueSelectedByUser);
                            debugPrint('User selected $valueSelectedByUser');
                          });
                        }),
                  )),
*/
              Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextField(
                    controller: titleController,
                    onChanged: (value) {
                      updateTitle();
                      debugPrint('Something changed in Title Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'Titre',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15.0))),
                  )),

              Padding(
                  padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                  child: TextField(
                    controller: initialController,
                    onChanged: (value) {
                      updateInitial();
                      debugPrint('Something changed in Initial Text Field');
                    },
                    decoration: InputDecoration(
                        labelText: 'La valeur initiale',
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
                                'Save',
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
                                'Delete',
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
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  // Update the title of Note object
  void updateTitle() {
    budget.title = titleController.text;
  }

  // Update the description of Note object
  void updateInitial() {
    budget.initial = double.parse(initialController.text);
  }

  void _save(String title) async {
    moveToLastScreen();

    budget.date = DateFormat.yMMMd().format(DateTime.now());
    int result;
    if (budget.id != null) {
      // Case 1: Update operation
      result = await helper.updateBudget(budget);
    } else {
      // Case 2: Insert Operation
      if (title == "") {
        return;
      } else {
        budget.rest = budget.initial;
        result = await helper.insertBudget(budget);
      }
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Status', 'Budget Saved ');
    } else {
      // Failure
      _showAlertDialog('Status', 'Problem Saving Budget');
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
    if (budget.id == null) {
      _showAlertDialog('Status', 'No Budget was deleted');
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await helper.deleteBudget(budget.id);
    if (result != 0) {
      _showAlertDialog('Status', 'Budget Deleted Successfully');
    } else {
      _showAlertDialog('Status', 'Error Occured while Deleting Budget');
    }
  }
}