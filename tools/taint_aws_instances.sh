#/usr/bin/env bash
for server in `terraform show -module-depth=1 | grep aws_instance | tr -d ':' | grep -v tainted`; do
  terraform taint  ${server}
done
