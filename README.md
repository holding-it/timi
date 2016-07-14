# TiMi
TiMi - Clean Miskolc mobile and web application, to be used as a public failure reporting system, enables citizens to report local problems such as illegal trash dumping, non-working street lights, broken tiles on sidewalks and illegal advertising boards.

# Installation
The install script unchanged. The installscript1005.sh is continue to be used.

WARNING!
- After a new installation procedure the earlier created polygons and multi-polygons (city or district borders) will be deleted. The default polygons are Miskolc and Thessaloniki remain intact.
- Earlier created user accounts will be deleted.

# Changelog
The new install script (installscript1007.sh) contains some important row for perfect way to localizing application.

New variables in install script:

OPTIONAL SETTINGS
FOR LOCALIZED FOOTER SETTINGS PURPOSE
export -a LINKS=('Miskolc|www.miskolc.hu' 'Mvk|www.mvkzrt.hu')
export CONTACT_TELEFON="+36-70 000 0000"
export CONTACT_EMAIL="info@tisztamiskolc.hu"
export CONTACT_ADDRESS="Miskolc 20 Pf: 1-3"
export -a PARTS_OF_CITY=('Városrész01|www.varosresz1.hu' 'Városrész02|www.varosresz2.hu')
export -a POSSIBILITIES=('New announcement|#' 'Subscribe for newsletter|#' 'Location search|#')
export COPYRIGHT="Digitális Miskolc © 2016 | TIMI."

where
LINKS -> array, contains any number of elements separated by space
CONTACT_TELEFON -> simple variable, text
CONTACT_EMAIL -> simple variable, text
CONTACT_ADDRESS -> simple variable, text
PARTS_OF_CITY -> array, contains any number of elements separated by space
POSSIBILITIES -> array, contains any number of elements separated by space
COPYRIGHT -> simple variable, text

The installscript must be modified according to local needs!!!

During installation, a temporary file is created: update.sql which contains the required SQL commands.
If installation process successfully ended update.sql temporary file will be deleted.

# Usage
Because of Apache virtual host setting the application is not reachable by IP address, exclusively by the URL: http://timi.miskolc.hu.

