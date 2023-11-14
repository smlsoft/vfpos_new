run_buildrunner:
	flutter pub run build_runner build
run_buildrunner_clean:
	flutter pub run build_runner build --delete-conflicting-outputs
run_vfpos_dev:
	flutter run 
run_vfpos_staging:
	flutter run --dart-define=ENVIRONMENT=STAGING
flavor_icon_gen:
	flutter pub run flutter_flavorizr -p android:icons
build_production_vfpos:
	flutter build ipa --dart-define=ENVIRONMENT=PROD
flutter_android_build_gradie:
	dart run flutter_flavorizr -p android:buildGradle
flutter_run_dedepos:
	flutter run --flavor dedepos -t lib/main_dedepos.dart
	