@echo off
echo Deploying...

echo [1/5] Getting dependencies...
call flutter pub get

echo [2/5] Building for web...
call flutter build web --release

echo [3/5] Copying vercel.json...
copy vercel.json build\web\vercel.json >nul

echo Build complete!
echo [4/5] 
cd build\web

echo [5/5] Deploying to Vercel...
call vercel --prod

echo Deployment complete!
cd ../..
pause