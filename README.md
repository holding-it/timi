# TiMi
TiMi - Clean Miskolc mobile and web application, to be used as a public failure reporting system, enables citizens to report local problems such as illegal trash dumping, non-working street lights, broken tiles on sidewalks and illegal advertising boards.

# Installation
The new installscript1007.sh available.

WARNING!
- After a new installation procedure the earlier created polygons and multi-polygons (city or district borders) will be deleted. The default polygons are Miskolc and Thessaloniki remain intact.
- Earlier created user accounts will be deleted.

# Changelog
The new install script (installscript1007.sh) contains some important row for perfect way to localizing application.
The installscript must be modified according to local needs!!!
During installation, a temporary file is created: update.sql which contains the required SQL commands.
If installation process successfully ended update.sql temporary file will be deleted.

# Usage
Because of Apache virtual host setting the application is not reachable by IP address, exclusively by the URL: http://timi.miskolc.hu.

