@echo off
echo Deploying...

echo [1/4] Getting dependencies...
call flutter pub get

echo [2/4] Building for web...
call flutter build web --release

echo [3/4] Copying vercel.json...
copy vercel.json build\web\vercel.json >nul

echo Build complete!
cd build\web

echo [4/4] Deploying to Vercel...
call vercel --prod

echo Deployment complete!
cd ../..
pause