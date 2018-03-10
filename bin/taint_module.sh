#!/bin/bash

module=$1

for resource in `terraform show -module-depth=1 | grep module.${module} | tr -d ':' | sed -e 's/module.${module}.//'`; do
  terraform taint -module ${module} ${resource}
done