import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoDoItem extends StatelessWidget{
  String _itemName;
  String _dateCreated;
  int _id;

  NoDoItem(this._itemName,this._dateCreated);

  NoDoItem.map(dynamic obj){
    _itemName=obj["itemName"];
    _dateCreated=obj["dateCreated"];
    _id=obj["id"];
  }

  String get itemName=> _itemName;
  String get dateCreated=>_dateCreated;
  int get id=>_id;

  Map<String,dynamic> toMap(){
    var map=Map<String,dynamic>();
    map["itemName"]=_itemName;
    map["dateCreated"]=_dateCreated;
    if(_id!=null){
      map["id"]=_id;
    }

    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:EdgeInsets.all(8.0),
      child:Row(
        crossAxisAlignment:CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
                Text(
                  '$_itemName',
                  style: TextStyle(
                    color:Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize:16.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top:5.0),
                  child:Text(
                    "Created On: $_dateCreated",
                    style: TextStyle(
                      color:Colors.white70,
                      fontSize:14.5,
                      fontStyle:FontStyle.italic,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}