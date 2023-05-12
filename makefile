run_buildrunner:
	flutter pub run build_runner build
run_buildrunner_clean:
	flutter pub run build_runner build --delete-conflicting-outputs
run_vfpos:
	flutter run --flavor vfpos -t lib/main_vfpos.dart