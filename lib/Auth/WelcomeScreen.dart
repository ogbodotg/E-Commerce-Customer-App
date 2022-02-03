import 'package:ahia/Auth/OnBoardScreen.dart';
import 'package:ahia/Helper/Constant.dart';
import 'package:ahia/Pages/Map_Screen.dart';
import 'package:ahia/Pages/SetDeliveryAddress.dart';
import 'package:ahia/Providers/Auth_Provider.dart';
import 'package:ahia/Providers/Location_Provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome-screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    bool _isValidPhoneNumber = false;
    var _phoneNumberController = TextEditingController();

    void showBottomSheet(context) {
      showModalBottomSheet(
        context: context,
        builder: (context) =>
            StatefulBuilder(builder: (context, StateSetter myState) {
          return Container(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: auth.error == 'Invalid OTP' ? true : false,
                      child: Container(
                          child: Column(
                        children: [
                          Text('${auth.error} - Please try again',
                              style: TextStyle(color: Colors.red)),
                        ],
                      )),
                    ),
                    SizedBox(height: 5),
                    Text(
                      'LOGIN',
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87),
                    ),
                    Text('Enter your phone number to proceed',
                        style: TextStyle(fontSize: 14)),
                    SizedBox(
                      height: 20,
                    ),
                    TextField(
                      decoration: InputDecoration(
                        prefixText: '+234',
                        labelText:
                            'Enter your phone number (Eg. +2348030000000)',
                      ),
                      autofocus: true,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      controller: _phoneNumberController,
                      onChanged: (value) {
                        if (value.length == 10) {
                          myState(() {
                            _isValidPhoneNumber = true;
                          });
                        } else {
                          myState(() {
                            _isValidPhoneNumber = false;
                          });
                        }
                      },
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: AbsorbPointer(
                            absorbing: _isValidPhoneNumber ? false : true,
                            child: FlatButton(
                              onPressed: () {
                                myState(() {
                                  auth.loading = true;
                                });
                                String number =
                                    '+234${_phoneNumberController.text}';
                                auth
                                    .verifyPhoneNumber(
                                  context: context,
                                  number: number,
                                )
                                    .then((value) {
                                  _phoneNumberController.clear();
                                  auth.loading = false;
                                });
                              },
                              color: _isValidPhoneNumber
                                  ? Theme.of(context).primaryColor
                                  : Colors.grey,
                              child: auth.loading
                                  ? CircularProgressIndicator(
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                          Colors.white),
                                    )
                                  : Text(
                                      _isValidPhoneNumber
                                          ? 'Continue'
                                          : 'Enter Phone Number',
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 14),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    )
                  ]),
            ),
          );
        }),
      ).whenComplete(() {
        setState(() {
          auth.loading = false;
          _phoneNumberController.clear();
        });
      });
    }

    // final locationData = Provider.of<LocationProvider>(context, listen: false);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Stack(children: [
          Positioned(
              right: 0.0,
              top: 10.0,
              child: FlatButton(
                child: Text(
                  'Skip',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 20),
                ),
                onPressed: () {},
              )),
          Column(children: [
            Expanded(child: OnBoardScreen()),
            Text(
              'Start ordering from shops around you today',
            ),
            SizedBox(height: 20),
            FlatButton(
              color: Theme.of(context).primaryColor,
              child:
                  // locationData.loading
                  //     ? CircularProgressIndicator(
                  //         valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  //       )
                  //     :
                  Text('Set Delivery Location',
                      style: TextStyle(color: Colors.white)),
              onPressed: () async {
                Navigator.pushNamed(context, SetDeliveryLocation.id);
                // setState(() {
                //   locationData.loading = true;
                // });
                // await locationData.getCurrentPosition();
                // if (locationData.permissionAllowed == true) {
                //   Navigator.pushReplacementNamed(context, MapScreen.id);
                //   setState(() {
                //     locationData.loading = false;
                //   });
                // } else {
                //   setState(() {
                //     locationData.loading = false;
                //   });
                //   print('permission not allowed');
                // }
              },
            ),
            SizedBox(height: 20),
            FlatButton(
              child: RichText(
                text: TextSpan(
                    text: 'Already a customer? ',
                    style: TextStyle(color: Colors.black87),
                    children: [
                      TextSpan(
                          text: ' Login',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor))
                    ]),
              ),
              onPressed: () {
                setState(() {
                  auth.screen = 'Login';
                });
                showBottomSheet(context);
              },
            )
          ]),
        ]),
      ),
    );
  }
}
