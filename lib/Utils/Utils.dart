import 'dart:ui';

import 'package:fluttertoast/fluttertoast.dart';
import 'package:get_it/get_it.dart';
import 'package:sehat_app/services/database_service.dart';
import 'package:sehat_app/services/media_service.dart';
import 'package:sehat_app/services/storage_service.dart';

class Utils {

  Future<void> registerServices () async {
    final GetIt getIt = GetIt.instance;

    
  getIt.registerSingleton<MediaService>(MediaService());

  getIt.registerSingleton<StorageService>(StorageService());

  getIt.registerSingleton<DatabaseService>(DatabaseService());
  }

  toastMessage(String message, Color color, Color textColor) {
    Fluttertoast.showToast(
        msg: message,
        backgroundColor: color,
        toastLength: Toast.LENGTH_LONG,
        textColor: textColor,
        gravity: ToastGravity.BOTTOM);
  }
}