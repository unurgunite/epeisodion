Set-Variable exe_dir -Option ReadOnly -Value "%appdata%/Spotify/Apps/"
Set-Variable ms_dir -Option ReadOnly -Value "%ProgramFiles%/WindowsApps"
Set-Variable package -Option ReadOnly -Value "SpotifyAB.SpotifyMusic"

function Downloaded-From-MStore
{
    if (Get-AppxPackage -Name $package)
    {
        return $true
    }
}

function Unzip-Package
{
    if (Downloaded-From-MStore)
    {
        $archive_dir = "$ms_dir/$package/Apps"
        Copy-Item "$archive_dir/xpui.xpa" -Destination "$archive_dir/xpui.xpa.bak"
        Expand-Archive "$archive_dir/xpui.xpa" -DestinationPath "$archive_dir/xpui"
    }
    else
    {
        Copy-Item "$exe_dir/xpui.xpa" -Destination "$exe_dir/xpui.xpa.bak"
        if (Test-Path -Path "$exe_dir/xpui.xpa.bak" -eq $false)
        {
            return 1
        }
        Expand-Archive "$exe_dir/xpui.xpa" -DestinationPath "$exe_dir"
    }
}
