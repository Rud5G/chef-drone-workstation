#
# Cookbook Name:: drone-workstation
# Recipe:: drone
#
# Copyright (c) 2014 The Authors, All Rights Reserved.

# install drone with chef-drone
include_recipe 'drone::default'




# http://drone.readthedocs.org/en/latest/install.html

# installation:
#   $ wget http://downloads.drone.io/latest/drone.deb
#   $ sudo dpkg -i drone.deb