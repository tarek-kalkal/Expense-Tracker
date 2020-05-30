class Item {

  int _id;
  String _title;
  double _value;
  String _date;
  int _bid ;

  Item(this._title, this._date, [this._value ,this._id ,this._bid ]);

  Item.withId(this._id, this._title, this._date, this._value , this._bid);

  int get id => _id;

  String get title => _title;

  double get value => _value;

  String get date => _date;

  int get bid => _bid ;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }

  set value(double newValue) {
    //if (newDescription.length <= 255) {
    this._value = newValue;
    //}
  }

  set bid(int newBid) {
    this._bid = newBid;

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
    map['value'] = _value;
    map['bid'] = _bid;
    map['date'] = _date;

    return map;
  }

  // Extract a Budget object from a Map object
  Item.fromMapObject(Map<String, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._value = map['value'];
    this._bid = map['bid'] ;
    this._date = map['date'];
  }
}