1. Build a CI system to automatically test whether every function is working.
   Distro changes can sneak up on you.
2. Stop piping to \>/dev/null, it's hiding bugs from view.
3. Compute the latitude and longitude and substitute into redshift.conf. Right
   now, it's hard-coded to New York coordinates.
4. Add test script to parse all source files for links and check if the links
   work.
5. Some functions fail when no desktop environment is running.
6. Setting the -e flag while using the check\_error function is redundant.
