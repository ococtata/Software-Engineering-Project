echo " Building Flutter App..."

# Clean previous build
flutter clean

# Get dependencies
flutter pub get

# Build for web
flutter build web --release

# Copy vercel.json to build output
cp vercel.json build/web/vercel.json

echo "✅ Build complete! Ready to deploy."
echo "Run: vercel --prod"