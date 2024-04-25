# sbp_sdk_plugin
## _Flutter-плагин с оберткой для нативных SDK от СБП_

Актуальная версия SDK для iOS: 1.4
Актуальная версия SDK для Android: 1.5

Минимальная версия iOS: 14.0
Минимальная версия API Android: 21

# Features

- Открытие нативной модалки с банками
- Получение списка банков со ссылками на банки (для отображения своего дизайна)

# Installation

## Android

Для показа нативной модалки необходимо заменить `FlutterActivity` на `FlutterFragmentActivity` в файле `MainActivity.kt` (_your_app/android/app/src/main/kotlin/your_app_domain/MainActivity.kt_)

```kotlin
import io.flutter.embedding.android.FlutterFragmentActivity

class MainActivity: FlutterFragmentActivity()
```

Так как SDK использует Material, необходимо заменить содержимое файла `styles.xml` (_your_app/android/app/src/main/res/values/styles.xml_) на следующее:

```xml
<?xml version="1.0" encoding="utf-8"?>
<resources>
  <style name="LaunchTheme" parent="Theme.Material3.Light.NoActionBar">
    <item name="android:windowBackground">@drawable/launch_background</item>
  </style>
  <style name="NormalTheme" parent="Theme.Material3.Light.NoActionBar">
    <item name="android:windowBackground">?android:colorBackground</item>
  </style>
</resources>
```

Аналогично, если в папке `res` есть папка `values-night`

## iOS

Дополнительная конфигурация не требуется