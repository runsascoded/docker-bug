#!/bin/bash

set -ex

# Permission denied!
ls -la /root || echo 'Failed'

# Peek as root
sudo ls -la /root

# Now it works 🤔
ls -la /root

