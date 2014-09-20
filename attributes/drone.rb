#
# Cookbook Name:: drone-workstation
# Attributes:: drone
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

default['drone']['package_url'] = 'http://downloads.drone.io/latest/drone.deb'
default['drone']['temp_file'] = '/tmp/drone.deb'
default['drone']['config_file'] = '/etc/init/drone.conf'
default['drone']['droned_opts'] = '--port=:80'
default['drone']['drone_tmp'] = '/tmp/drone'
