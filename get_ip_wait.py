import boto3
import time

ecs = boto3.client('ecs', region_name='us-west-2')
ec2 = boto3.client('ec2', region_name='us-west-2')
cluster = 'vanlife-cluster-2471001'

while True:
    try:
        tasks = ecs.list_tasks(cluster=cluster, desiredStatus='RUNNING')['taskArns']
        if not tasks:
            time.sleep(2)
            continue
        
        td = ecs.describe_tasks(cluster=cluster, tasks=tasks)['tasks'][0]
        if td['lastStatus'] != 'RUNNING':
            time.sleep(2)
            continue
            
        eni = next((d['value'] for d in td['attachments'][0]['details'] if d['name'] == 'networkInterfaceId'), None)
        if eni:
            ip = ec2.describe_network_interfaces(NetworkInterfaceIds=[eni])['NetworkInterfaces'][0].get('Association', {}).get('PublicIp')
            if ip:
                print(ip)
                break
    except Exception as e:
        pass
    time.sleep(2)
