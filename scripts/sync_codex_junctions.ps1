# sync_codex.sh의 정션 관리 파트 (PowerShell 위임).
# ~/.claude/skills의 각 스킬을 ~/.agents/skills에 스킬별 정션으로 노출한다.
#  - 제외 목록(codex/exclude-list.txt)에 있는 스킬은 건너뜀
#  - 대상이 사라진(고아) 정션과 제외 목록에 새로 오른 정션은 제거 (정션 제거는 원본에 무해)
#  - 비정션 폴더 발견 시: 저장소에 같은 이름 있으면 warn-copy, 없으면 new-skill 보고
# 출력은 기계 판독용 한 줄 포맷 — sync_codex.sh가 한국어 안내로 변환한다.
$ErrorActionPreference = 'SilentlyContinue'

$repoSkills   = Join-Path $env:USERPROFILE '.claude\skills'
$agentsSkills = Join-Path $env:USERPROFILE '.agents\skills'
$excludeFile  = Join-Path $env:USERPROFILE '.claude\codex\exclude-list.txt'

$exclude = @()
if (Test-Path $excludeFile) {
  $exclude = Get-Content $excludeFile |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -and -not $_.StartsWith('#') }
}

New-Item -ItemType Directory -Force $agentsSkills | Out-Null
$repoNames = (Get-ChildItem $repoSkills -Directory).Name

$created = @()
foreach ($name in $repoNames) {
  if ($exclude -contains $name) { continue }
  $link = Join-Path $agentsSkills $name
  if (-not (Test-Path $link)) {
    $target = Join-Path $repoSkills $name
    New-Item -ItemType Junction -Path $link -Target $target | Out-Null
    if (Test-Path $link) { $created += $name }
  }
}
if ($created.Count) { Write-Output ("junction-created: " + ($created -join ', ')) }

$removed = @()
foreach ($entry in Get-ChildItem $agentsSkills -Directory -Force) {
  $item = Get-Item $entry.FullName -Force
  if ($item.LinkType) {
    # 정션: 원본이 사라졌거나 제외 목록에 오르면 정리 (링크만 제거, 원본 무해)
    $orphan = -not (Test-Path (Join-Path $repoSkills $entry.Name))
    if ($orphan -or ($exclude -contains $entry.Name)) {
      $item.Delete()
      $removed += $entry.Name
    }
  }
  else {
    if ($repoNames -contains $entry.Name) { Write-Output ("warn-copy: " + $entry.Name) }
    else { Write-Output ("new-skill: " + $entry.Name) }
  }
}
if ($removed.Count) { Write-Output ("junction-removed: " + ($removed -join ', ')) }
