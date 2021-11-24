// @dart=2.9
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

bool _isLoading = false;

class _SignUpPageState extends State<SignUpPage> {
  String username = '', password1 = '', password2 = '';
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Color(0xffc1e4ba),
      body: Stack(
        children: [
          AbsorbPointer(
            absorbing: _isLoading,
            child: Center(
              child: Container(
                width: w,
                padding: EdgeInsets.only(left: w * 0.07, right: w * 0.07),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text("POS eMetrics",
                            style: TextStyle(
                                fontSize: w * 0.12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: h * 0.08),
                      Text(
                        "User id",
                        style: TextStyle(
                          color: Color(0xff272d25),
                          fontWeight: FontWeight.w300,
                          fontSize: w * 0.05,
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(border: InputBorder.none),
                          onChanged: (status) {
                            username = status;
                          },
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Text(
                        "Password",
                        style: TextStyle(
                          color: Color(0xff272d25),
                          fontWeight: FontWeight.w300,
                          fontSize: w * 0.05,
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(border: InputBorder.none),
                          onChanged: (status) {
                            password1 = status;
                          },
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Text(
                        "Confirm Password",
                        style: TextStyle(
                          color: Color(0xff272d25),
                          fontWeight: FontWeight.w300,
                          fontSize: w * 0.05,
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      Container(
                        padding: EdgeInsets.only(left: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          obscureText: true,
                          decoration: InputDecoration(border: InputBorder.none),
                          onChanged: (status) {
                            password2 = status;
                          },
                        ),
                      ),
                      SizedBox(height: h * 0.02),
                      TextButton(
                        style: TextButton.styleFrom(padding: EdgeInsets.all(0)),
                        child: Container(
                            height: h * 0.05,
                            width: w * 0.9,
                            decoration: BoxDecoration(
                                color: Color(0xff485e43),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                            child: Center(
                                child: Text(
                              "Sign Up",
                              style: TextStyle(
                                  color: Colors.white, fontSize: h * 0.03),
                            ))),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (password1.length != 0 &&
                              password1 == password2 &&
                              username.length != 0 &&
                              password1.length >= 6) {
                            try {
                              var response = await Dio().post(
                                  'https://pos-emetrics-server.herokuapp.com/api/v1/authenticate/signUp',
                                  data: {
                                    'email': username,
                                    'password': password1,
                                  });
                              print(response);
                              if(response.data['msg'].contains('User created')) {
                                await FirebaseFirestore.instance
                                    .collection("Details")
                                    .doc(username.substring(
                                    0, username.indexOf('@')))
                                    .set({
                                  'Username': username,
                                });

                                showsnackbar('Verification Email Sent on the provided Email ID');
                                setState(() {
                                  _isLoading = false;
                                });

                                Navigator.pop(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }
                              else {
                                showsnackbar('Email Invalid OR Aleady taken');
                              }
                            } catch (e) {
                              setState(() {
                                _isLoading = false;
                              });
                              print(e);
                            }
                          } else {
                            setState(() {
                              _isLoading = false;
                            });
                            if (password1 != password2)
                              showsnackbar('Passwords don\'t match');
                            else
                              showsnackbar('Password too short');
                          }
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
          _isLoading
              ? Container(
                  height: h,
                  width: w,
                  color: Colors.black.withOpacity(0.2),
                  child: Center(
                    child: CircularProgressIndicator(
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.green),
                    ),
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  void showsnackbar(String s) {
    final snackbar = SnackBar(content: Text(s));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
