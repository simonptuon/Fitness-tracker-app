import 'package:flutter/material.dart';

import '../widgets/Header.dart';
import '../widgets/inputWrapper.dart';

const Color backgroundColor = Color(0xFF1c2e65);
const Color backgroundColor2 = Color(0xFF4e6cbb);

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [backgroundColor, backgroundColor2],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 35),
            Header(),
            Padding(
              padding: EdgeInsets.only(bottom: 50), // Moves white box up
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.85,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.all(Radius.circular(60)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.6),
                        spreadRadius: 5,
                        blurRadius: 40,
                        offset: Offset(10, 40),
                      ),
                    ],
                  ),
                  child: InputWrapper(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
