1. Consider splitting up dev list. It's getting long.
2. When editing system files, use bak files and traps to make execution more
   failsafe.
3. Make dotfiles a separate repo and include it here as a git submodule.
4. Build a CI system to automatically test whether every function is working.
   Distro changes can sneak up on you.
5. Stop piping to >/dev/null, it's hiding bugs from view.
