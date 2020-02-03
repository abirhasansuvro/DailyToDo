import 'package:flutter/material.dart';

import './notodo_screen.dart';

class Home extends StatelessWidget{
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: Text('Not To-Do App'),
        backgroundColor: Colors.black54,
      ),
      body: NoToDoScreen(),
    );
  }
}