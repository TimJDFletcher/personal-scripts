#!/bin/env python
#
# NOTE: This assumes that all modules and versions are built for at
#       least one kernel. If that's not the case, adapt parsing as needed.
import os
import subprocess

# Permission check.
if os.geteuid() != 0:
    print "You need to be root to run this script."
    exit(1)

# Get DKMS status output.
cmd = ['dkms', 'status']
process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
dkms_status = process.communicate()[0].strip('\n').split('\n')
dkms_status = [x.split(', ') for x in dkms_status]

# Get kernel versions (probably crap).
cmd = ['ls', '/var/lib/initramfs-tools/']
process = subprocess.Popen(cmd, stdout=subprocess.PIPE)
kernels = process.communicate()[0].strip('\n').split('\n')

# Parse output, 'modules' will contain all modules pointing to a set
# of versions.
modules = {}

for entry in dkms_status:
   module = entry[0]
   version = entry[1]
   try:
      modules[module].add(version)
   except KeyError:
      # We don't have that module, add it.
      modules[module] = set([version])

# For each module, build all versions for all kernels.
for module in modules:
   for version in modules[module]:
      for kernel in kernels:
         cmd = ['dkms', 'build', '-m', module, '-v', version, '-k', kernel]
         ret = subprocess.call(cmd)
