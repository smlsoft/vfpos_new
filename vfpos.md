# VF POS

```dart
import 'package:dedepos/bootstrap.dart';
import 'package:dedepos/core/core.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

import 'app/app_view.dart';
import 'flavors.dart';

void main() async {
  F.appFlavor = Flavor.VFPOS;
  initializeEnvironmentConfig();
  WidgetsFlutterBinding.ensureInitialized();
  Intl.defaultLocale = "th";
  await setUpServiceLocator();
  await initializeApp();
  runApp(App());
}

```

## IOS 

### Release App
```cli
flutter build ipa --flavor vfpos -t lib/main_vfpos.dart --release --dart-define=ENVIRONMENT=PROD





flutter build appbundle --flavor vfpos -t lib/main_vfpos.dart --release --dart-define=ENVIRONMENT=PROD
```

## Android


```
flutter build appbundle --flavor vfpos -t lib/main_vfpos.dart --release --dart-define=ENVIRONMENT=PROD
```