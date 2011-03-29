About PowerShell Profiles
==========
PowerShell can be a bit of a mystery when you get started. There are some fundamentals though that, once you get started, are easy to build on. One of these mysteries is the PowerShell profile. There are actually four [profiles](http://msdn.microsoft.com/en-us/library/bb613488.aspx)! But, the one I care about is the user profile that applies only to the Microsoft PowerShell shell. See if you have this profile already

    Test-Path $Profile
    
If you do, great! That's where we're going to do some work. If you don't, you can easily create it.

    New-Item -Path $profile -ItemType file -Force

Go ahead and navigate to your profile directory (in Windows Explorer or from the shell, whichever you're more comfortable with). Open up the user profile, it should be named

    Microsoft.PowerShell_profile.ps1
    
It's just a PowerShell script file that's executed every time you start the Microsoft PowerShell shell. Now, you're thinking "what can I do with this?". That's easy! Import [modules](http://msdn.microsoft.com/en-us/library/dd878324.aspx) or [scripts](http://technet.microsoft.com/en-us/library/ee176949.aspx), define functions, variables, or [aliases](http://technet.microsoft.com/en-us/library/ee176913.aspx), or change the [prompt](http://technet.microsoft.com/en-us/library/dd347633.aspx) (you can see examples of these in my profile).

Running Git on Windows
==========
There are many ways to run git on Windows. There are many shells to choose from, some GUI tools, but they all start with [msysgit](http://code.google.com/p/msysgit/). I install without any "Additional icons" or "Windows Explorer integration". This is because we're going to integrate git with our PowerShell console later. I select the option to run git from the Windows Command Prompt so that the git is added to my PATH automatically. And finally, for compatibility, I checkout Windows-style and commit Unix-style. This hasn't caused me any problems yet, and I believe is a configurable option (in case you work on a project that requires another option).

Confirm that the installation was successful by opening a PowerShell console and typing

    PS> git

You should see the git usage printed.