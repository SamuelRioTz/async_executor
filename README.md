# async_executor

Async Executor is a tool what allow you execute any asynchronous functions handling the loading process and error catch, with normal popups.

## Example

```dart

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

```
