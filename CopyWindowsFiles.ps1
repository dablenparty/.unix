Write-Output "Copying PowerShell profile"
Copy-Item -Path ".\PowerShell_profile.ps1" -Destination $PROFILE
Write-Output "Copying Alacritty config"
$AlacrittyConfigFolder = "$env:APPDATA\alacritty"
if (-Not (Test-Path -PathType Container -Path "$AlacrittyConfigFolder")) {
    New-Item -ItemType Directory -Path "$AlacrittyConfigFolder"
}
Copy-Item -Path ".\alacritty\alacritty.windows.toml" -Destination "$AlacrittyConfigFolder\alacritty.toml"
Write-Output "Copying OMP config"
$OmpConfig = ".\zen.omp.toml"
Copy-Item -Path $OmpConfig -Destination "$env:POSH_THEMES_PATH\zen.omp.toml"
Write-Output "Make sure to source $env:POSH_THEMES_PATH\zen.omp.toml as the OMP config in your PowerShell Profile"
Write-Output "Copying neovim config"
$NeovimConfigFolder = "$env:LOCALAPPDATA\nvim"
Copy-Item -Path ".\nvim\.config\nvim" -Destination $NeovimConfigFolder -Recurse
