// ignore_for_file: non_constant_identifier_names

class PrinterModel {
  late String guidfixed;
  late String code;
  late String name;
  late int printer_type;
  late String printer_ip_address;
  late int printer_port;
  late bool is_ready = false;
  late bool is_run_thread = false;

  PrinterModel(
      {required this.guidfixed,
      required this.code,
      required this.name,
      required this.printer_ip_address,
      required this.printer_port,
      required this.printer_type});
}
