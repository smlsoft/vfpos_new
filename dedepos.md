
# DEDE POS
```dart
import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/core/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app_view.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.DEDEPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  await setUpServiceLocator();
  await initializeApp();
  runApp(App());
}

```

```

flutter build appbundle --flavor dedepos -t lib/main_dedepos.dart --release --dart-define=ENVIRONMENT=PROD
```