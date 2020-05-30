import 'package:budgets/Activities/AddItem.dart';
import 'package:budgets/Activities/itemDialog.dart';
import 'package:budgets/models/Budget.dart';
import 'package:budgets/models/Item.dart';
import 'package:budgets/utils/CustomAlertDialog.dart';
import 'package:budgets/utils/database_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:getflutter/components/avatar/gf_avatar.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

class Expenses extends StatefulWidget {
  String title;
  Budget budget;

  Expenses(Budget budget) {
    this.budget = budget;
  }

  @override
  State<StatefulWidget> createState() {
    return ExpensesState(budget);
  }
}

class ExpensesState extends State<Expenses> {
  Budget budget;

  ExpensesState(Budget budget) {
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

  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            debugPrint('FAB Clicked');
            push(budget.id, Item('', ''), 'Ajouter un Budget');
          },
          tooltip: 'Ajouter un élément pour ce budget',
          child: Icon(Icons.add) ,
          backgroundColor: Colors.grey,
        ) ,
        body:

      Container(
      child: Padding(
          child: getItemListView(),
          padding: EdgeInsets.only(
            top: 10,
          )),

//         FloatingActionButton(
//          onPressed: () {
//            debugPrint('FAB Clicked');
//            push(budget.id, Item('', ''), 'Add Budget');
//          },
//          tooltip: 'Add Item for this Budget',
//          child: Icon(Icons.add) ,
//          backgroundColor: Colors.red,
//        ),
    ) );
  }

  Future<Widget> _calcTotal(int bid) async {
    var total = (await databaseHelper.calculateTotal(bid))[0]['Total'];
    //var total = (await db.calculateTotal())[0]['Total'];
    print(total);
    debugPrint(total);
    rest = budget.initial - _total.toDouble();
    return Text(total);
    //setState(() => _total = total);
  }

  ListView getItemListView() {
    TextStyle titleStyle = Theme.of(context).textTheme.subhead;
    _updateListView();

    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int position) {
        return Card(

          color: background,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
          elevation: 0.4,
          child: ListTile(
            leading: Image(
              image: AssetImage('images/money-bag.png'),
              width: 40,
              height: 40,
            )

//            CircleAvatar(
//              radius: 25,
//              backgroundColor: background,
//              backgroundImage: AssetImage('images/cost.png')
////              Icon(
////                Icons.minimize,
////                size : 20 ,
////                color: Colors.white,
////              ),
//            )
            ,
            title: Text(
              this.itemList[position].title,
              // + " : " + this.itemList[position].value.toString() +" \$" ,
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Open Sans',
                  fontSize: 20),
            ),
            subtitle: Text(
              this.itemList[position].date,
              style: TextStyle(fontStyle: FontStyle.italic, fontSize: 13),
            ),
            trailing: Text(
              "-" + this.itemList[position].value.toString() + " \$",
              style: TextStyle(
                  color: Colors.red[500],
                  fontFamily: 'Open Sans',
                  fontWeight: FontWeight.w600,
                  fontSize: 20),
            ),
            onTap: () {
              debugPrint("ListTile Tapped");
              push(budget.id, this.itemList[position],
                  this.itemList[position].title);
            },
          ),
        );
      },
    );
  }

  void _updateListView() {
    final Future<Database> dbFuture = databaseHelper.initializeDatabase();
    dbFuture.then((database) {
      Future<List<Item>> itemListFuture = databaseHelper.getItemList(budget.id);
      itemListFuture.then((itemList) {
        if (this.mounted){
        setState(() {
          this.itemList = itemList;
          this.count = itemList.length;
        });
        }
      });
    });
  }

  void push(int bid, Item item, String title,) async {
   // bool result =
        //await Navigator.push(context, MaterialPageRoute(builder: (context) {

    if (item.value == null) {
      item.value = 0;
    }

    Navigator.of(context).push(
      PageRouteBuilder(
          pageBuilder: (context, _, __) => _editItemDialod(budget, item, title) ,
          opaque: false),
    );
    _updateListView();



//     return _editItemDialod(budget, item, title);
//    ));
//    if (result = true) {
//      _updateListView();
//    }
  }

  void moveToLastScreen() {
    Navigator.pop(context);
  }

  void _showSnackBar(BuildContext context, String s) {
    final snackBar = SnackBar(content: Text(s));
    Scaffold.of(context).showSnackBar(snackBar);
  }

  void _showAlertDialog(String title, String message) {
    AlertDialog alertDialog = AlertDialog(
      title: Text(title),
      content: Text(message),
    );

    showDialog(context: context, builder: (_) => alertDialog);
  }

  _editItemDialod(Budget budget, Item item, String title) {
    TextEditingController titleController = TextEditingController();
    TextEditingController valueController = TextEditingController();

    titleController.text = item.title;

    valueController.text = item.value.toString();

    return CustomAlertDialog(

        content: new Container(
            width: 250.0,
            height: 270.0,
            decoration: new BoxDecoration(
              shape: BoxShape.rectangle,
              color: const Color(0xFFFFFF),
              borderRadius: new BorderRadius.all(new Radius.circular(32.0)),
            ),
            child: ListView(
              children: <Widget>[
                Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: TextField(
                      controller: titleController,
                      onChanged: (value) {
                        updateTitle(item, titleController.text);
                        debugPrint('Something changed in Title Text Field');
                      },
                      decoration: InputDecoration(
                          labelText: "Titre de l'élément",
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15.0))),
                    )),
                Padding(
                    padding:
                        EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
                    child: TextField(
                      keyboardType: TextInputType.number,
                      controller: valueController,
                      onChanged: (value) {
                        updateInitial(item, valueController.text);
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
                                    borderRadius: new BorderRadius.circular(18.0),
                                    side: BorderSide(color: Colors.blueGrey[500])),
                                child: Text(
                                  'Supprimer',
                                  style: TextStyle(color: Colors.blueGrey[500]),
                                  textScaleFactor: 1.7,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _delete(item);
                                    debugPrint("Delete button clicked");
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
                            color: Colors.blueGrey[500],
                            shape: new RoundedRectangleBorder(
                                borderRadius: new BorderRadius.circular(10.0),
                               // side: BorderSide(color: Colors.black)
                               ),
                            child: Text(
                              'Enregistrer',
                              textScaleFactor: 1.7,
                              style: TextStyle(color: Colors.white),
                            ),
                            onPressed: () {
                              setState(() {
                                _save(titleController.text, item,
                                    valueController.text);
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
  void updateTitle(Item item, String title) {
    item.title = title;
    debugPrint("item title $title ");
  }

  // Update the description of Note object
  void updateInitial(Item item, String value) {
    double daltaValue = item.value - double.parse(value);
    //item.value = double.parse(valueController.text) ;
  }

  void _save(String title, Item item, String value) async {
    Navigator.pop(context);
    item.bid = budget.id;
    item.date = DateFormat.yMMMd().format(DateTime.now());

    int result;
    int resultb;
    if (item.id != null) {
      // Case 1: Update operation
      double daltaValue = item.value - double.parse(value);

      if (daltaValue > 0) {
        budget.rest = budget.rest + daltaValue.abs();
        item.value = double.parse(value);
      } else if (daltaValue < 0) {
        budget.rest = budget.rest - daltaValue.abs();
        item.value = double.parse(value);
      } else {
        budget.rest = budget.rest;
        item.value = double.parse(value);
      }
      resultb = await databaseHelper.updateBudget(budget);
      result = await databaseHelper.updateItem(item);
    } else {
      // Case 2: Insert Operation
      if (title == "") {
        return;
      } else {
        item.value = double.parse(value);

        debugPrint("hhhhh");
        budget.rest = budget.rest - item.value;
        resultb = await databaseHelper.updateBudget(budget);
        result = await databaseHelper.insertItem(item);
      }
    }

    if (result != 0) {
      // Success
      _showAlertDialog('Statu', 'Élément enregistré');
    } else {
      // Failure
      _showAlertDialog('Statu', "Problème d'enregistrement de l'élément");
    }
  }

  void _delete(Item item) async {
    Navigator.pop(context);

    // Casev 1: If user is trying to delete the NEW NOTE i.e. he has come to
    // the detail page by pressing the FAB of NoteList page.
    if (item.id == null) {
      _showAlertDialog('Statu', "Aucun élément n'a été supprimé");
      return;
    }

    // Case 2: User is trying to delete the old note that already has a valid ID.
    int result = await databaseHelper.deleteItem(item.id);
    budget.rest = budget.rest + item.value;
    await databaseHelper.updateBudget(budget);
    if (result != 0) {
      _showAlertDialog('Statu', 'Élément supprimé');
    } else {
      _showAlertDialog('Statu', "Une erreur s'est produite lors de la suppression de l'élément");
    }
  }
}
