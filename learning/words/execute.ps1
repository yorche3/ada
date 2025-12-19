# Variables
$projectFile = "test.gpr"
$buildDir = "obj"
$testExe = "run_tests.exe"

Write-Output "Building project..."
& gprbuild -p -P $projectFile
if ($LASTEXITCODE -ne 0) {
    Write-Error "Build failed."
    exit 1
}

if (Test-Path ".\$testExe") {
    Write-Output "Running tests..."
    & ".\$testExe"
} else {
    Write-Error "Error: $testExe not found."
    exit 1
}

Write-Output "Cleaning build artifacts..."
Remove-Item -Recurse -Force $buildDir
Remove-Item -Force $testExe

Write-Output "Done."