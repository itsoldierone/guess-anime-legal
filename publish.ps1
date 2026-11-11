# 一次性发布：需先 gh auth login（选 GitHub.com → HTTPS → 浏览器登录）
$ErrorActionPreference = "Stop"
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

Set-Location $PSScriptRoot

gh auth status
if ($LASTEXITCODE -ne 0) {
	Write-Host "请先运行: gh auth login"
	exit 1
}

$exists = gh repo view itsoldierone/guess-anime-legal 2>$null
if ($LASTEXITCODE -ne 0) {
	gh repo create guess-anime-legal --public --description "猜动漫角色 TapTap 法务页" --source=. --remote=origin --push
} else {
	git push -u origin main
}

gh api -X POST repos/itsoldierone/guess-anime-legal/pages -f "build_type=legacy" -f "source[branch]=main" -f "source[path]=/docs" 2>$null
if ($LASTEXITCODE -ne 0) {
	Write-Host "Pages 若未开启：GitHub 仓库 → Settings → Pages → main /docs"
}

Write-Host ""
Write-Host "隐私: https://itsoldierone.github.io/guess-anime-legal/privacy.html"
Write-Host "协议: https://itsoldierone.github.io/guess-anime-legal/agreement.html"
Write-Host "等 1～3 分钟后用无痕浏览器打开确认。"
