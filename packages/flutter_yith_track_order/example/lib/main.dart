import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_yith_track_order/flutter_yith_track_order.dart';

void main() {
  runApp(const MyApp());
}

Widget _defaultTransitionsBuilder(
    BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  return child;
}

Future<dynamic> getTrackOrder(Map<String, dynamic>? data) {
  Completer<dynamic> completer = Completer<dynamic>();

  // Simulating an asynchronous operation
  Future.delayed(const Duration(seconds: 2), () {
    // Completing the future with the result
    if (data != null && data["email"] == "demo@gmail.com" && data["order_id"] == "123") {
      completer.complete({
        "message":
            "Your order has been shipped by BigShip. Your track code is <span id='textToCopy'>13090312463871</span>.\r\n<br />\r\n<button id=\"copyButton\" >Copy Tracking Code </button>",
        "url": "https://app.bigship.in/shipment-tracking",
        "data": {
          "tracking_code": "13090312463871",
          "tracking_postcode": "",
          "carrier_id": "BIGSHIP",
          "pickup_date": "2024-03-09",
          "estimated_delivery_date": ""
        }
      });
    } else {
      completer.complete({"error": "Error get"});
    }
  });

  // Returning the future
  return completer.future;
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const ViewTest(),
    );
  }
}

class ViewTest extends StatelessWidget {
  const ViewTest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Yith track order example")),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
                pageBuilder: (context, __, ___) {
                  return Scaffold(
                    appBar: AppBar(
                      title: const Text("Demo"),
                    ),
                    body: SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                      child: FlutterYithTrackOrderWidget(
                        data: {
                          "orderData": const {
                            "id": 3255,
                            "billing": {"email": "demo@gmail.com"}
                          },
                          "translate": (String key, [Map<String, String>? options]) => key,
                          "baseURL": "https://appcheap-demo.shop/wp-json"
                        },
                      ),
                    ),
                  );
                },
                transitionsBuilder: _defaultTransitionsBuilder),
          ),
          child: const Text("Click"),
        ),
      ),
    );
  }
}
