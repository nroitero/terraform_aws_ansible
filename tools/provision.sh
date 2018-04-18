#/usr/bin/env bash
ebs=$1
instance_id=$2
region=$3
count=$4
domain=$5
ssh_key_name=$6
public_ip=$7

ansible-galaxy install -r ansible/requirements.yml

if [ $ebs ]
then
  volume_id=$8
  ansible_verbosity=$9
  aws ec2 detach-volume --volume-id=$volume_id --region=$region --force 
  aws ec2 wait volume-available --volume-id=$volume_id --region=$region
  aws ec2 attach-volume --instance-id=$instance_id --volume-id=$volume_id --device=/dev/xvdh --region=$region
  ansible-playbook -u ubuntu  --extra-vars "hostname=app-$count.$domain" --extra-vars "ebs=true" --private-key secrets/$ssh_key_name.pem -i "$public_ip," ansible/master.yml $ansible_verbosity
else
  ansible_verbosity=$8
  ansible-playbook -u ubuntu  --extra-vars "hostname=app-$count.$domain" --extra-vars "ebs=false"  --private-key secrets/$ssh_key_name.pem -i "$public_ip," ansible/master.yml $ansible_verbosity
fi
