$host.UI.RawUi.WindowTitle = ('{5}{0}@{1} [.NET {2}.{3}] ({4})' -f `
  $ENV:USERNAME, `
  $ENV:COMPUTERNAME, `
  $PSVersionTable.CLRVersion.Major, `
  $PSVersionTable.CLRVersion.Minor, `
  $(if([IntPtr]::Size -eq 8){'amd64'} else{'x86'}),
  $(if($host.UI.RawUI.WindowTitle.StartsWith('Administrator: ')){'Administrator: '})
)
