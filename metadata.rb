name             'drone-workstation'
maintainer       'Triple-networks'
maintainer_email 'r.gravestein@triple-networks.com'
license          'All rights reserved'
description      'Installs/Configures drone-workstation'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

# tested on O.S.
supports 'ubuntu', '>= 12.04'

# dependencies
depends 'drone', '~> 0.4.0'

# downloads.drone.io/latest/drone.deb