# วิธี Deploy ขึ้น Google

```
flutter build appbundle --flavor dedepos -t lib/main_dedepos.dart --release --dart-define=ENVIRONMENT=PROD
```


เข้า Google Play Console  ไป Project DEDEPOS เข้าหัวข้อ Internal Testing

[https://play.google.com/console/u/0/developers/5821174520038868015/app/4976243658789662719/tracks/internal-testing](https://play.google.com/console/u/0/developers/5821174520038868015/app/4976243658789662719/tracks/internal-testing)

กด Create Release

ส่วนของ App Bundles ให้ Upload ไฟล์ app-release.aab ที่อยู่ในโฟลเดอร์ build/app/outputs/bundle/dedeposRelease/app-dedepos-release.aab

ระบุ Release Name, Release Notes

กด Save แล้วกด Review

-- apk
flutter build apk --flavor dedepos -t lib/main_dedepos.dart --release --dart-define=ENVIRONMENT=PROD
