function Send-Sound { 
  <#
    .SYNOPSIS
    Play a sound!
    
    .DESCRIPTION
    Play one of the built-in system sounds from your current sound scheme.
    
    .PARAMETER name
    Beep, Exclamation, Hand, Asterisk, or Question
    
    .LINK
    http://msdn.microsoft.com/en-us/library/system.media.systemsounds(v=vs.110).aspx
  #>

  param(
    [Parameter(Mandatory = $false)]
    [ValidateNotNullOrEmpty()]
    [string] $name = "Beep"
  )

  [System.Media.SystemSounds]::$name.Play()
}
