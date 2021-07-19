library async_executor;

import 'package:flutter/material.dart';

class AsyncExecutor {
  late LoadingMessage _loadingMessage;
  late ErrorMessage _errorMessage;

  AsyncExecutor({LoadingMessage? loadingMessage, ErrorMessage? errorMessage}) {
    _loadingMessage = (loadingMessage != null)
        ? loadingMessage
        : ({
            required BuildContext context,
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
                              backgroundColor: Colors.white,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                );
              },
            );
          } as Future<dynamic> Function({BuildContext? context});

    _errorMessage = (errorMessage != null)
        ? errorMessage
        : ({
            dynamic error,
            required BuildContext context,
          }) async {
            return await showDialog(
              context: context,
              builder: (dialogContext) {
                return AlertDialog(
                  title: Text("Error"),
                  content: Text("$error"),
                  actions: [
                    TextButton(
                      child: Text("OK"),
                      onPressed: () {
                        Navigator.pop(dialogContext);
                      },
                    )
                  ],
                );
              },
            );
          } as Future<dynamic> Function({BuildContext? context, dynamic error});
  }

  void run<T>({
    required BuildContext context,
    required OnExecute<T> onExecute,
    required OnFinish<T>? onFinish,
  }) {
    _loadingMessage(
      context: context,
    );

    onExecute().then((T value) {
      Navigator.pop(context);
      if (onFinish != null) onFinish(value);
    }).catchError((error) {
      Navigator.pop(context);
      _errorMessage(error: error, context: context);
    });
  }
}

typedef ErrorMessage = Future<void> Function({
  required dynamic error,
  required BuildContext context,
});
typedef LoadingMessage = Future<void> Function({required BuildContext context});

typedef Future<T> OnExecute<T>();
typedef void OnFinish<T>(T value);
