#!/bin/bash

# Navigate to the project directory
cd "$(dirname "$0")"

# Clean the project
echo "🚀 Cleaning the project..."
flutter clean

# Get dependencies
echo "📦 Getting dependencies..."
flutter pub get

# Build the APK in release mode
echo "🔨 Building APK..."
flutter build apk --release

# Find the latest APK
APK_PATH="build/app/outputs/flutter-apk/app-release.apk"

# Check if APK exists
if [ ! -f "$APK_PATH" ]; then
    echo "❌ Error: APK not found at $APK_PATH"
    exit 1
fi

# Get the default emulator
echo "📱 Finding default emulator..."
EMULATOR=$(adb devices | grep -E 'emulator-|^[^List]' | grep -v "List of devices" | head -n 1 | awk '{print $1}')

if [ -z "$EMULATOR" ]; then
    echo "❌ No emulator found. Starting the default emulator..."
    # Start the default emulator
    flutter emulators --launch flutter_emulator
    # Wait for emulator to start
    sleep 20
    EMULATOR=$(adb devices | grep -E 'emulator-|^[^List]' | grep -v "List of devices" | head -n 1 | awk '{print $1}')
    
    if [ -z "$EMULATOR" ]; then
        echo "❌ Failed to start emulator. Please start an emulator manually and try again."
        exit 1
    fi
fi

echo "📱 Found emulator: $EMULATOR"

# Uninstall the app if it exists
echo "🗑️  Uninstalling existing app..."
adb -s $EMULATOR uninstall com.payee.paylent 2>/dev/null

# Install the new APK
echo "⬆️  Installing new APK..."
adb -s $EMULATOR install -r "$APK_PATH"

if [ $? -ne 0 ]; then
    echo "❌ Failed to install APK"
    exit 1
fi

# Launch the app
echo "🚀 Launching the app..."
adb -s $EMULATOR shell am start -n com.payee.paylent/com.payee.paylent.MainActivity

echo "✅ Build and deploy completed successfully!"
echo "📱 The app is now running on $EMULATOR"
