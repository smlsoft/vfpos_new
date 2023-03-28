import 'package:esc_pos_utils/esc_pos_utils.dart';
import 'package:esc_pos_printer/esc_pos_printer.dart';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dedepos/global.dart' as global;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> connectivity() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    print("I am connected to a mobile network.");
  } else if (connectivityResult == ConnectivityResult.wifi) {
    print("I am connected to a wifi network.");
  }
}

Future<String> ipAddress() async {
  // Get a list of the network interfaces available on the device
  List<NetworkInterface> interfaces = await NetworkInterface.list();

  // Iterate through the list of interfaces and return the first non-loopback IPv4 address
  for (NetworkInterface interface in interfaces) {
    if (interface.name == 'lo') continue; // Skip the loopback interface
    for (InternetAddress address in interface.addresses) {
      if (address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }

  // If no non-loopback IPv4 address was found, return null
  return "";
}
