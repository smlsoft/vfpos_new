import 'dart:convert';
import 'package:dedepos/api/client.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/global_model.dart' as global_model;
import 'package:dedepos/model/json/member_model.dart';
import 'package:dio/dio.dart';
import 'package:dedepos/db/employee_helper.dart';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/model/objectbox/employees_struct.dart';
import 'package:dedepos/model/find/find_employee_model.dart';
import 'package:dedepos/model/find/find_item_model.dart';
import 'dart:async';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';

// GET {{host}}/master-sync/list?lastupdate=2010-01-02T15:04&module=productunit&limit=1&offset=0&action=new
class ApiRepository {
  Future<ApiResponse> serverGetLastDocNumber({
    required String docNumber,
  }) async {
    Dio client = Client().init();

    try {
      String query = "/transaction/sale-invoice/last-pos-docno?posid=${global.posConfig.code}&maxdocno=$docNumber";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } catch (ex) {
      String errorMessage = ex.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<List<global_model.SyncMasterStatusModel>> serverMasterStatus() async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/status";
      final response = await client.get(query);
      try {
        final Map<dynamic, dynamic> rawData = json.decode(response.toString());
        return rawData.entries
            .map((e) => global_model.SyncMasterStatusModel()
              ..tableName = e.key
              ..lastUpdate = e.value)
            .toList();
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverKitchenGetData({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=restaurant-kitchen&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverTableGetData({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=restaurant-table&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverOrderTypeGetData({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=ordertype&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverPrinter({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=printer&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverProductCategory({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=productcategory&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> serverProductBarcode({
    int limit = 0,
    int offset = 0,
    String lastupdate = '',
  }) async {
    Dio client = Client().init();

    try {
      String query = "/master-sync/list?lastupdate=$lastupdate&module=productbarcode&offset=$offset&limit=$limit&action=all";
      final response = await client.get(query);
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getMasterBank() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/paymentmaster');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().debug(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(ex);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getMasterUpdate({int page = 1, int limit = 50, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/master-sync?lastUpdate=$time&page=$page&limit=$limit');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getInventoryFetchUpdate({int page = 0, int perPage = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/inventory/fetchupdate?lastUpdate=$time&page=$page&limit=$perPage');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getPosTerminal() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/pos/setting');
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> activePosTerminal(shopid, pincode, token, devicenumber, actoken, isdev) async {
    Dio client = Client().initExpress();

    try {
      final response = await client.get('/poscenter/active?shopid=$shopid&pin=$pincode&token=$token&deviceid=$devicenumber&actoken=$actoken&isdev=$isdev');
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getCategoryFetchUpdate({int page = 0, int limit = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/category/fetchupdate?lastUpdate=$time&page=$page&limit=$limit');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getMemberFetchUpdate({int page = 0, int perPage = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/member/fetchupdate?lastUpdate=$time&page=$page&limit=$perPage');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getPrinterFetchUpdate({int page = 0, int perPage = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/restaurant/printer/fetchupdate?lastUpdate=$time&page=$page&limit=$perPage');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getTableFetchUpdate({int page = 0, int perPage = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/restaurant/table/fetchupdate?lastUpdate=$time&page=$page&limit=$perPage');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getZoneFetchUpdate({int page = 0, int perPage = 1, String time = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/restaurant/zone/fetchupdate?lastUpdate=$time&page=$page&limit=$perPage');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getCategoryList({
    int page = 0,
    int perPage = 20,
    String search = "",
  }) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/category?page=$page&limit=$perPage&q=$search');
      try {
        final rawData = json.decode(response.toString());

        serviceLocator<Log>().trace(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getInventoryList({int page = 0, int perPage = 1, String search = ""}) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/inventory?page=$page&limit=$perPage&q=$search');
      try {
        final rawData = json.decode(response.toString());

        serviceLocator<Log>().trace(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getInventoryId(String id) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/inventory/$id');
      try {
        final rawData = json.decode(response.toString());

        serviceLocator<Log>().trace(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getEmployeeList() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/shop/employee/list');
      try {
        final rawData = json.decode(response.toString());

        //print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<List<MemberModel>> findMemberByTelName(String word, int offset, int limit) async {
    Dio client = Client().init();
    if (word.trim().isNotEmpty) {
      try {
        final response = await client.get('/debtaccount/debtor/list?q=$word&offset=$offset&limit=$limit&lang=th');
        try {
          final rawData = json.decode(response.toString());

          print(rawData);

          if (rawData['error'] != null) {
            String errorMessage = '${rawData['code']}: ${rawData['message']}';
            serviceLocator<Log>().error(errorMessage);
            throw Exception('${rawData['code']}: ${rawData['message']}');
          }
          return (rawData['data'] as List).map((e) => MemberModel.fromJson(e)).toList();
        } catch (ex) {
          serviceLocator<Log>().error(ex);
          throw Exception(ex);
        }
      } on DioError catch (ex) {
        String errorMessage = ex.response.toString();
        serviceLocator<Log>().error(errorMessage);
        throw Exception(errorMessage);
      }
    }
    return [];
  }

  Future<ApiResponse> getProfileShop() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/profileshop');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getProfileSetting() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/restaurant/settings');
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getPosSetting(String posId) async {
    Dio client = Client().init();

    try {
      final response = await client.get('/pos/setting/code/' + posId.toUpperCase());
      try {
        final rawData = json.decode(response.toString());

        //   print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<ApiResponse> getProfileSBranch() async {
    Dio client = Client().init();

    try {
      final response = await client.get('/organization/branch');
      try {
        final rawData = json.decode(response.toString());

        print(rawData);

        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }

        return ApiResponse.fromMap(rawData);
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
  }

  Future<bool> userChangePassword(String code, String newPassword) async {
    bool result = false;
    Dio client = Client().init();
    try {
      final response = await client.put('/shop/employee/password', data: {"code": code, "password": newPassword});
      try {
        final rawData = json.decode(response.toString());
        if (rawData['error'] != null) {
          String errorMessage = '${rawData['code']}: ${rawData['message']}';
          serviceLocator<Log>().error(errorMessage);
          throw Exception('${rawData['code']}: ${rawData['message']}');
        }
        result = true;
      } catch (ex) {
        serviceLocator<Log>().error(ex);
        throw Exception(ex);
      }
    } on DioError catch (ex) {
      String errorMessage = ex.response.toString();
      serviceLocator<Log>().error(errorMessage);
      throw Exception(errorMessage);
    }
    return result;
  }
}

class RestApiFindItemByCodeNameBarcode {
  Future<List<FindItemModel>> findItemByCodeNameBarcode(String word, int offset, int limit) async {
    //String _fieldName = "barcode,code,name_1";
    List<FindItemModel> result = [];
    if (word.trim().isNotEmpty) {
      ProductBarcodeHelper productBarcodeHelper = ProductBarcodeHelper();
      List<ProductBarcodeObjectBoxStruct> select = productBarcodeHelper.selectByCodeNameBarCode(word: word.toString(), limit: limit, offset: offset, order: "");
      for (int index = 0; index < select.length; index++) {
        ProductBarcodeObjectBoxStruct source = select[index];
        result.add(FindItemModel(
            barcode: source.barcode,
            item_code: source.item_code,
            item_names: source.names,
            unit_code: source.unit_code,
            unit_names: source.unit_names,
            unit_type: 0,
            qty: 1.0,
            prices: source.prices,
            images_guid_list: []));
      }
    }
    return result;
  }
}

class RestApiFindEmployeeByWord {
  Future<List<FindEmployeeModel>> findEmployeeByWord(String word) async {
    List<FindEmployeeModel> result = [];
    EmployeeHelper employeeHelper = EmployeeHelper();
    List<EmployeeObjectBoxStruct> select = employeeHelper.select(word: word);
    for (int index = 0; index < select.length; index++) {
      EmployeeObjectBoxStruct source = select[index];
      result.add(
        FindEmployeeModel(name: source.name, code: source.code, roles: "" /* _source.roles.toString()*/, profile_picture: source.profile_picture, username: source.name),
      );
    }
    return result;
  }
}
