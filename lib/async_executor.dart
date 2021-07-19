library async_executor;

import 'package:flutter/material.dart';

class AsyncExecutor {
  late LoadingMessage _loadingMessage;
  late ErrorMessage _errorMessage;

  AsyncExecutor({LoadingMessage? loadingMessage, ErrorMessage? errorMessage}) {
    _loadingMessage = (loadingMessage != null)
        ? loadingMessage
        : (context) async {
            await showDialog(
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
          };

    _errorMessage = (errorMessage != null)
        ? errorMessage
        : (
            BuildContext context,
            dynamic error,
          ) async {
            await showDialog(
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
          };
  }

  void run<T>({
    required BuildContext context,
    required OnExecute<T> onExecute,
    required OnFinish<T>? onFinish,
  }) {
    _loadingMessage(context);

    onExecute().then((T value) {
      Navigator.pop(context);
      if (onFinish != null) onFinish(value);
    }).catchError((error) {
      Navigator.pop(context);
      _errorMessage(context, error);
    });
  }
}

typedef ErrorMessage = Future<void> Function(
  BuildContext context,
  dynamic error,
);
typedef LoadingMessage = Future<void> Function(BuildContext context);

typedef Future<T> OnExecute<T>();
typedef void OnFinish<T>(T value);
