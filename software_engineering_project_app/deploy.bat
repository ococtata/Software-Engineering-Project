@echo off
echo Deploying...

echo [1/3] Getting dependencies...
call flutter pub get

echo [2/3] Building for web...
call flutter build web --release

echo [3/3] Copying vercel.json...
copy vercel.json build\web\vercel.json >nul

echo.
echo Build complete!
echo.
echo Next steps:
echo   cd build\web
echo   vercel --prod
echo.
pause