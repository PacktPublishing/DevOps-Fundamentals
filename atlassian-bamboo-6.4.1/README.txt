---------------------------------------------------------------------
Bamboo 6.4.1-#60405 README
---------------------------------------------------------------------

Thank you for downloading Bamboo 6.4.1 - Server distribution.  This
distribution comes with a built-in Tomcat 8.0.36-atlassian-hosted web server and H2
database, so it runs (almost) out the box.


BRIEF INSTALL GUIDE
-------------------


1. Install Java Development Kit (JDK) version 1.8 from

   http://www.oracle.com/technetwork/java/javase/downloads/index.html

2. Set the JAVA_HOME variable to where you installed Java (JDK not JRE inside it).


3. Set your Bamboo Home directory.
   Instructions how to set your Bamboo Home directory can be found here: https://confluence.atlassian.com/display/BAMBOO/Installing+and+upgrading


4. Run bin/start-bamboo.sh (*nix) or bin\start-bamboo.bat (Windows).
   Check that there are no errors on the console.  See below for troubleshooting advice.


5. Point your browser at http://localhost:8085/
   You should see Bamboo's Setup Wizard.


Full documentation is available online at:

  https://confluence.atlassian.com/display/BAMBOO/Installing+and+upgrading


PROBLEMS?
---------
A common startup problem is when another program has claimed port 8085, which
Bamboo is configured to run on by default.  To avoid this port conflict, Bamboo's
port can be changed in conf/server.xml.

If you have installation (or other) problems, please see the resources
listed at https://support.atlassian.com



QUESTIONS?
----------
Questions? Try the docs at:

   https://confluence.atlassian.com/display/BAMBOO/Bamboo+Documentation

Alternatively ask on the forums at:

   https://community.atlassian.com/

or ask Atlassian directly - see the contact info at
https://support.atlassian.com


-----------------------------------------------------------
Thank you for using Bamboo!
- The Atlassian Team
-----------------------------------------------------------
