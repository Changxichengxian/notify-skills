param(
  [switch]$NoGui,
  [string]$UserName,
  [string]$ConfigPath,
  [string]$CredentialPath
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$skillRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$exampleConfigPath = Join-Path $skillRoot "references\config.example.json"

if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
  $ConfigPath = Join-Path $skillRoot "config.local.json"
}
if ([string]::IsNullOrWhiteSpace($CredentialPath)) {
  $CredentialPath = Join-Path $skillRoot "credentials.local.xml"
}

if (-not (Test-Path -LiteralPath $exampleConfigPath)) {
  throw "Missing file: $exampleConfigPath"
}

if (-not (Test-Path -LiteralPath $ConfigPath)) {
  Copy-Item -LiteralPath $exampleConfigPath -Destination $ConfigPath -Force
  Write-Host "Created $ConfigPath"
  Write-Host "Edit it before sending a real email."
} else {
  Write-Host "Found $ConfigPath"
}

Write-Host ""
Write-Host "Save SMTP credential to $CredentialPath"
Write-Host "Tip: use the SMTP auth code or app password, not the web login password."
Write-Host ""

if ($NoGui) {
  if ([string]::IsNullOrWhiteSpace($UserName)) {
    $UserName = Read-Host "SMTP username (usually the sender email)"
  }
  $securePassword = Read-Host "SMTP auth code / app password" -AsSecureString
  $credential = New-Object System.Management.Automation.PSCredential($UserName, $securePassword)
} else {
  $credential = Get-Credential -Message "Enter SMTP username (email) and SMTP auth code / app password"
}

$credential | Export-Clixml -LiteralPath $CredentialPath

Write-Host ""
Write-Host "Done."
Write-Host "Next:"
Write-Host "  1) Edit the config file if needed."
Write-Host "  2) Dry run send-task-email.ps1 before sending a real message."
