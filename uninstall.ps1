# Removes LinkedIn on Windows: only the skill folders our installer marked as ours. Nothing you made with it is ever touched.
$ErrorActionPreference = "Stop"
$Commands = @("post", "comment", "reply", "profile", "plan", "cleanup", "carousel", "repurpose", "dm", "inbox", "audit")   # written by scripts/sync.py from skill.json
$removed = 0
foreach ($base in "linkedin", "bmac-linkedin") {
  foreach ($name in @($base) + @($Commands | ForEach-Object { "$base-$_" })) {
    $dir = Join-Path $HOME ".claude\skills\$name"
    if (-not (Test-Path -LiteralPath $dir)) { continue }
    if (Test-Path -LiteralPath (Join-Path $dir ".linkedin-install")) {
      Remove-Item -Recurse -Force -LiteralPath $dir; $removed++
    } else {
      Write-Output "Left $dir alone: LinkedIn did not install it."
    }
  }
}
if ($removed -gt 0) { Write-Output "Removed LinkedIn ($removed skill folders)." } else { Write-Output "LinkedIn was not installed." }
