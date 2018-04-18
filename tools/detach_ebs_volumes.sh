#/usr/bin/env bash
region=""
for line in `terraform show  | grep id| grep vol- |grep -v root_block_device| grep -v volume_id`; do
  for volume in `echo $line| grep vol `;do
    region=$(terraform show | grep availability_zone -m 1 |awk '{ print $3; }'| rev| cut -c 2- | rev)
    aws ec2 detach-volume --volume-id=$volume --region=$region --force
  done
done

for line in `terraform show  | grep id| grep vol- |grep -v root_block_device| grep -v volume_id`; do
  for volume in `echo $line| grep vol `;do
    region=$(terraform show | grep availability_zone -m 1 |awk '{ print $3; }'| rev| cut -c 2- | rev)
  aws ec2 wait volume-available --volume-id=$volume --region=$region
  done
done
