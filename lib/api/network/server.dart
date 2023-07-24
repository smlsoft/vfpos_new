import "dart:developer" as dev;
import 'dart:typed_data';
import 'package:dedepos/api/network/server_get.dart';
import 'package:dedepos/api/network/server_post.dart';
import 'package:dedepos/api/network/sync_model.dart';
import 'package:dedepos/api/sync/sync_bill.dart';
import 'package:dedepos/core/core.dart';
import 'package:dedepos/db/pos_log_helper.dart';
import 'package:dedepos/db/product_barcode_status_helper.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_print.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_util.dart';
import 'package:dedepos/global_model.dart';
import 'package:dedepos/model/json/pos_process_model.dart';
import 'package:dedepos/model/json/product_option_model.dart';
import 'package:dedepos/model/objectbox/bill_struct.dart';
import 'package:dedepos/model/objectbox/buffet_mode_struct.dart';
import 'package:dedepos/model/objectbox/kitchen_struct.dart';
import 'package:dedepos/model/objectbox/order_temp_struct.dart';
import 'package:dedepos/model/objectbox/pos_log_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_status_struct.dart';
import 'package:dedepos/model/objectbox/product_barcode_struct.dart';
import 'package:dedepos/model/objectbox/product_category_struct.dart';
import 'package:dedepos/model/objectbox/staff_client_struct.dart';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:dedepos/model/system/pos_pay_model.dart';
import 'package:dedepos/objectbox.g.dart';
import 'package:dedepos/features/pos/presentation/screens/pos_process.dart';
import 'package:dedepos/util/pos_compile_process.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/db/product_barcode_helper.dart';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/util/network.dart' as network;
import 'package:dedepos/util/printer.dart' as printer;
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

Future<void> startServer() async {
  global.ipAddress = await network.ipAddress();
  if (global.ipAddress.isNotEmpty) {
    network.connectivity();
    global.targetDeviceIpAddress = global.ipAddress;
    var server =
        await HttpServer.bind(global.ipAddress, global.targetDeviceIpPort);
    dev.log(
        "Server running on IP : ${server.address} On Port : ${server.port}");
    await for (HttpRequest request in server) {
      try {
        if (global.loginSuccess) {
          var contentType = request.headers.contentType;
          var response = request.response;
          if (request.method == 'GET') {
            await serverGet(request, response);
          } else if (request.method == 'POST') {
            if (contentType?.mimeType == 'application/json') {
              try {
                var data = await utf8.decoder.bind(request).join();
                var jsonDecodeStr = jsonDecode(data);
                var httpPost = HttpPost.fromJson(jsonDecodeStr);
                await serverPost(httpPost, response);
              } catch (e) {
                stderr.writeln(e.toString());
              }
            }
          }
          await response.flush();
          await response.close();
        }
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
