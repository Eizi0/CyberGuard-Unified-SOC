@echo off
:: Frontend Status Check - CyberGuard Unified SOC
:: =============================================

echo.
echo ==========================================
echo  CyberGuard Unified SOC - Frontend Check
echo ==========================================
echo.

:: Check essential files
echo [STRUCTURE VERIFICATION]
if exist "frontend\package.json" (
    echo [✓] package.json found
) else (
    echo [✗] package.json missing
    set HAS_ERROR=1
)

if exist "frontend\src\App.jsx" (
    echo [✓] App.jsx found
) else (
    echo [✗] App.jsx missing
    set HAS_ERROR=1
)

if exist "frontend\src\index.js" (
    echo [✓] index.js found
) else (
    echo [✗] index.js missing
    set HAS_ERROR=1
)

if exist "frontend\public\index.html" (
    echo [✓] public/index.html found
) else (
    echo [✗] public/index.html missing
    set HAS_ERROR=1
)

if exist "frontend\public\manifest.json" (
    echo [✓] public/manifest.json found
) else (
    echo [✗] public/manifest.json missing
    set HAS_ERROR=1
)

if exist "frontend\tsconfig.json" (
    echo [✓] tsconfig.json found
) else (
    echo [✗] tsconfig.json missing
    set HAS_ERROR=1
)

if exist "frontend\.env" (
    echo [✓] .env found
) else (
    echo [✗] .env missing
    set HAS_ERROR=1
)

echo.
echo [DEPENDENCIES CHECK]
where node >nul 2>&1
if %errorlevel% == 0 (
    echo [✓] Node.js is installed
    node --version
) else (
    echo [✗] Node.js not found
    echo     Download from: https://nodejs.org/
)

where npm >nul 2>&1
if %errorlevel% == 0 (
    echo [✓] npm is available
    npm --version
) else (
    echo [✗] npm not found
    echo     Install Node.js to get npm
)

if exist "frontend\node_modules" (
    echo [✓] node_modules found (dependencies installed)
) else (
    echo [!] node_modules missing (run: npm install)
)

echo.
echo [BUILD STATUS]
if exist "frontend\build" (
    echo [✓] build directory exists
) else (
    echo [!] build directory missing (run: npm run build)
)

echo.
echo ==========================================
if defined HAS_ERROR (
    echo  STATUS: ERRORS FOUND - CHECK ABOVE
) else (
    echo  STATUS: FRONTEND READY FOR BUILD
)
echo ==========================================
echo.

echo NEXT STEPS:
echo 1. Install Node.js if not present
echo 2. cd frontend
echo 3. npm install
echo 4. npm run build
echo 5. npm start
echo.

pause
