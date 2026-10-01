# Restart GlazeWM so config changes take effect. Used in place of
# wm-reload-config, which crashes GlazeWM 3.10.1 (glzr-io/glazewm#1438).

$cli = "$env:ProgramFiles\glzr.io\GlazeWM\cli\glazewm.exe"
$app = "$env:ProgramFiles\glzr.io\GlazeWM\glazewm.exe"

& $cli command wm-exit | Out-Null

# Wait for GlazeWM and its watcher process to finish shutting down (the
# watcher briefly keeps GlazeWM's single-instance lock), forcing them closed
# if they hang.
Get-Process glazewm, glazewm-watcher -ErrorAction SilentlyContinue |
  Wait-Process -Timeout 10 -ErrorAction SilentlyContinue
Stop-Process -Name glazewm, glazewm-watcher -Force -ErrorAction SilentlyContinue

# Start it again. If it refused to start because the old instance hadn't
# fully let go yet, try a few more times.
for ($attempt = 1; $attempt -le 5; $attempt++) {
  Start-Process $app
  Start-Sleep -Seconds 2
  if (Get-Process glazewm -ErrorAction SilentlyContinue) { break }
}
