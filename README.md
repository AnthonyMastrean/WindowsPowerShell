# About PowerShell Profiles
PowerShell can be a mystery when you first get started. There are some fundamentals though that are easy to build on. One of these fundamentals is the PowerShell profile. There are actually four [profiles][1], but we're concerned about the current user's Microsoft PowerShell shell profile.

Test if you have a profile script already (that's right, it's just a PowerShell script file). 

    PS> Test-Path $profile
    
If you don't have one yet, create it (and the whole directory structure) and open it in notepad

    PS> New-Item $profile -type File -force
    PS> notepad $profile
    
This script file is executed every time you start the Microsoft PowerShell shell. What can we do with this? How about: import [modules][2] or [scripts][3], define custom functions, variables, or [aliases][4], or change the [prompt][5]! You can see examples of all of these in my profile.

# Running Git on Windows
Many popular PowerShell modules and scripts are hosted on Github, so this is an important step. Let's get the git source control tool installed on our system, with custom git-status information showing up in our PowerShell prompt!

1. Start by installing the Windows package manager, [Chocolatey][6].
1. Install "git" using your new Chocolatey commands (`chocolatey install git` or `cinst git`).
1. You should be able to type the `git` command in your console now.
1. Later, you'll want to [setup your SSH keys][7] and git credentials.
1. Now, install the posh-git PowerShell module via Chocolatey (`cinst poshgit`).

This package provides custom git-status information on your console's prompt (like what branch you're on, how many edits are pending, etc). You'll go from

    PS\my-git-repo> 
    
to 

    PS\my-git-repo [master +0 ~1 -0]>

# Cloning Modules
Not all modules are packaged and published on Chocolatey. Often, you'll want to clone a module from a public or private source control host, like Github. If you're just getting started with PowerShell, you may not have a user `Modules` directory yet. That's where modules live, by default, so that you can import them without specifying a full file path (like `Import-Module posh-git`).

Of course there are many Module paths. You can create all of them at once with this command. Please pick apart the component parts to see what each portion of the command does!

    PS> $ENV:PsModulePath -split ';' | New-Item -type Directory -force

Browse to your user module directory from your current PowerShell session (explore the components of this statement, too).

    PS> cd (Split-Path $profile)
    PS> cd .\Modules

And use git to clone a module!

    PS\Modules> git clone git@github.com:someuser/coolpsmodule.git

# Importing Modules
Now that you have a module in your default user Module path, you can just add a line like this to your PowerShell profile.

    Import-Module coolpsmodule
    
If you reload your profile (try running your profile script... `. $PROFILE`), the module will be loaded. You can see what functionality the module has provided you with a simple command.

    PS> gcm -module coolpsmodule


 [1]: http://msdn.microsoft.com/en-us/library/bb613488.aspx
 [2]: http://msdn.microsoft.com/en-us/library/dd878324.aspx
 [3]: http://technet.microsoft.com/en-us/library/ee176949.aspx
 [4]: http://technet.microsoft.com/en-us/library/ee176913.aspx
 [5]: http://technet.microsoft.com/en-us/library/dd347633.aspx
 [6]: http://chocolatey.org
 [7]: http://help.github.com/win-set-up-git/
