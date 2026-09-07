#!/usr/bin/env bash

set -x

# run this AFTER unboxing!!!
systemd-tmpfiles --create /etc/tmpfiles.d/thp.conf
