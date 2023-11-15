import "dart:developer" as dev;
import 'package:dedepos/api/network/server_get.dart';
import 'package:dedepos/api/network/server_post.dart';
import 'package:dedepos/global_model.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'package:dedepos/global.dart' as global;
import 'package:dedepos/util/network.dart' as network;

Future<void> startServer() async {
  global.ipAddress = await network.ipAddress();
  if (global.ipAddress.isNotEmpty) {
    network.connectivity();
    global.targetDeviceIpAddress = global.ipAddress;
    var server = await HttpServer.bind(global.ipAddress, global.targetDeviceIpPort);
    dev.log("Server running on IP : ${server.address} On Port : ${server.port}");
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
