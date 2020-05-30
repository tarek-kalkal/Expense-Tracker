class Budget {

  int _id;
  String _title;
  double _initial;
  String _date;
  double _rest;



  Budget(this._title, this._date, [this._initial, this._rest]);

  Budget.withId(this._id, this._title, this._date, this._initial, [this._rest]);

  int get id => _id;

  String get title => _title;

  double get initial => _initial;

  double get rest => _rest;

  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set initial(double newInitial) {
    //if (newDescription.length <= 255) {
    this._initial = newInitial;
    //}
  }

  set rest(double newRest) {
    //if (newRest >= 1 && newRest <= 2) {
    this._rest = newRest;
    //}
  }

  set date(String newDate) {
    this._date = newDate;
  }

  // Convert a Budget object into a Map object
  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['initial'] = _initial;
    map['rest'] = _rest;
    map['date'] = _date;

    return map;
  }

  // Extract a Budget object from a Map object
  Budget.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._initial = map['initial'];
    this._rest = map['rest'];
    this._date = map['date'];
  }
}