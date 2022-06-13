import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../app/constants.dart';
import '../error/failure.dart';

abstract class LocalDataSource {
  Future<void> cacheUserId(String userId);

  String getCachedUserId();

  Future<XFile> getImageFromGallery();

  Future<void> removeUserId();

  Future<void> watchOnBoardScreen();

  Future<void> toggleTheme(bool value);

  Future<bool> getThemeFromStorage();
}

class LocalDataSourceImpl extends LocalDataSource {
  final SharedPreferences sharedPreferences;
  final ImagePicker imagePicker;

  LocalDataSourceImpl(this.sharedPreferences, this.imagePicker);

  @override
  Future<void> cacheUserId(String userId) async {
    await sharedPreferences.setString(Constants.cachedUserIdKey, userId);
  }

  @override
  String getCachedUserId() {
    final userId = sharedPreferences.getString(Constants.cachedUserIdKey);
    if (userId != null) {
      return userId;
    }
    throw const Failure(message: 'No User Id found');
  }

  @override
  Future<XFile> getImageFromGallery() async {
    try {
      final XFile? image =
          await imagePicker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        return image;
      } else {
        throw const Failure(message: 'You did not select any image');
      }
    } on PlatformException catch (e) {
      throw Failure(message: e.message ?? 'Could not select image');
    }
  }

  @override
  Future<void> removeUserId() async {
    await sharedPreferences.remove(Constants.cachedUserIdKey);
  }

  @override
  Future<void> watchOnBoardScreen() async {
    await sharedPreferences.setBool(Constants.cachedWatchOnBoardKey, true);
  }

  @override
  Future<void> toggleTheme(bool value) async {
    await sharedPreferences.setBool(Constants.isDarkMode, value);
  }

  @override
  Future<bool> getThemeFromStorage() async {
    return sharedPreferences.getBool(Constants.isDarkMode) ?? false;
  }
}
