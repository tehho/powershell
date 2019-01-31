Param(
  [string]$sshFile = "$ENV:USERPROFILE/.ssh/id_key",
  [string]$nodeResourceGroup = "",
  [string]$username = "azureuser"
)

if (-not (Test-Path $sshFile))
{
  ssh-keygen -f $sshFile
}

$nodes = az vm list --resource-group $nodeResourceGroup -o json | ConvertFrom-Json | ForEach-Object { $_ | Select-Object -ExpandProperty name }

workflow AddSshToNodes {
  param (
    [string[]] $nodes,
    [string] $nodeResourceGroup,
    [string] $sshFile,
    [string] $username
  )

  foreach -parallel ($node in $nodes) {
    $node
    az vm user update --resource-group $nodeResourceGroup --name $node --username $username --ssh-key-value "$sshFile.pub"
  }
   
}

AddSshToNodes -nodes $nodes -nodeResourceGroup $nodeResourceGroup -sshFile $sshFile -username $username