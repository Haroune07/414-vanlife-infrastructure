$env:AWS_ACCESS_KEY_ID="ASIAYL3NXQ3JMTST7Y3M"
$env:AWS_SECRET_ACCESS_KEY="rU3UXNZIoYyXDa4o3yUfGyAbvJYnJi2+uvUB1Ge6"
$env:AWS_SESSION_TOKEN="IQoJb3JpZ2luX2VjEBEaCXVzLXdlc3QtMiJHMEUCIAdGdWwZm93bh4ELBAMkURVcSUaPvDmfYVKHKvbzSLDiAiEAt4FrWM8mjhkWeIlcwXGtM/FPja8EyUVWha/N0l9H3P8qtgII2v//////////ARACGgw1NzUyMTg4NzgxNjIiDAwbJq2Mo/wxSM+kVSqKAgSco6J/pe7FvtDB2XeZv+cfTEa+M0sTG3Wj70v3Br5bfnWwKQZEiTXqsBBn7icZd0Wq7Dt8VJdKOWcd+I8+GaeLG2uEd0KeJ/YF99Jz79/Ob4wDqgD96aVf77b97HIOdEnmo3cXN/A5w2Y+RzuD375W2EOTLzY+AORtk+Tg5vxEWzhAWEBD9Pj1wchweHOdRUHWGl3tZPqGP8i7bJ5ib4N5EwngW8wLz/+7VKJXI1CrtCxYwnlTGcmB2tSCBKPOCARxPypWdyxly22iN98VR/ycXEBpXJLVqoQssZcmlHfrPTgkP7HQkhRbXcMHhbsWC6tQS+T2a47G7qSQwt4nrsuhczeGMV6XjqaWMPOF+s8GOp0BN+AXA7y0XvS8xR+LbMIl364PQUH2p9utzCYUtR2Y6Feen3k1zfKAxgmKsn/C4kht+U0a0eO1f6LA7poJE5tEkuYGT+euSfd/PuTvIx7daINa0+gUT/Qx1BrFBMxm9bjiyh59wSD+OX60gz34Bh2QE8NXDrnWbaMSVGWb7mIP2+UxA47v5TUae/yy5R/a03Bu7CHxmcAFA8GqfudL/A=="
$env:AWS_DEFAULT_REGION="us-west-2"

$CLUSTER="vanlife-cluster-2471001"
$TASK_ARN=(aws ecs list-tasks --cluster $CLUSTER --query "taskArns[0]" --output text)

if ($TASK_ARN -and $TASK_ARN -ne "None") {
    $ENI_ID=(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK_ARN --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" --output text)
    $PUBLIC_IP=(aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID --query "NetworkInterfaces[0].Association.PublicIp" --output text)
    Write-Host "VOTRE ADRESSE IP PUBLIQUE EST : $PUBLIC_IP"
} else {
    Write-Host "Aucune tâche n'est en cours d'exécution."
}
