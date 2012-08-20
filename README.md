openport-fordynip
=================

Open (currently) SSH port for specific but changing IP address.

Tell the firewall (here: ufw managed) to allow SSH access
from a certain IP that is looked p via DNS everytime
the script runs (e.g. by CRON).

Remove the old rule if the IP address changes.

That way you can still use a knock daemon and keep port 22
closed for the wider audience while enjoying secure
and hassle-free public key authentication if you like.

Tested on newer Ubuntu.

