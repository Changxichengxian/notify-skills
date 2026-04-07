[CmdletBinding(PositionalBinding = $false)]
param(
  [Parameter(Mandatory = $true)]
  [string]$Subject,

  [string]$Body = "",

  [string]$BodyFile,

  [switch]$IsHtml,

  [string[]]$Attachments,

  [string]$ConfigPath,

  [string]$CredentialPath,

  [switch]$DryRun
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

try {
  [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
} catch {
}

$skillRoot = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot "..")).Path
$defaultConfigPath = Join-Path $skillRoot "config.local.json"
$defaultCredentialPath = Join-Path $skillRoot "credentials.local.xml"

if ([string]::IsNullOrWhiteSpace($ConfigPath)) {
  $ConfigPath = $defaultConfigPath
}
if ([string]::IsNullOrWhiteSpace($CredentialPath)) {
  $CredentialPath = $defaultCredentialPath
}

function Read-JsonFile {
  param([Parameter(Mandatory = $true)][string]$Path)
  if (-not (Test-Path -LiteralPath $Path)) {
    throw "Missing file: $Path"
  }

  $raw = Get-Content -LiteralPath $Path -Raw
  if ([string]::IsNullOrWhiteSpace($raw)) {
    throw "Empty JSON file: $Path"
  }

  return $raw | ConvertFrom-Json
}

$config = Read-JsonFile -Path $ConfigPath

if (-not $config.smtp.host) { throw "Missing config: smtp.host" }
if (-not $config.smtp.port) { throw "Missing config: smtp.port" }
if ($null -eq $config.smtp.useSsl) { throw "Missing config: smtp.useSsl" }
if (-not $config.mail.from) { throw "Missing config: mail.from" }
if (-not $config.mail.to -or $config.mail.to.Count -lt 1) { throw "Missing config: mail.to (array)" }

if ($BodyFile) {
  if (-not (Test-Path -LiteralPath $BodyFile)) {
    throw "Missing BodyFile: $BodyFile"
  }
  $Body = Get-Content -LiteralPath $BodyFile -Raw
}

$smtpHost = [string]$config.smtp.host
$smtpPort = [int]$config.smtp.port
$useSsl = [bool]$config.smtp.useSsl

$from = [string]$config.mail.from
$toList = @($config.mail.to | ForEach-Object { [string]$_ } | Where-Object { -not [string]::IsNullOrWhiteSpace($_) })
if ($toList.Count -lt 1) { throw "mail.to has no valid recipients" }

$subjectPrefix = ""
if ($config.subjectPrefix) { $subjectPrefix = [string]$config.subjectPrefix }
$finalSubject = if ([string]::IsNullOrWhiteSpace($subjectPrefix)) { $Subject } else { "$subjectPrefix $Subject" }

if ($DryRun) {
  Write-Host "DRY RUN - would send email"
  Write-Host "  SMTP : ${smtpHost}:${smtpPort} (SSL=$useSsl)"
  Write-Host "  From : $from"
  Write-Host "  To   : $($toList -join ', ')"
  Write-Host "  Subj : $finalSubject"
  Write-Host "  Body : $([Math]::Min(($Body | Measure-Object -Character).Characters, 2000)) chars"
  if ($Attachments) {
    Write-Host "  Att  : $($Attachments -join ', ')"
  }
  Write-Host "  Cred : $CredentialPath"
  return
}

if (-not (Test-Path -LiteralPath $CredentialPath)) {
  throw "Missing credential file: $CredentialPath (run setup-smtp-credential.ps1 first)"
}
$credential = Import-Clixml -LiteralPath $CredentialPath

$mailMessage = New-Object System.Net.Mail.MailMessage
$mailMessage.From = $from
foreach ($recipient in $toList) {
  [void]$mailMessage.To.Add($recipient)
}
$mailMessage.Subject = $finalSubject
$mailMessage.Body = $Body
$mailMessage.IsBodyHtml = [bool]$IsHtml

if ($Attachments) {
  foreach ($attachmentPath in $Attachments) {
    if ([string]::IsNullOrWhiteSpace($attachmentPath)) { continue }
    if (-not (Test-Path -LiteralPath $attachmentPath)) {
      throw "Missing attachment: $attachmentPath"
    }
    $attachment = New-Object System.Net.Mail.Attachment($attachmentPath)
    [void]$mailMessage.Attachments.Add($attachment)
  }
}

$smtpClient = New-Object System.Net.Mail.SmtpClient($smtpHost, $smtpPort)
$smtpClient.EnableSsl = $useSsl
$smtpClient.UseDefaultCredentials = $false
$smtpClient.Timeout = 30000
$smtpPassword = $credential.GetNetworkCredential().Password
if ($smtpPassword -match "\s") {
  $smtpPassword = ($smtpPassword -replace "\s", "")
}
$smtpClient.Credentials = New-Object System.Net.NetworkCredential($credential.UserName, $smtpPassword)

try {
  $smtpClient.Send($mailMessage)
  Write-Host "Email sent to: $($toList -join ', ')"
} catch [System.Net.Mail.SmtpFailedRecipientException] {
  $ex = $_.Exception
  $lines = @(
    "Send failed (SmtpFailedRecipientException): $($ex.Message)",
    "StatusCode: $($ex.StatusCode)",
    "FailedRecipient: $($ex.FailedRecipient)"
  )
  if ($ex.InnerException) {
    $lines += "Inner: $($ex.InnerException.GetType().FullName): $($ex.InnerException.Message)"
  }
  throw ($lines -join "`r`n")
} catch [System.Net.Mail.SmtpException] {
  $ex = $_.Exception
  $lines = @(
    "Send failed (SmtpException): $($ex.Message)",
    "StatusCode: $($ex.StatusCode)"
  )
  if ($ex.InnerException) {
    $lines += "Inner: $($ex.InnerException.GetType().FullName): $($ex.InnerException.Message)"
  }
  $lines += ""
  $lines += "Hints:"
  $lines += "- Use the SMTP auth code or app password, not the web login password."
  $lines += "- For QQ Mail, try smtp.qq.com with port 587 first, then 465 if needed."
  $lines += "- If the inner error looks like a connection problem, check the current network."
  throw ($lines -join "`r`n")
} catch {
  $ex = $_.Exception
  $lines = @("Send failed: $($ex.GetType().FullName): $($ex.Message)")
  if ($ex.InnerException) {
    $lines += "Inner: $($ex.InnerException.GetType().FullName): $($ex.InnerException.Message)"
  }
  throw ($lines -join "`r`n")
} finally {
  $mailMessage.Dispose()
  $smtpClient.Dispose()
}
