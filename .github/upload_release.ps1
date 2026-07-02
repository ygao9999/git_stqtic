$ErrorActionPreference = "Stop"

# Extract token from git credential manager
$credInput = "protocol=https`nhost=github.com`n"
$credOutput = $credInput | git credential fill 2>$null
$token = ($credOutput | Select-String "password=").ToString().Replace("password=", "")

# Create release
$body = @{
    tag_name = "toolchain-v1"
    name = "musl cross toolchain"
    body = "Pre-built aarch64-linux-musl-cross toolchain from musl.cc"
} | ConvertTo-Json

$headers = @{
    "Authorization" = "token $token"
    "Accept" = "application/vnd.github+json"
}

Write-Host "Creating release..."
$release = Invoke-RestMethod -Uri "https://api.github.com/repos/ygao9999/git_stqtic/releases" -Method Post -Headers $headers -Body $body -ContentType "application/json"
$uploadUrl = $release.upload_url -replace '\{.*\}', ''
Write-Host "Release created. Upload URL: $uploadUrl"

# Upload asset
Write-Host "Uploading toolchain.tgz (this may take a while)..."
$uploadHeaders = @{
    "Authorization" = "token $token"
    "Content-Type" = "application/gzip"
}
$result = Invoke-RestMethod -Uri "$uploadUrl`?name=toolchain.tgz" -Method Post -Headers $uploadHeaders -InFile "toolchain.tgz"
Write-Host "Upload complete! Download URL: $($result.browser_download_url)"
