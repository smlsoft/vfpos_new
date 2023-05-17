import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/main_app.dart';
import 'flavors.dart';

void main() {
  F.appFlavor = Flavor.DEDEPOS;
  initializeEnvironmentConfig();
  mainApp();
}
