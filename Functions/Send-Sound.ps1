function Send-Sound { 
  param(
    [ValidateNotNullOrEmpty()]
    [string] $name = 'Beep'
  )

  [System.Media.SystemSounds]::$name.Play()
}

function Send-Beep { 
  Send-Sound -Name 'Beep'
}

function Send-Notify { 
  Send-Sound -Name 'Exclamation'
}

function Send-Error { 
  Send-Sound -Name 'Hand'
}

function Send-Warning { 
  Send-Sound -Name 'Asterisk'
}
