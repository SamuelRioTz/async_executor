import 'dart:developer';

import 'package:async_executor/async_executor.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Async Executor Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  final AsyncExecutor normal = AsyncExecutor();
  final AsyncExecutor custom = AsyncExecutor(loadingMessage: ({
    BuildContext context,
  }) async {
    return await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Material(
                color: Colors.transparent,
                child: Container(
                  height: 60,
                  child: Center(
                    child: CircularProgressIndicator(
                      backgroundColor: Colors.green,
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }, errorMessage: ({
    dynamic error,
    BuildContext context,
  }) async {
    return await showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text("Error"),
          content: Text(
            "$error",
            style: TextStyle(color: Colors.red),
          ),
          actions: [
            FlatButton(
              child: Text("OK"),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
            )
          ],
        );
      },
    );
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Async Executor Demo'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          RaisedButton(
            onPressed: () {
              normal.run(
                  context: context,
                  onExecute: () async {
                    await Future.delayed(Duration(seconds: 3));
                  },
                  onFinish: (value) {
                    log("on finish");
                  });
            },
            child: Text("normal"),
          ),
          RaisedButton(
            onPressed: () {
              normal.run(
                  context: context,
                  onExecute: () async {
                    await Future.delayed(Duration(seconds: 3));
                    int count;
                    count++;
                  },
                  onFinish: (value) {
                    log("on finish");
                  });
            },
            child: Text("normal with error"),
          ),
          RaisedButton(
            onPressed: () {
              custom.run(
                  context: context,
                  onExecute: () async {
                    await Future.delayed(Duration(seconds: 3));
                  },
                  onFinish: (value) {
                    log("on finish");
                  });
            },
            child: Text("custom"),
          ),
          RaisedButton(
            onPressed: () {
              custom.run(
                  context: context,
                  onExecute: () async {
                    await Future.delayed(Duration(seconds: 3));
                    int count;
                    count++;
                  },
                  onFinish: (value) {
                    log("on finish");
                  });
            },
            child: Text("custom with error"),
          ),
        ],
      ),
    );
  }
}
