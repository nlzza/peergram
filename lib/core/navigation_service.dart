import 'package:flutter/material.dart';

class NavigationService {
  static final instance = NavigationService._();

  NavigationService._();

  final navKey = GlobalKey<NavigatorState>();

  BuildContext get context => navKey.currentContext!;

  void showLoadingIndicator([bool critical = false]) {
    final context = navKey.currentState?.overlay?.context;
    if (context == null) return;

    showDialog(
      context: context,
      barrierDismissible: !critical,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async => !critical,
          child: const Center(
            child: CircularProgressIndicator(),
          ),
        );
      },
    );
  }

  void to(Widget screen) {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => screen),
    );
  }

  void push(String appRoute, {Object? args}) {
    Navigator.of(context).pushNamed(appRoute, arguments: args);
  }

  void replace(String appRoute, {Object? args}) {
    Navigator.of(context).pushReplacementNamed(appRoute, arguments: args);
  }

  void replaceAll(String appRoute, {Object? args}) {
    while (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    }
    Navigator.of(context).pushReplacementNamed(appRoute, arguments: args);
  }

  void pop([bool? result]) {
    return Navigator.of(context).pop(result);
  }
}
