$BackgroundColor = $host.ui.rawui.BackgroundColor
$ForegroundColor = $host.ui.rawui.ForegroundColor

function Reset-ConsoleColors {
    $Host.UI.RawUI.BackgroundColor = $BackgroundColor
    $Host.UI.RawUI.ForegroundColor = $ForegroundColor
}
