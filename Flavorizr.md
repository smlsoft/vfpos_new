
```cli
# dart run flutter_flavorizr

Deprecated. Use `dart run` instead.
Building package executable... 
Built flutter_flavorizr:flutter_flavorizr.
Executing task assets:download

Executing task assets:extract

Executing task android:androidManifest

Executing task android:buildGradle

Executing task android:dummyAssets
Running DummyAssetProcessor: Copying folder from .tmp/android/res to android/app/src/dev/res
Running DummyAssetProcessor: Copying folder from .tmp/android/res to android/app/src/dedepos/res
Running DummyAssetProcessor: Copying folder from .tmp/android/res to android/app/src/smlsuperpos/res
Running DummyAssetProcessor: Copying folder from .tmp/android/res to android/app/src/smlmobilesales/res
Running DummyAssetProcessor: Copying folder from .tmp/android/res to android/app/src/vfpos/res

Executing task android:icons
Running AndroidIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 48, height: 48} from assets/app_logo.png to android/app/src/dev/res/mipmap-mdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 72, height: 72} from assets/app_logo.png to android/app/src/dev/res/mipmap-hdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 96, height: 96} from assets/app_logo.png to android/app/src/dev/res/mipmap-xhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 144, height: 144} from assets/app_logo.png to android/app/src/dev/res/mipmap-xxhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 192, height: 192} from assets/app_logo.png to android/app/src/dev/res/mipmap-xxxhdpi/ic_launcher.png
Running AndroidIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 48, height: 48} from assets/icons/dede-pos-icon.png to android/app/src/dedepos/res/mipmap-mdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 72, height: 72} from assets/icons/dede-pos-icon.png to android/app/src/dedepos/res/mipmap-hdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 96, height: 96} from assets/icons/dede-pos-icon.png to android/app/src/dedepos/res/mipmap-xhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 144, height: 144} from assets/icons/dede-pos-icon.png to android/app/src/dedepos/res/mipmap-xxhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 192, height: 192} from assets/icons/dede-pos-icon.png to android/app/src/dedepos/res/mipmap-xxxhdpi/ic_launcher.png
Running AndroidIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 48, height: 48} from assets/app_logo.png to android/app/src/smlsuperpos/res/mipmap-mdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 72, height: 72} from assets/app_logo.png to android/app/src/smlsuperpos/res/mipmap-hdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 96, height: 96} from assets/app_logo.png to android/app/src/smlsuperpos/res/mipmap-xhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 144, height: 144} from assets/app_logo.png to android/app/src/smlsuperpos/res/mipmap-xxhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 192, height: 192} from assets/app_logo.png to android/app/src/smlsuperpos/res/mipmap-xxxhdpi/ic_launcher.png
Running AndroidIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 48, height: 48} from assets/app_logo.png to android/app/src/smlmobilesales/res/mipmap-mdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 72, height: 72} from assets/app_logo.png to android/app/src/smlmobilesales/res/mipmap-hdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 96, height: 96} from assets/app_logo.png to android/app/src/smlmobilesales/res/mipmap-xhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 144, height: 144} from assets/app_logo.png to android/app/src/smlmobilesales/res/mipmap-xxhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 192, height: 192} from assets/app_logo.png to android/app/src/smlmobilesales/res/mipmap-xxxhdpi/ic_launcher.png
Running AndroidIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 48, height: 48} from assets/vf-pos-logo.png to android/app/src/vfpos/res/mipmap-mdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 72, height: 72} from assets/vf-pos-logo.png to android/app/src/vfpos/res/mipmap-hdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 96, height: 96} from assets/vf-pos-logo.png to android/app/src/vfpos/res/mipmap-xhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 144, height: 144} from assets/vf-pos-logo.png to android/app/src/vfpos/res/mipmap-xxhdpi/ic_launcher.png
Running ImageResizerProcessor: Resizing image to Size{width: 192, height: 192} from assets/vf-pos-logo.png to android/app/src/vfpos/res/mipmap-xxxhdpi/ic_launcher.png

Executing task flutter:flavors

Executing task flutter:app

Executing task flutter:pages

Executing task flutter:targets
Running FlutterTargetFileProcessor
Running Copying file from .tmp/flutter/main_target.dart to lib/main_dev.dart
Running FileProcessor: creating file lib/main_dev.dart with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with DEV
Running FlutterTargetFileProcessor
Running Copying file from .tmp/flutter/main_target.dart to lib/main_dedepos.dart
Running FileProcessor: creating file lib/main_dedepos.dart with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with DEDEPOS
Running FlutterTargetFileProcessor
Running Copying file from .tmp/flutter/main_target.dart to lib/main_smlsuperpos.dart
Running FileProcessor: creating file lib/main_smlsuperpos.dart with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with SMLSUPERPOS
Running FlutterTargetFileProcessor
Running Copying file from .tmp/flutter/main_target.dart to lib/main_smlmobilesales.dart
Running FileProcessor: creating file lib/main_smlmobilesales.dart with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with SMLMOBILESALES
Running FlutterTargetFileProcessor
Running Copying file from .tmp/flutter/main_target.dart to lib/main_vfpos.dart
Running FileProcessor: creating file lib/main_vfpos.dart with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with VFPOS

Executing task ios:xcconfig
Running IOSXCConfigFileProcessor
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/devDebug.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/devDebug.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/devProfile.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/devProfile.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/devRelease.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/devRelease.xcconfig, Flutter
Running IOSXCConfigFileProcessor
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/dedeposDebug.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/dedeposDebug.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/dedeposProfile.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/dedeposProfile.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/dedeposRelease.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/dedeposRelease.xcconfig, Flutter
Running IOSXCConfigFileProcessor
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlsuperposDebug.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlsuperposDebug.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlsuperposProfile.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlsuperposProfile.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlsuperposRelease.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlsuperposRelease.xcconfig, Flutter
Running IOSXCConfigFileProcessor
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlmobilesalesDebug.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesDebug.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlmobilesalesProfile.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesProfile.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/smlmobilesalesRelease.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesRelease.xcconfig, Flutter
Running IOSXCConfigFileProcessor
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/vfposDebug.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/vfposDebug.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/vfposProfile.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/vfposProfile.xcconfig, Flutter
Running IOSXCConfigModeFileProcessor
Running FileProcessor: writing file ios/Flutter/vfposRelease.xcconfig with nested IOSXCConfigProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Flutter/vfposRelease.xcconfig, Flutter

Executing task ios:buildTargets
Running IOSBuildConfigurationsProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/devDebug.xcconfig, dev, com.smlsoft.dedepos, Debug, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/devProfile.xcconfig, dev, com.smlsoft.dedepos, Profile, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/devRelease.xcconfig, dev, com.smlsoft.dedepos, Release, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running IOSBuildConfigurationsProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/dedeposDebug.xcconfig, dedepos, com.smlsoft.dedepos, Debug, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/dedeposProfile.xcconfig, dedepos, com.smlsoft.dedepos, Profile, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/dedeposRelease.xcconfig, dedepos, com.smlsoft.dedepos, Release, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LmRlZGVwb3MifQ==
Running IOSBuildConfigurationsProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlsuperposDebug.xcconfig, smlsuperpos, com.smlsoft.smlsuperpos, Debug, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbHN1cGVycG9zIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlsuperposProfile.xcconfig, smlsuperpos, com.smlsoft.smlsuperpos, Profile, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbHN1cGVycG9zIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlsuperposRelease.xcconfig, smlsuperpos, com.smlsoft.smlsuperpos, Release, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbHN1cGVycG9zIn0=
Running IOSBuildConfigurationsProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesDebug.xcconfig, smlmobilesales, com.smlsoft.smlmobilesales, Debug, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbG1vYmlsZXNhbGVzIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesProfile.xcconfig, smlmobilesales, com.smlsoft.smlmobilesales, Profile, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbG1vYmlsZXNhbGVzIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/smlmobilesalesRelease.xcconfig, smlmobilesales, com.smlsoft.smlmobilesales, Release, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6ImNvbS5zbWxzb2Z0LnNtbG1vYmlsZXNhbGVzIn0=
Running IOSBuildConfigurationsProcessor
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/vfposDebug.xcconfig, vfpos, org.villagefundth.vfpos, Debug, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6Im9yZy52aWxsYWdlZnVuZHRoLnZmcG9zIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/vfposProfile.xcconfig, vfpos, org.villagefundth.vfpos, Profile, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6Im9yZy52aWxsYWdlZnVuZHRoLnZmcG9zIn0=
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_build_configuration.rb, ios/Runner.xcodeproj, Flutter/vfposRelease.xcconfig, vfpos, org.villagefundth.vfpos, Release, eyJBU1NFVENBVEFMT0dfQ09NUElMRVJfQVBQSUNPTl9OQU1FIjoiJChBU1NFVF9QUkVGSVgpQXBwSWNvbiIsIkxEX1JVTlBBVEhfU0VBUkNIX1BBVEhTIjoiJChpbmhlcml0ZWQpIEBleGVjdXRhYmxlX3BhdGgvRnJhbWV3b3JrcyIsIlNXSUZUX09CSkNfQlJJREdJTkdfSEVBREVSIjoiUnVubmVyL1J1bm5lci1CcmlkZ2luZy1IZWFkZXIuaCIsIlNXSUZUX1ZFUlNJT04iOiI1LjAiLCJGUkFNRVdPUktfU0VBUkNIX1BBVEhTIjpbIiQoaW5oZXJpdGVkKSIsIiQoUFJPSkVDVF9ESVIpL0ZsdXR0ZXIiXSwiTElCUkFSWV9TRUFSQ0hfUEFUSFMiOlsiJChpbmhlcml0ZWQpIiwiJChQUk9KRUNUX0RJUikvRmx1dHRlciJdLCJJTkZPUExJU1RfRklMRSI6IlJ1bm5lci9JbmZvLnBsaXN0IiwiUFJPRFVDVF9CVU5ETEVfSURFTlRJRklFUiI6Im9yZy52aWxsYWdlZnVuZHRoLnZmcG9zIn0=

Executing task ios:schema
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/create_scheme.rb, ios/Runner.xcodeproj, dev
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/create_scheme.rb, ios/Runner.xcodeproj, dedepos
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/create_scheme.rb, ios/Runner.xcodeproj, smlsuperpos
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/create_scheme.rb, ios/Runner.xcodeproj, smlmobilesales
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/create_scheme.rb, ios/Runner.xcodeproj, vfpos

Executing task ios:dummyAssets
Running IOSDummyAssetsProcessor
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/AppIcon.appiconset to ios/Runner/Assets.xcassets/devAppIcon.appiconset
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/LaunchImage.imageset to ios/Runner/Assets.xcassets/devLaunchImage.imageset
Running IOSDummyAssetsProcessor
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/AppIcon.appiconset to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/LaunchImage.imageset to ios/Runner/Assets.xcassets/dedeposLaunchImage.imageset
Running IOSDummyAssetsProcessor
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/AppIcon.appiconset to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/LaunchImage.imageset to ios/Runner/Assets.xcassets/smlsuperposLaunchImage.imageset
Running IOSDummyAssetsProcessor
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/AppIcon.appiconset to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/LaunchImage.imageset to ios/Runner/Assets.xcassets/smlmobilesalesLaunchImage.imageset
Running IOSDummyAssetsProcessor
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/AppIcon.appiconset to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset
Running DummyAssetProcessor: Copying folder from .tmp/ios/Assets.xcassets/LaunchImage.imageset to ios/Runner/Assets.xcassets/vfposLaunchImage.imageset

Executing task ios:icons
Running IOSIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 20, height: 20} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-20x20@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-20x20@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 60, height: 60} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-20x20@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 29, height: 29} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-29x29@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 58, height: 58} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-29x29@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 87, height: 87} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-29x29@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-40x40@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 80, height: 80} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-40x40@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-40x40@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-60x60@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 180, height: 180} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-60x60@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 76, height: 76} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-76x76@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 152, height: 152} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-76x76@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 167, height: 167} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-83.5x83.5@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 1024, height: 1024} from assets/app_logo.png to ios/Runner/Assets.xcassets/devAppIcon.appiconset/Icon-App-1024x1024@1x.png
Running IOSIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 20, height: 20} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-20x20@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-20x20@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 60, height: 60} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-20x20@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 29, height: 29} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-29x29@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 58, height: 58} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-29x29@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 87, height: 87} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-29x29@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-40x40@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 80, height: 80} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-40x40@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-40x40@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-60x60@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 180, height: 180} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-60x60@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 76, height: 76} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-76x76@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 152, height: 152} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-76x76@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 167, height: 167} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-83.5x83.5@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 1024, height: 1024} from assets/icons/dede-pos-icon.png to ios/Runner/Assets.xcassets/dedeposAppIcon.appiconset/Icon-App-1024x1024@1x.png
Running IOSIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 20, height: 20} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-20x20@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-20x20@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 60, height: 60} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-20x20@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 29, height: 29} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-29x29@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 58, height: 58} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-29x29@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 87, height: 87} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-29x29@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-40x40@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 80, height: 80} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-40x40@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-40x40@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-60x60@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 180, height: 180} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-60x60@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 76, height: 76} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-76x76@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 152, height: 152} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-76x76@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 167, height: 167} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-83.5x83.5@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 1024, height: 1024} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlsuperposAppIcon.appiconset/Icon-App-1024x1024@1x.png
Running IOSIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 20, height: 20} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-20x20@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-20x20@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 60, height: 60} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-20x20@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 29, height: 29} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-29x29@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 58, height: 58} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-29x29@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 87, height: 87} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-29x29@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-40x40@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 80, height: 80} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-40x40@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-40x40@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-60x60@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 180, height: 180} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-60x60@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 76, height: 76} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-76x76@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 152, height: 152} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-76x76@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 167, height: 167} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-83.5x83.5@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 1024, height: 1024} from assets/app_logo.png to ios/Runner/Assets.xcassets/smlmobilesalesAppIcon.appiconset/Icon-App-1024x1024@1x.png
Running IOSIconProcessor
Running ImageResizerProcessor: Resizing image to Size{width: 20, height: 20} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-20x20@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-20x20@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 60, height: 60} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-20x20@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 29, height: 29} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-29x29@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 58, height: 58} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-29x29@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 87, height: 87} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-29x29@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 40, height: 40} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-40x40@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 80, height: 80} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-40x40@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-40x40@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 120, height: 120} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-60x60@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 180, height: 180} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-60x60@3x.png
Running ImageResizerProcessor: Resizing image to Size{width: 76, height: 76} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-76x76@1x.png
Running ImageResizerProcessor: Resizing image to Size{width: 152, height: 152} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-76x76@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 167, height: 167} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-83.5x83.5@2x.png
Running ImageResizerProcessor: Resizing image to Size{width: 1024, height: 1024} from assets/vf-pos-logo.png to ios/Runner/Assets.xcassets/vfposAppIcon.appiconset/Icon-App-1024x1024@1x.png

Executing task ios:plist

Executing task ios:launchScreen
Running IOSTargetLaunchScreenFileProcessor
Running Copying file from .tmp/ios/LaunchScreen.storyboard to ios/Runner/devLaunchScreen.storyboard
Running FileProcessor: creating file ios/Runner/devLaunchScreen.storyboard with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with dev
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Runner/devLaunchScreen.storyboard
Running IOSTargetLaunchScreenFileProcessor
Running Copying file from .tmp/ios/LaunchScreen.storyboard to ios/Runner/dedeposLaunchScreen.storyboard
Running FileProcessor: creating file ios/Runner/dedeposLaunchScreen.storyboard with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with dedepos
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Runner/dedeposLaunchScreen.storyboard
Running IOSTargetLaunchScreenFileProcessor
Running Copying file from .tmp/ios/LaunchScreen.storyboard to ios/Runner/smlsuperposLaunchScreen.storyboard
Running FileProcessor: creating file ios/Runner/smlsuperposLaunchScreen.storyboard with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with smlsuperpos
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Runner/smlsuperposLaunchScreen.storyboard
Running IOSTargetLaunchScreenFileProcessor
Running Copying file from .tmp/ios/LaunchScreen.storyboard to ios/Runner/smlmobilesalesLaunchScreen.storyboard
Running FileProcessor: creating file ios/Runner/smlmobilesalesLaunchScreen.storyboard with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with smlmobilesales
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Runner/smlmobilesalesLaunchScreen.storyboard
Running IOSTargetLaunchScreenFileProcessor
Running Copying file from .tmp/ios/LaunchScreen.storyboard to ios/Runner/vfposLaunchScreen.storyboard
Running FileProcessor: creating file ios/Runner/vfposLaunchScreen.storyboard with nested ReplaceStringProcessor: replacing [[FLAVOR_NAME]] with vfpos
Running ShellProcessor: Running script 'ruby' with arguments .tmp/scripts/ios/add_file.rb, ios/Runner.xcodeproj, Runner/vfposLaunchScreen.storyboard

Executing task google:firebase

Executing task huawei:agconnect

Executing task assets:clean
Running Deleting file from assets.tmp.zip
Running Deleting file from .tmp

Executing task ide:config

```