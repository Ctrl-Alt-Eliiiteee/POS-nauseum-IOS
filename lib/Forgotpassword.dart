import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'Login.dart';

class ForgotPassword extends StatefulWidget {
  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

String _emailID = '';
bool _isLoading = false;
class _ForgotPasswordState extends State<ForgotPassword> {
  @override
  void initState() {
    // TODO: implement initState
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
          children :[
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
                        child: Text("Forgot Password",
                            style: TextStyle(
                                fontSize: w * 0.1,
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                      ),
                      SizedBox(height: h * 0.08),
                      Text(
                        "Mail id",
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
                            borderRadius: BorderRadius.all(Radius.circular(10))),
                        child: TextFormField(
                          keyboardType: TextInputType.emailAddress,
                          decoration: InputDecoration(border: InputBorder.none),
                          onChanged: (status) {
                            _emailID = status;
                          },
                        ),
                      ),
                      SizedBox(
                        height: h * 0.01,
                      ),
                      Text(
                        "* In order to reset your password, an email will be sent to the above filled ID which will contain a link to change the password",
                        style: TextStyle(
                          color: Color(0xff272d25),
                          fontWeight: FontWeight.w300,
                          fontSize: w * 0.04,
                        ),
                      ),
                      SizedBox(height: h * 0.04),
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
                              "Confirm",
                              style: TextStyle(
                                  color: Colors.white, fontSize: h * 0.03),
                            ))),
                        onPressed: () async {
                          setState(() {
                            _isLoading = true;
                          });
                          if (_emailID.isEmpty) {
                            showSnackBar("Please enter a valid mail id");
                          } else {
                            try {
                              var response = await Dio().post(
                                  'https://pos-emetrics-server.herokuapp.com/api/v1/authenticate/forgotPassword',
                                  data: {
                                    'email': _emailID.trim(),
                                  });
                              print(response);
                              if(response.data['msg'].contains('Api working')) {
                                showSnackBar("Email has been sent");
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LoginPage()));
                              }
                              else {
                                showSnackBar("Try Again Later with Valid EmailID");
                              }
                            }
                            catch(e){
                              setState(() {
                                _isLoading = false;
                              });
                            }
                          }
                          setState(() {
                            _isLoading = false;
                          });
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
        ));
  }

  void showSnackBar(e) {
    final snackbar = SnackBar(content: Text(e));
    ScaffoldMessenger.of(context).showSnackBar(snackbar);
  }
}
