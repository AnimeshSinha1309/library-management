// Copyright 2018 The SevenRE Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/services.dart';
import 'package:libmate/views/drawer.dart';


class RazorPayPage extends StatefulWidget {
  @override
  _RazorPayPageState createState() => new _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  int totalAmount = 0;
  Razorpay _razorpay;
  @override
  void initState(){
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  @override
  void dispose(){
    //TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }
  void openCheckout() async{
    var options = {
      'key': 'rzp_test_U4H7R8ZUFz2iHt',
      'amount': totalAmount*100,
      'name': "Andaman College Library",
      'description': 'Test Payment fine',
      'prefill': {'contact':'','email':''},
      'external':{
        'wallets': ['paytm']
      }
    };
    try{
      _razorpay.open(options);
    }
    catch(e){
      debugPrint(e);
    }
  }
  void _handlePaymentSuccess(PaymentSuccessResponse,response){
    Fluttertoast.showToast(msg: "SUCCESS: "+ response.paymentId);
  }
  void _handlePaymentError(PaymentErrorResponse,response){
    Fluttertoast.showToast(msg: "ERROR: "+ response.code.toString()+"-"+response.message);
  }
  void _handleExternalWallet(ExternalWalletResponse,response){
    Fluttertoast.showToast(msg: "EXTERNAL WALLET: "+ response.walletName);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text(
                'In App Payments In flutter'
            )
        ),
        drawer: AppDrawer(),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                LimitedBox(
                  maxWidth: 150.0,
                  child: TextField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        hintText: 'Please enter amount'
                    ),
                    onChanged: (value){
                      setState(() {
                        totalAmount = num.parse(value);
                      });
                    },
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
                RaisedButton(
                  child: Text('Make Payment',
                      style: TextStyle(
                          color: Colors.pink,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold
                      )
                  ), onPressed: (){
                  openCheckout();
                },
                )
              ],
            )
        )
    );

  }
}