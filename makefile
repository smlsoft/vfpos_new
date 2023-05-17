run_buildrunner:
	flutter pub run build_runner build
run_buildrunner_clean:
	flutter pub run build_runner build --delete-conflicting-outputs
run_vfpos:
	flutter run --flavor vfpos -t lib/main_vfpos.dart
run_vfpos_staging:
	flutter run --flavor vfpos -t lib/main_vfpos.dart --dart-define=ENVIRONMENT=STAGING
flavor_icon_gen:
	flutter pub run flutter_flavorizr -p android:icons
build_production_vfpos:
	flutter build ipa --flavor vfpos -t lib/main_vfpos.dart --dart-define=ENVIRONMENT=PROD