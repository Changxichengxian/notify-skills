[CmdletBinding(PositionalBinding = $false)]
param(
  [ValidateSet("Default", "Asterisk", "Exclamation", "Hand", "Question", "Ok")]
  [string]$Sound = "Exclamation",

  [ValidateRange(1, 10)]
  [int]$Repeat = 1,

  [ValidateRange(0, 5000)]
  [int]$DelayMs = 250
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Get-SystemSound {
  param([Parameter(Mandatory = $true)][string]$Name)

  switch ($Name) {
    "Default" { return [System.Media.SystemSounds]::Beep }
    "Asterisk" { return [System.Media.SystemSounds]::Asterisk }
    "Exclamation" { return [System.Media.SystemSounds]::Exclamation }
    "Hand" { return [System.Media.SystemSounds]::Hand }
    "Question" { return [System.Media.SystemSounds]::Question }
    "Ok" { return [System.Media.SystemSounds]::Beep }
    default { throw "Unsupported sound: $Name" }
  }
}

$systemSound = Get-SystemSound -Name $Sound

for ($i = 0; $i -lt $Repeat; $i++) {
  $systemSound.Play()
  if ($i -lt ($Repeat - 1) -and $DelayMs -gt 0) {
    Start-Sleep -Milliseconds $DelayMs
  }
}

Write-Host "Played Windows notification sound: $Sound x$Repeat"
