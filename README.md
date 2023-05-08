# dedepos

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://flutter.dev/docs/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://flutter.dev/docs/cookbook)

For help getting started with Flutter, view our
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


KeyStorePass : Smlsoft2022

flutter pub run build_runner build
flutter pub run build_runner build --delete-conflicting-outputs

mongodb://root:smlmgdb@178.128.55.234:27017/?authMechanism=DEFAULT

-- สร้าง APP หลายตัว
flutter pub run flutter_flavorizr
flutter build appbundle --flavor smlmobilesales -t lib/main_smlmobilesales.dart --release


huawei:agconnect
assets:download

flutter pub run flutter_flavorizr -p assets:download,assets:extract
flutter build windows 

flutter run --flavor dedepos -t lib/main_dedepos.dart

flutter build windows --flavor dedepos -t lib/main_dedepos.dart

flutter pub run msix:create --publisher "CN=55D8FA38-A305-463E-8BA0-21DE7B40BA27" --display-name "DEDE POS" --identity-name "SMLSoft.DEDEPOS" --version "1.0.0.0" --capabilities "internetClient, location, microphone, webcam" --logo-path ".\assets\dede-pos-icon.png" --publisher-display-name "SMLSoft" 

## Build VF POS Command
```
flutter run --flavor vfpos -t lib/main_vfpos.dart
flutter build windows --flavor vfpos -t lib/main_vfpos.dart
flutter pub run msix:create


```
