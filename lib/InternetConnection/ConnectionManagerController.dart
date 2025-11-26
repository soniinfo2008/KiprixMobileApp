import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../Utils/Constant/AppTheme.dart';

class ConnectionManagerController extends GetxController {
  // 0 = No Internet, 1 = WIFI Connected, 2 = Mobile Data Connected
  var connectionType = 0.obs;

  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<List<ConnectivityResult>> _streamSubscription;

  @override
  void onInit() {
    super.onInit();
    getConnectivityType();

    _streamSubscription = _connectivity.onConnectivityChanged.listen((results) {
      if (results.isNotEmpty) {
        _updateState(results.first);
      } else {
        _updateState(ConnectivityResult.none);
      }
    });
  }

  Future<void> getConnectivityType() async {
    List<ConnectivityResult> connectivityResults;
    try {
      connectivityResults = await _connectivity.checkConnectivity();
    } on PlatformException catch (e) {
      if (kDebugMode) {
        print('Connectivity check failed: $e');
      }
      connectivityResults = [ConnectivityResult.none];
    }

    if (connectivityResults.isNotEmpty) {
      _updateState(connectivityResults.first);
    } else {
      _updateState(ConnectivityResult.none);
    }
  }


  void _updateState(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        connectionType.value = 1;
        break;
      case ConnectivityResult.mobile:
        connectionType.value = 2;
        break;
      case ConnectivityResult.none:
        connectionType.value = 0;
        break;
      default:
        Get.snackbar(
          'Error',
          'Failed to get connection type',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red.withOpacity(0.1),
          colorText: AppTheme.apptheme_color,
          borderColor: Colors.red,
          borderWidth: 1,
          margin: const EdgeInsets.only(bottom: 20, left: 10.0, right: 10.0),
        );
        break;
    }
  }

  @override
  void onClose() {
    _streamSubscription.cancel();
    super.onClose();
  }
}
