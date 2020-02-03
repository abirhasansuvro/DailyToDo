import 'package:flutter/material.dart';
import 'package:todo_app/model/notodo_item.dart';
import 'package:todo_app/util/database_client.dart';

import '../util/date_formatter.dart';

class NoToDoScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return NoToDoScreenState();
  }

}

class NoToDoScreenState extends State<NoToDoScreen>{
  var db=new DatabaseHelper();
  final TextEditingController _textController=TextEditingController();
  final List<NoDoItem> _itemList=List<NoDoItem>();
  void initState(){
    super.initState();
    _readNoDoList();
  }
  _handleSubmit(String str)async{
    _textController.clear();
    NoDoItem item=NoDoItem(str,dateFormatted());
    int savedId=await db.saveItem(item);
    NoDoItem newItm=await db.getItem(savedId);
    setState(() {
      _itemList.insert(0,newItm);
    });
  }
  deleteNoToDo(int dbid,int index){
    db.deleteItem(dbid);
    setState(() {
      _itemList.removeAt(index);
    });
  }
  _handleUpdatedData(int index,NoDoItem prev){
    setState(() {
      _itemList.removeWhere((element){
        _itemList[index].itemName==prev.itemName;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: <Widget>[
          Flexible(
            child:ListView.builder(
              padding: EdgeInsets.all(8.0),
              reverse: false,
              itemCount: _itemList.length,
              itemBuilder:(_,int index){
                return Card(
                  color: Colors.white10,
                  child: ListTile(
                    title:_itemList[index],
                    onLongPress: ()=>_updateItem(_itemList[index],index),
                    trailing: Listener(
                      key:Key(_itemList[index].itemName),
                      child: Icon(
                        Icons.remove_circle,
                        color: Colors.redAccent,
                      ),
                      onPointerDown:(pointterevent){
                        deleteNoToDo(_itemList[index].id,index);
                      },
                    ),

                  ),
                );
              } ,
            ),
          ),
          Divider(
            height: 1.0,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: "Add Item",
        backgroundColor: Colors.blueAccent,
        child: ListTile(
          title: Icon(Icons.add),
        ),
        onPressed: _showFormDialouge,
      ),
    );
  }
  void _showFormDialouge(){
    var alert=AlertDialog(
      content: Row(
        children: <Widget>[
          Expanded(
            child:TextField(
              controller:_textController,
              autofocus:true,
              decoration:InputDecoration(
                labelText:"Item",
                hintText:"eg. Donot buy books",
                icon:Icon(Icons.note_add),
              ),
            ),
          ),
        ],
      ),
      actions: <Widget>[
        FlatButton(
          onPressed:(){
            _handleSubmit(_textController.text);
          },
          child: Text('Save'),
        ),
        FlatButton(
          onPressed: ()=>Navigator.pop(context),
          child: Text('Cancel'),
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (_){
        return alert;
      }
    );
  }
  _readNoDoList()async{
    List items=await db.getItems();
    items.forEach((item){
      NoDoItem itm=NoDoItem.map(item);
      setState(() {
        _itemList.add(itm);
      });
    });
  }

  _updateItem(NoDoItem item, int index) {
    var alert=AlertDialog(
      title: Text("Update Item"),
      actions: <Widget>[
        FlatButton(
          onPressed:()async{
            NoDoItem updated=NoDoItem.map(
              {'itemName':_textController.text,
              'dateCreated':dateFormatted(),
              "id":item.id
              }
            );
            _handleUpdatedData(index,item);
            await db.updateItem(updated);
            setState(() {
              _readNoDoList();
            });
            Navigator.pop(context);
          },
          child:Text(
            "Update"
          ),
        ),
        FlatButton(
          onPressed:()=>Navigator.pop(context),
          child:Text('Cancel'),
        ),
      ],
      content: Row(
        children:<Widget>[
          Expanded(
            child: TextField(
              controller:_textController,
              autofocus:true,
              decoration:InputDecoration(
                labelText:"Item",
                hintText:"e.g. Drinking unhealthy water",
                icon:Icon(Icons.update),
              ),
            ),
          ),
        ]
      ),
    );
    showDialog(
      context: context,
      builder: (_)=>alert,
    );
  }
}