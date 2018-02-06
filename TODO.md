1. Consider splitting up dev list. It's getting long.
2. When editing system files, use bak files and traps to make execution more
   failsafe.
3. Build a CI system to automatically test whether every function is working.
   Distro changes can sneak up on you.
4. Stop piping to \>/dev/null, it's hiding bugs from view.
5. Compute the latitude and longitude and substitute into redshift.conf. Right
   now, it's hard-coded to New York coordinates.
6. Edit text colors in terminal (dconf) so that highlighted text is visible in
   vimdiff.
7. Add test script to parse all source files for links and check if the links
   work.
8. Some functions fail when no desktop environment is running.
9. Setting the -e flag while using the check\_error function is redundant.
