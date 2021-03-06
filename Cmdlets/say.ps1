Add-Type -AssemblyName System.Speech

function Speak-Text {
  param(
    [Parameter(Mandatory = $true)]
    [string] $text
  )

  $voice = New-Object -TypeName System.Speech.Synthesis.SpeechSynthesizer
  $voice.Speak($text)
}
