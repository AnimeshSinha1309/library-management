// Copyright 2018 The SevenRE Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libmate/views/drawer.dart';
import 'package:libmate/utils/utils.dart';

class RazorPayPage extends StatefulWidget {
  @override
  _RazorPayPageState createState() => new _RazorPayPageState();
}

class _RazorPayPageState extends State<RazorPayPage> {
  String RAZOR_KEY;
  int totalAmount = 0;
  Razorpay _razorpay;

  void getKey() async {
    RAZOR_KEY = (await readConfig())["razorkey"];
  }

  @override
  void initState() {
    super.initState();
    getKey();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  void dispose() {
    //TODO: implement dispose
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': RAZOR_KEY,
      'amount': totalAmount * 100,
      'name': "Andaman College Library",
      'description': 'Fine payment',
      'prefill': {'contact': '', 'email': ''},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse, response) {
    Fluttertoast.showToast(msg: "SUCCESS: " + response.paymentId);
  }

  void _handlePaymentError(PaymentErrorResponse, response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + "-" + response.message);
  }

  void _handleExternalWallet(ExternalWalletResponse, response) {
    Fluttertoast.showToast(msg: "EXTERNAL WALLET: " + response.walletName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Pay Fine')),
        drawer: AppDrawer(),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            LimitedBox(
              maxWidth: 150.0,
              child: Text("Your payment amount is INR $totalAmount"),
            ),
            SizedBox(
              height: 15.0,
            ),
            RaisedButton(
              child: Text('Make Payment',
                  style: TextStyle(
                      color: Colors.pink,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold)),
              onPressed: () {
                openCheckout();
              },
            )
          ],
        )));
  }
}
