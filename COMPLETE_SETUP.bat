@echo off
REM ========================================
REM Music Player App - Complete Setup Script
REM Repository: https://github.com/tuanchan/AppMusic.git
REM ========================================

color 0C
echo.
echo ========================================
echo   MUSIC PLAYER APP - SETUP SCRIPT
echo ========================================
echo.

REM Check if Git is installed
git --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Git is not installed!
    echo Please install Git from: https://git-scm.com/
    pause
    exit /b 1
)

REM Check if Flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo [ERROR] Flutter is not installed!
    echo Please install Flutter from: https://flutter.dev/
    pause
    exit /b 1
)

echo [INFO] Git and Flutter are installed!
echo.

REM Ask user for setup method
echo How do you want to setup the project?
echo.
echo 1. Clone fresh repository (NEW PROJECT)
echo 2. Setup in existing cloned repository
echo 3. Exit
echo.
set /p setup_choice="Enter your choice (1-3): "

if "%setup_choice%"=="1" goto clone_fresh
if "%setup_choice%"=="2" goto setup_existing
if "%setup_choice%"=="3" goto end

:clone_fresh
echo.
echo ========================================
echo CLONING REPOSITORY
echo ========================================
echo.

REM Clone the repository
echo [1/8] Cloning repository...
git clone https://github.com/tuanchan/AppMusic.git
if errorlevel 1 (
    echo [ERROR] Failed to clone repository!
    pause
    exit /b 1
)

cd AppMusic
goto setup_project

:setup_existing
echo.
echo [INFO] Make sure you are in the AppMusic directory
echo Current directory: %cd%
pause
echo.

:setup_project
echo.
echo ========================================
echo SETTING UP FLUTTER PROJECT
echo ========================================
echo.

REM Create Flutter project structure
echo [2/8] Creating Flutter project structure...
flutter create --org com.tuanchan --platforms ios,android .
if errorlevel 1 (
    echo [ERROR] Failed to create Flutter project!
    pause
    exit /b 1
)

echo.
echo [3/8] Installing dependencies...
call flutter pub add just_audio
call flutter pub add audio_service
call flutter pub add file_picker
call flutter pub add path_provider
call flutter pub add permission_handler
call flutter pub add audio_video_progress_bar
call flutter pub add rxdart
call flutter pub add shared_preferences
call flutter pub add audio_session

echo.
echo [4/8] Installing dev dependencies...
call flutter pub add flutter_launcher_icons --dev

echo.
echo [5/8] Creating directory structure...
if not exist "lib\models" mkdir lib\models
if not exist "lib\screens" mkdir lib\screens
if not exist "lib\services" mkdir lib\services
if not exist "lib\utils" mkdir lib\utils
if not exist "assets\icons" mkdir assets\icons
if not exist ".github\workflows" mkdir .github\workflows

echo.
echo [6/8] Getting all dependencies...
flutter pub get

echo.
echo ========================================
echo IMPORTANT: MANUAL STEPS REQUIRED
echo ========================================
echo.
echo Please copy the following files manually:
echo.
echo FROM THE PROVIDED CODE TO YOUR PROJECT:
echo.
echo 1. lib\main.dart
echo 2. lib\models\song.dart
echo 3. lib\screens\home_screen.dart
echo 4. lib\screens\player_screen.dart
echo 5. lib\services\music_service.dart
echo 6. lib\services\file_service.dart
echo 7. lib\utils\app_theme.dart
echo 8. pubspec.yaml (IMPORTANT!)
echo 9. ios\Runner\Info.plist
echo 10. .github\workflows\ios-build.yml
echo 11. .gitignore
echo 12. README.md
echo.
echo After copying files, press any key to continue...
pause >nul

echo.
echo [7/8] Running flutter pub get again...
flutter pub get

echo.
echo [8/8] Checking for errors...
flutter analyze --no-fatal-infos --no-fatal-warnings

echo.
echo ========================================
echo SETUP COMPLETE!
echo ========================================
echo.
echo What would you like to do next?
echo.
echo 1. Test run on connected device
echo 2. Build Android APK
echo 3. Commit and push to GitHub
echo 4. View build instructions
echo 5. Exit
echo.
set /p next_choice="Enter your choice (1-5): "

if "%next_choice%"=="1" goto run_app
if "%next_choice%"=="2" goto build_apk
if "%next_choice%"=="3" goto git_push
if "%next_choice%"=="4" goto show_instructions
goto end

:run_app
echo.
echo ========================================
echo RUNNING APP
echo ========================================
echo.
echo Checking for connected devices...
flutter devices
echo.
echo Starting app...
flutter run
goto end

:build_apk
echo.
echo ========================================
echo BUILDING ANDROID APK
echo ========================================
echo.
flutter build apk --release
echo.
echo [SUCCESS] APK built successfully!
echo Location: build\app\outputs\flutter-apk\app-release.apk
echo.
pause
goto end

:git_push
echo.
echo ========================================
echo PUSHING TO GITHUB
echo ========================================
echo.
echo [1/3] Adding all files...
git add .

echo.
echo [2/3] Committing...
set /p commit_msg="Enter commit message (or press Enter for default): "
if "%commit_msg%"=="" set commit_msg=Initial commit - Music Player App
git commit -m "%commit_msg%"

echo.
echo [3/3] Pushing to GitHub...
git push origin main
if errorlevel 1 (
    echo.
    echo [INFO] If this is the first push, you may need to set upstream:
    echo.
    echo Run: git push -u origin main
    echo.
)

echo.
echo [SUCCESS] Code pushed to GitHub!
echo.
echo GitHub Actions will automatically build iOS IPA.
echo Check: https://github.com/tuanchan/AppMusic/actions
echo.
pause
goto end

:show_instructions
echo.
echo ========================================
echo BUILD INSTRUCTIONS
echo ========================================
echo.
echo Android APK:
echo   flutter build apk --release
echo   Location: build\app\outputs\flutter-apk\app-release.apk
echo.
echo iOS IPA (via GitHub Actions):
echo   1. Push code to GitHub
echo   2. Go to: https://github.com/tuanchan/AppMusic/actions
echo   3. Wait for workflow to complete
echo   4. Download IPA from Artifacts
echo   5. Install using AltStore or Sideloadly
echo.
echo iOS IPA (local - macOS only):
echo   flutter build ios --release
echo   cd build/ios/iphoneos
echo   mkdir Payload
echo   copy Runner.app Payload\
echo   tar -czf AppMusic.ipa Payload
echo.
echo For detailed instructions, see:
echo   - BUILD_IPA_GUIDE.md
echo   - IMPORT_GUIDE.md
echo   - README.md
echo.
pause
goto end

:end
echo.
echo ========================================
echo Thank you for using Music Player App!
echo ========================================
echo.
echo Repository: https://github.com/tuanchan/AppMusic
echo.
echo Useful commands:
echo   flutter run           - Run app on device
echo   flutter build apk     - Build Android APK
echo   git push origin main  - Push to GitHub
echo.
pause
