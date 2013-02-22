function Get-Is64Bit { 
  (Get-WmiObject Win32_Processor) -eq 64
}