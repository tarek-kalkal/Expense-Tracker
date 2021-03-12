import 'dart:io';

import 'package:budgets/models/Budget.dart';
import 'package:budgets/models/Item.dart';
import 'package:budgets/utils/csvGenerator.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {

  static DatabaseHelper _databaseHelper;    // Singleton DatabaseHelper
  static Database _database;                // Singleton Database

  String budgetTable = 'budget_table';
  String colId = 'id';
  String colTitle = 'title';
  String colInitial = 'initial';
  String colRest = 'rest';
  String colDate = 'date';

  String itemTable = 'item_table';
  String coltId = 'id';
  String coltTitle = 'title';
  String coltValue = 'value';
  String coltDate = 'date';
  String coltBid = 'bid';


  DatabaseHelper._createInstance(); // Named constructor to create instance of DatabaseHelper

  factory DatabaseHelper() {

    if (_databaseHelper == null) {
      _databaseHelper = DatabaseHelper._createInstance(); // This is executed only once, singleton object
    }
    return _databaseHelper;
  }

  Future<Database> get database async {

    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  Future<Database> initializeDatabase() async {
    // Get the directory path for both Android and iOS to store database.
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'appdatabase.db';

    // Open/create the database at a given path
    var appdatabase = await openDatabase(path, version: 1, onCreate: _createDb);
    return appdatabase;
  }

  void _createDb(Database db, int newVersion) async {

    await db.execute('CREATE TABLE $budgetTable($colId INTEGER PRIMARY KEY AUTOINCREMENT, $colTitle TEXT, '
        '$colRest DOUBLE, $colInitial DOUBLE, $colDate TEXT)');

    await db.execute('CREATE TABLE $itemTable($coltId INTEGER PRIMARY KEY AUTOINCREMENT , $coltBid INTEGER, $coltTitle TEXT, '
        '$coltValue DOUBLE,  $coltDate TEXT)');

  }

  // Fetch Operation: Get all note objects from database
  Future<List<Map<String, dynamic>>> getBudgetMapList() async {
    Database db = await this.database;

//		var result = await db.rawQuery('SELECT * FROM $noteTable order by $colPriority ASC');
    var result = await db.query(budgetTable/*, orderBy: '$colPriority ASC'*/);
    return result;
  }

  Future<List<Map<String, dynamic>>> getItemMapList(int bId) async {
    Database db = await this.database;

    var result = await db.rawQuery('SELECT * FROM $itemTable WHERE $coltBid = $bId' );
    //	var result = await db.query(itemTable /*, orderBy: '$colPriority ASC'*/);
    return result;
  }

  // Insert Operation: Insert a Note object to database
  Future<int> insertBudget(Budget budget) async {
    Database db = await this.database;
    var result = await db.insert(budgetTable, budget.toMap());
    return result;
  }

  Future<int> insertItem(Item item) async {
    Database db = await this.database;
    var result = await db.insert(itemTable, item.toMap());
    return result;
  }

  // Update Operation: Update a Note object and save it to database
  Future<int> updateBudget(Budget budget) async {
    var db = await this.database;
    var result = await db.update(budgetTable, budget.toMap(), where: '$colId = ?', whereArgs: [budget.id]);
    return result;
  }

  Future<int> updateItem(Item item) async {
    var db = await this.database;
    var result = await db.update(itemTable, item.toMap(), where: '$coltId = ?', whereArgs: [item.id]);
    return result;
  }

  // Delete Operation: Delete a Note object from database
  Future<int> deleteBudget(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $budgetTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteItem(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemTable WHERE $colId = $id');
    return result;
  }

  Future<int> deleteLastItem() async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemTable WHERE $coltId = last_insert_rowid()');
    return result;
  }

  Future<int> deleteItems(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $itemTable WHERE $coltBid = $id');
    return result;
  }



  // Get number of Note objects in database
  Future<int> getBCount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $budgetTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  Future<int> getICount() async {
    Database db = await this.database;
    List<Map<String, dynamic>> x = await db.rawQuery('SELECT COUNT (*) from $itemTable');
    int result = Sqflite.firstIntValue(x);
    return result;
  }

  // Get the 'Map List' [ List<Map> ] and convert it to 'Note List' [ List<Note> ]
  Future<List<Budget>> getBudgetList() async {

    var budgetMapList = await getBudgetMapList(); // Get 'Map List' from database
    int count = budgetMapList.length;         // Count the number of map entries in db table

    List<Budget> budgetList = List<Budget>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      budgetList.add(Budget.fromMapObject(budgetMapList[i]));
    }

    return budgetList;
  }

  Future<List<Item>> getItemList(int bId) async {

    var itemMapList = await getItemMapList(bId); // Get 'Map List' from database
    int count = itemMapList.length;         // Count the number of map entries in db table

    List<Item> itemList = List<Item>();
    // For loop to create a 'Note List' from a 'Map List'
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMapObject(itemMapList[i]));
    }

    return itemList;
  }

  Future calculateTotal(int bid) async {
    var db = await this.database;
    var result = await db.rawQuery("SELECT SUM(value) as Total FROM $itemTable WHERE $coltId = $bid ");
    print(result.toList());
    return result.toString() ;

  }

  Future saveBudgetsToCsv () async {
    var db = await this.database ;
    var result = await db.query('budget_table');

    var csv = mapListToCsv(result);


    /// Write to a file
    /// /getApplicationDocumentsDirectory
    final directory = await getExternalStorageDirectory();
    final pathOfTheFileToWrite = directory.path + "/Budgets.csv";
    File file =  File(pathOfTheFileToWrite);
    file.writeAsString(csv);
  }

  ///////////////////////////////////////////////////////

  Future saveItemsToCsv (Budget budget) async {
    int bId = budget.id ;
    String bName = budget.title ;

    var db = await this.database ;
   // var result = await db.query('item_table');
    var result = await db.rawQuery('SELECT * FROM $itemTable WHERE $coltBid = $bId' );

    var csv = mapListToCsv(result);


    /// Write to a file
    /// /getApplicationDocumentsDirectory
    final directory = await getExternalStorageDirectory();
    final pathOfTheFileToWrite = directory.path + "/" + "$bName" + " Items.csv";
    File file =  File(pathOfTheFileToWrite);
    file.writeAsString(csv);
  }


}