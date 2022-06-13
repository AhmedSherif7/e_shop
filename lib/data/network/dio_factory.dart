import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../../app/constants.dart';

const String contentType = 'Content-Type';

class DioFactory {
  static Future<Dio> getDio() async {
    Dio dio = Dio();
    dio.options = BaseOptions(
      contentType: contentType,
      baseUrl: Constants.basePaymentUrl,
      connectTimeout: Constants.timeOut,
      receiveTimeout: Constants.timeOut,
    );

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: true,
        ),
      );
    }

    return dio;
  }
}
