# Restart GlazeWM so config changes take effect. Used in place of
# wm-reload-config, which crashes GlazeWM 3.10.1 (glzr-io/glazewm#1438).

$cli = "$env:ProgramFiles\glzr.io\GlazeWM\cli\glazewm.exe"
$app = "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe"

& $cli command wm-exit | Out-Null

# Wait for GlazeWM to finish shutting down before starting it again, and
# force it closed if it hangs.
Get-Process glazewm -ErrorAction SilentlyContinue |
  Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
Stop-Process -Name glazewm -Force -ErrorAction SilentlyContinue

Start-Process $app
