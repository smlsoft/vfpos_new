import 'package:dedepos/core/environment.dart';
import 'package:dio/dio.dart';
import 'package:dedepos/global.dart' as global;

class Client {
  Dio init() {
    Dio dio = Dio();
    dio.interceptors.add(ApiInterceptors());

    String endPointService = Environment().config.serviceApi;

    endPointService +=
        endPointService[endPointService.length - 1] == "/" ? "" : "/";

    dio.options.baseUrl = endPointService;
    dio.options.connectTimeout = const Duration(seconds: 20); //20s
    dio.options.receiveTimeout = const Duration(seconds: 30); //5s

    return dio;
  }
}

class ApiResponse<T> {
  late final bool success;
  late final bool error;
  // ignore: unnecessary_question_mark
  late final dynamic? data;
  late final String? message;
  late final int? code;
  final Pages? page;

  ApiResponse({
    required this.success,
    required this.data,
    this.error = true,
    this.message = "",
    this.code = 00,
    this.page,
  });

  factory ApiResponse.fromMap(Map<String, dynamic> map) {
    return ApiResponse(
      success: map['success'] ?? false,
      error: map['error'] ?? true,
      data: map['data'],
      page: map['pagination'] == null
          ? Pages.empty
          : Pages.fromMap(map['pagination']),
    );
  }
}

class Pages {
  final int perPage;
  final int page;
  final int total;
  final int totalPage;

  const Pages({
    required this.perPage,
    required this.page,
    required this.total,
    required this.totalPage,
  });

  static const empty = Pages(perPage: 0, page: 0, total: 0, totalPage: 0);

  bool get isEmpty => this == Pages.empty;

  bool get isNotEmpty => this == Pages.empty;

  factory Pages.fromMap(Map<String, dynamic> map) {
    return Pages(
        perPage: map['perPage'],
        page: map['page'],
        total: map['total'],
        totalPage: map['totalPage']);
  }
}

class ApiInterceptors extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    String authorization = global.appStorage.read("token") ?? '';
    if (authorization.isNotEmpty) {
      options.headers['Authorization'] = "Bearer $authorization";
    }

    super.onRequest(options, handler);
  }
}
