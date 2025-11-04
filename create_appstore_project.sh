#!/bin/bash

# Script to create a proper macOS Xcode app project for App Store distribution
# Based on the working Swift Package implementation

set -e

PROJECT_NAME="PDFComparator"
PROJECT_DIR="/Users/rose/Code/pdf-comparator-appstore"
BUNDLE_ID="com.pdfcomparator.app"

echo "Creating Xcode project for App Store distribution..."

# Create project directory
mkdir -p "$PROJECT_DIR"
cd "$PROJECT_DIR"

# Create the basic directory structure
mkdir -p "$PROJECT_NAME"
mkdir -p "$PROJECT_NAME/Assets.xcassets/AppIcon.appiconset"

# Copy all source files
echo "Copying source files..."
cp /Users/rose/Code/pdf-comparator/Sources/PDFComparator/*.swift "$PROJECT_NAME/"

# Create Info.plist
cat > "$PROJECT_NAME/Info.plist" << 'PLIST'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>CFBundleDevelopmentRegion</key>
	<string>$(DEVELOPMENT_LANGUAGE)</string>
	<key>CFBundleExecutable</key>
	<string>$(EXECUTABLE_NAME)</string>
	<key>CFBundleIdentifier</key>
	<string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
	<key>CFBundleInfoDictionaryVersion</key>
	<string>6.0</string>
	<key>CFBundleName</key>
	<string>$(PRODUCT_NAME)</string>
	<key>CFBundlePackageType</key>
	<string>$(PRODUCT_BUNDLE_PACKAGE_TYPE)</string>
	<key>CFBundleShortVersionString</key>
	<string>1.0</string>
	<key>CFBundleVersion</key>
	<string>1</string>
	<key>LSMinimumSystemVersion</key>
	<string>$(MACOSX_DEPLOYMENT_TARGET)</string>
	<key>NSPrincipalClass</key>
	<string>NSApplication</string>
	<key>NSHighResolutionCapable</key>
	<true/>
</dict>
</plist>
PLIST

# Create AppIcon Contents.json
cat > "$PROJECT_NAME/Assets.xcassets/AppIcon.appiconset/Contents.json" << 'JSON'
{
  "images" : [
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "16x16"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "16x16"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "32x32"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "32x32"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "128x128"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "128x128"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "256x256"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "256x256"
    },
    {
      "idiom" : "mac",
      "scale" : "1x",
      "size" : "512x512"
    },
    {
      "idiom" : "mac",
      "scale" : "2x",
      "size" : "512x512"
    }
  ],
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON

# Create Assets catalog Contents.json
cat > "$PROJECT_NAME/Assets.xcassets/Contents.json" << 'JSON'
{
  "info" : {
    "author" : "xcode",
    "version" : 1
  }
}
JSON

# Create entitlements file for App Sandbox
cat > "$PROJECT_NAME/$PROJECT_NAME.entitlements" << 'ENTITLEMENTS'
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
	<key>com.apple.security.app-sandbox</key>
	<true/>
	<key>com.apple.security.files.user-selected.read-write</key>
	<true/>
</dict>
</plist>
ENTITLEMENTS

echo ""
echo "✅ Project structure created at: $PROJECT_DIR"
echo ""
echo "Next steps:"
echo "1. Open Xcode"
echo "2. File > New > Project"
echo "3. Choose macOS > App"
echo "4. Configure:"
echo "   - Product Name: $PROJECT_NAME"
echo "   - Team: Your Apple Developer Team"
echo "   - Organization Identifier: Use your own (e.g., com.yourname)"
echo "   - Interface: SwiftUI"
echo "   - Language: Swift"
echo "5. Save at: $PROJECT_DIR (replace the existing folder)"
echo ""
echo "Or, I can try to generate the complete .xcodeproj file for you."
echo "Would you like me to do that?"
