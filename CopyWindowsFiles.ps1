$AlacrittyConfigFolder = "$env:APPDATA\alacritty"
if (-Not (Test-Path -PathType Container -Path "$AlacrittyConfigFolder")) {
    New-Item -ItemType Directory -Path "$AlacrittyConfigFolder"
}
Copy-Item -Path ".\.alacritty.windows.toml" -Destination "$AlacrittyConfigFolder\alacritty.toml"
$OmpConfig = ".\zen.omp.toml"
Copy-Item -Path $OmpConfig -Destination "$env:POSH_THEMES_PATH\zen.omp.toml"
Write-Output "Make sure to source $env:POSH_THEMES_PATH\zen.omp.toml as the OMP config in your PowerShell Profile"