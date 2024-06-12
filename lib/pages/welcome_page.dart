// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:madridmug_flutter/pages/login_screen.dart';
import 'package:madridmug_flutter/pages/register_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              "https://images.pexels.com/photos/11071362/pexels-photo-11071362.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1"),
            fit: BoxFit.fill,          
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Madrid Mug title
            Column(
              children: [
                Container(
                margin: EdgeInsets.only(top: 160),
                child: Text(
                  "Madrid Mug",
                  style: TextStyle(color: Color(0xFF6C7072), fontSize: 24, fontWeight: FontWeight.w600),
                ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 5),
                  child: Text(
                    "Roast n'\nenjoy coffee",
                    style: TextStyle(color: Color(0xFFFFFFFF), fontSize: 32, fontWeight: FontWeight.w600),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          SignUpScreen(),
                      ));
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 100),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFFFFF),
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text(
                      "Start Roasting",
                      style: TextStyle(color: Color(0xFF000000), fontSize: 18, fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                          LoginScreen() ,
                      ));
                  },
                  child: Container(
                    margin: EdgeInsets.only(bottom: 60, top: 10),
                    child: Text(
                      "Already have an account?",
                      style: TextStyle(color: Color(0xFFFFC562), fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
