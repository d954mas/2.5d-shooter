adb shell pm uninstall -k com.d954mas.dtfjam
adb install C:\Users\user\Desktop\armv7-android\dtfjam\dtfjam.apk
adb shell monkey -p com.d954mas.dtfjam -c android.intent.category.LAUNCHER 1
pause
