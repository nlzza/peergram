import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';

import 'overlay_service.dart';

Future<void> handleErrors(
  Future Function() callBack, {
  void Function()? onError,
}) async {
  String? errorMessage;
  try {
    await callBack();
  } on FirebaseException catch (e) {
    errorMessage = e.message ?? 'unknown error';
  } on SocketException catch (e) {
    errorMessage = e.message;
  } on Exception catch (e) {
    errorMessage = e.toString();
  } catch (e) {
    errorMessage = e.toString();
  } finally {
    if (errorMessage != null) {
      log(errorMessage);
      OverlayService.instance.showError(errorMessage);
      if (onError != null) onError();
    }
  }
}
