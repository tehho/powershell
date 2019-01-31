Param(
    )

if ($args[0] -eq "--list")
{
    kubectl config view -o json | ConvertFrom-Json | Select-Object -ExpandProperty Contexts | Select-Object -ExpandProperty name
    exit 0
}

kubectl config use-context $args[0]
kubectl proxy