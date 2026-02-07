@echo off
REM Script setup và build Music Player App

echo ========================================
echo Music Player App - Setup Script
echo ========================================
echo.

echo [1/6] Checking Flutter installation...
flutter --version
if errorlevel 1 (
    echo ERROR: Flutter not found! Please install Flutter first.
    pause
    exit /b 1
)
echo.

echo [2/6] Getting dependencies...
flutter pub get
if errorlevel 1 (
    echo ERROR: Failed to get dependencies!
    pause
    exit /b 1
)
echo.

echo [3/6] Running code generation...
flutter pub run build_runner build --delete-conflicting-outputs
echo.

echo [4/6] Checking for connected devices...
flutter devices
echo.

echo [5/6] Building options:
echo   1. Run on connected device
echo   2. Build APK (Android)
echo   3. Build iOS (macOS only)
echo   4. Exit
echo.

set /p choice="Enter your choice (1-4): "

if "%choice%"=="1" (
    echo.
    echo Running app on connected device...
    flutter run
) else if "%choice%"=="2" (
    echo.
    echo Building Android APK...
    flutter build apk --release
    echo.
    echo APK created at: build\app\outputs\flutter-apk\app-release.apk
) else if "%choice%"=="3" (
    echo.
    echo Building iOS...
    flutter build ios --release
    echo.
    echo iOS build completed at: build\ios\iphoneos\Runner.app
) else (
    echo Exiting...
    exit /b 0
)

echo.
echo [6/6] Done!
pause
