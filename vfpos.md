# VF POS

## IOS 

### Release App
```cli
flutter build ipa --flavor vfpos -t lib/main_vfpos.dart


flutter build ipa --flavor vfpos -t lib/main_vfpos.dart --dart-define=ENVIRONMENT=PROD


flutter build appbundle --flavor vfpos -t lib/main_vfpos.dart --release --dart-define=ENVIRONMENT=PROD
```