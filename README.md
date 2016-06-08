# TiMi
TiMi - Clean Miskolc mobile and web application, to be used as a public failure reporting system, enables citizens to report local problems such as illegal trash dumping, non-working street lights, broken tiles on sidewalks and illegal advertising boards.

# Installation
After some bug fix, the new install script is uploaded as installscript1005.sh

WARNING!
- After a new installation procedure the earlier created polygons and multi-polygons (city or district borders) will be deleted. The default polygons are Miskolc and Thessaloniki remain intact.
- Earlier created user accounts will be deleted.

# Changelog
The issue counter the top right of the screen dynamically works now. It was a bug in JSON query.
The registration of a new sub-domain completed: timi.miskolc.hu. The sub-domain point out the IP address: 178.239.182.134

The newly created installation package contain one of the most important file: status.php which is missing from the earlier package.

# Usage
Because of Apache virtual host setting the application is not reachable by IP address, exclusively by the URL: http://timi.miskolc.hu.

