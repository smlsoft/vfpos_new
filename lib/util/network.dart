import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:dedepos/core/logger/logger.dart';
import 'package:dedepos/core/service_locator.dart';

Future<void> connectivity() async {
  final connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    serviceLocator<Log>().debug("I am connected to a mobile network.");
  } else if (connectivityResult == ConnectivityResult.wifi) {
    serviceLocator<Log>().debug("I am connected to a wifi network.");
  }
}

Future<String> ipAddress() async {
  // Get a list of the network interfaces available on the device
  List<NetworkInterface> interfaces = await NetworkInterface.list();

  // Iterate through the list of interfaces and return the first non-loopback IPv4 address
  for (NetworkInterface interface in interfaces) {
    if (interface.name == 'lo') continue; // Skip the loopback interface
    for (InternetAddress address in interface.addresses) {
      if (address.address.contains("192.168.") && address.type == InternetAddressType.IPv4) {
        return address.address;
      }
    }
  }

  // If no non-loopback IPv4 address was found, return null
  return "";
}
