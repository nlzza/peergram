import 'package:flutter/material.dart';

enum ChatStatus {
  Disconnected,
  Connecting,
  Connected;

  Color get color {
    if (this == ChatStatus.Disconnected) return Colors.redAccent.shade700;
    if (this == ChatStatus.Connecting) return Colors.blue.shade700;
    if (this == ChatStatus.Connected) return Colors.green.shade700;
    return Colors.grey;
  }
}
