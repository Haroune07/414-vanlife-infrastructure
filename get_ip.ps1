$CLUSTER="vanlife-cluster-2471001"
$TASK_ARN=(aws ecs list-tasks --cluster $CLUSTER --query "taskArns[0]" --output text)

if ($TASK_ARN -and $TASK_ARN -ne "None") {
    $ENI_ID=(aws ecs describe-tasks --cluster $CLUSTER --tasks $TASK_ARN --query "tasks[0].attachments[0].details[?name=='networkInterfaceId'].value" --output text)
    $PUBLIC_IP=(aws ec2 describe-network-interfaces --network-interface-ids $ENI_ID --query "NetworkInterfaces[0].Association.PublicIp" --output text)
    Write-Host "VOTRE ADRESSE IP PUBLIQUE EST : $PUBLIC_IP"
} else {
    Write-Host "Aucune tâche n'est en cours d'exécution."
}
