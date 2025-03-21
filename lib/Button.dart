import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(height: 5), // Adjust the height to move the button up
        GestureDetector(
          onTap: () {
            // Navigate to login screen
          },
          child: Text(
            "Go to Login",
            style: TextStyle(
              color: Colors.blue,
              fontSize: 14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        SizedBox(height: 10), // Add some space between the buttons
        Container(
          height: 50,
          margin: EdgeInsets.symmetric(horizontal: 50),
          decoration: BoxDecoration(
            color: Colors.grey[500],
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
