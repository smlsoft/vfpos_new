import 'dart:convert';
import 'package:dedepos/model/objectbox/table_struct.dart';
import 'package:http/http.dart' as http;
import 'package:dedepos/global.dart' as global;
import 'package:intl/intl.dart';

Future<String> clickHouseExecute(String query) async {
  String url = 'https://api2.dev.dedepos.com/orderonlineapi/execute';
  print(query);
  // Create a Map object with the query field
  Map<String, String> requestBody = {
    'query': query,
  };

  // Convert the Map to JSON
  String jsonBody = json.encode(requestBody);

  // Make the HTTP POST request
  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    // Request successful
    print('Query executed successfully.');
    // Do something with the response, if needed
    var responseBody = json.decode(response.body);
    return responseBody.toString();
    // ...
  } else {
    // Request failed
    print('Error executing query. Status code: ${response.statusCode}');
  }
  return "";
}

Future<Map<String, dynamic>> clickHouseSelect(String query) async {
  String url = 'https://api2.dev.dedepos.com/orderonlineapi/select';

  // Create a Map object with the query field
  Map<String, String> requestBody = {
    'query': query,
  };

  // Convert the Map to JSON
  String jsonBody = json.encode(requestBody);

  // Make the HTTP POST request
  var response = await http.post(
    Uri.parse(url),
    headers: {'Content-Type': 'application/json'},
    body: jsonBody,
  );

  if (response.statusCode == 200) {
    // Request successful
    print('Query executed successfully.');
    // Do something with the response, if needed
    var responseBody = json.decode(response.body);
    return responseBody;
  } else {
    // Request failed
    print('Error executing query. Status code: ${response.statusCode}');
  }
  return {};
}

void clickHouseUpdateTable(TableProcessObjectBoxStruct table) async {
  {
    /// ลบข้อมูลเก่า
    String query =
        "alter table tableinfo delete where shopid='${global.shopId}' and qrcode='${table.qr_code}'";
    print(query);
    await clickHouseExecute(query);
  }
  {
    /// เพิ่มข้อมูลใหม่
    String tableOpenDateTime =
        DateFormat('yyyy-MM-dd HH:mm:ss').format(table.table_open_datetime);
    String query =
        "INSERT INTO tableinfo (shopid, guidfixed, tablenumber, tablename, tablezone, tablestatus, amount, ordersuccess, tableopendatetime, qrcode, mancount, womancount, childcount, tableallacratemode, buffetcode) VALUES ('${global.shopId}','${table.guidfixed}','${table.number}','${table.names}','${table.zone}',${table.table_status},${table.amount},${(table.order_success) ? '1' : '0'},'$tableOpenDateTime','${table.qr_code}',${table.man_count},${table.woman_count},${table.child_count},${(table.table_al_la_crate_mode) ? '1' : '0'},'${table.buffet_code}')";
    print(query);
    await clickHouseExecute(query);
  }
}
