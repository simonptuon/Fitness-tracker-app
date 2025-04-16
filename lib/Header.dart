import 'package:flutter/material.dart';

class Header extends StatelessWidget{
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text("Sign Up", style: TextStyle(color: Colors.white, fontSize: 40),),
          ),
          SizedBox(height: 10,),
          Center(
            child: Text("8", style: TextStyle(color: Colors.white, fontSize: 10),),
          )
        ],
      ),
    );
  }
}