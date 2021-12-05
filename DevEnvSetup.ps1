#! /bin/bash

Set-Alias -Name echo -Value Write-Host
Set-Alias -Name sleep -Value Start-Sleep

echo 'New sh, starts'

echo 'Starting...'
sleep 4

echo 'Installing Kind...'
choco upgrade kind -y #-f
echo 'Kind installed'
sleep 0.5
# $exitCode = $LASTEXITCODE
# cat $exitCode >> dev.log.txt

echo 'Installing NuGet CLI...'
choco upgrade nuget.commandline -y #-f
echo 'NuGet CLI installed'
sleep 0.5

# echo 'Installing PIP...'
# choco upgrade pip -y #-f
# echo 'PIP installed'
# sleep 0.5

echo 'Installing Python...'
choco upgrade python -y #-f
echo 'Python installed'
sleep 0.5

echo 'Installing Minikube...'
choco upgrade minikube -y #-f
echo 'Minikube installed'
sleep 0.5

echo 'Installing Terraform...'
choco upgrade terraform -y #-f
echo 'Terraform installed'
sleep 0.5

echo 'Installing VIM...'
choco upgrade vim -y #-f
echo 'Vim installed'
sleep 0.5

echo 'Installing Tree...'
choco upgrade tree -y #-f
echo 'Tree installed'
sleep 0.5

echo 'Installing Git...'
choco upgrade git -y #-f
echo 'Git installed'
sleep 0.5

echo 'Installing Helm...'
choco upgrade kubernetes-helm -y #-f
echo 'Helm installed'
sleep 0.5

# echo 'Installing Vagrant...'
# choco upgrade vagrant -y #-f
# echo 'Vagrant installed'
# sleep 0.5

echo 'Installing Ruby...'
choco upgrade ruby -y #-f
echo 'Ruby installed'
sleep 0.5

echo 'Installing Puppet Development Kit...'
choco upgrade pdk -y #-f
echo 'PDK installed'
sleep 0.5

echo 'Installing Putty...'
choco upgrade putty -y #-f
echo 'Putty installed'
sleep 0.5

echo 'Installing PIP...'
choco upgrade pip -y #-f
echo 'PIP installed'
sleep 0.5

echo 'Installing AWS CLI...'
choco upgrade awscli -y #-f
echo 'AWSCLI installed'
sleep 0.5

echo 'Installing cURL...'
choco upgrade curl -y #-f
echo 'cURL installed'
sleep 0.5

echo 'Installing Choco cleaner...'
choco upgrade choco-cleaner -y
echo 'Choco cleaner installed'
sleep 0.5
echo 'Installations complete -DevEnv Setup!'

sleep 1

echo 'Refreshing environment variables'

foreach($level in "Machine","User") {
   [Environment]::GetEnvironmentVariables($level).GetEnumerator() | % {
      # For Path variables, append the new values, if they're not already in there
      if($_.Name -match 'Path$') { 
         $_.Value = ($((Get-Content "Env:$($_.Name)") + ";$($_.Value)") -split ';' | Select -unique) -join ';'
      }
      $_
   } | Set-Content -Path { "Env:$($_.Name)" }
}


echo 'Environment variable refreshed'

echo 'Clearing cache'
Set-ExecutionPolicy -ExecutionPolicy Unrestricted
C:\tools\BCURRAN3\choco-cleaner.ps1

$exitCode = $LASTEXITCODE
echo 'Cache claring complete'
echo exitCode

