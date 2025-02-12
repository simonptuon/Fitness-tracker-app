import 'package:flutter/material.dart';

const Color textColor = Color(0xFF1E1E1E);

class Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Fitness You Wanna Have",
              style: TextStyle(
                color: textColor,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
          ),
          SizedBox(height: 10),
          Center(
            child: Image.asset(
              'assets/img.png',
              width: 400,
              height: 400,
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}