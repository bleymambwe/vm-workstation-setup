# Disable password complexity requirement
secedit /export /cfg C:\secpol.cfg
(Get-Content C:\secpol.cfg) -replace "PasswordComplexity = 1", "PasswordComplexity = 0" | Set-Content C:\secpol.cfg
secedit /configure /db C:\Windows\security\local.sdb /cfg C:\secpol.cfg /areas SECURITYPOLICY
Remove-Item -Force C:\secpol.cfg -ErrorAction SilentlyContinue

# Set the simple password
net user bleymambwe todaytoday

Write-Output "Password set successfully"
