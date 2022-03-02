# -------------------------------------------------------------------------------------------------
# Function name: Downloaded-From-MStore
# -------------------------------------------------------------------------------------------------
# Semantics:
# Function-predicate to check if Spotify is stored in std MS Store folder
# -------------------------------------------------------------------------------------------------
function Downloaded-From-MStore
{
    if (Get-AppxPackage -Name $package)
    {
        return $true
    }
}

# -------------------------------------------------------------------------------------------------
# Function name: Stored-In-ProgramFiles-Folder
# -------------------------------------------------------------------------------------------------
# Semantics:
# Function-predicate to check if Spotify is stored in std Program Files folder
# -------------------------------------------------------------------------------------------------
# Return:
# True                  - If Spotify exists in default programs folder
# -------------------------------------------------------------------------------------------------
function Stored-In-ProgramFiles-Folder
{
    if (Test-Path -Path $std_prog_dir)
    {
        return $true
    }
}

# -------------------------------------------------------------------------------------------------
# Function name: File-Exists
# -------------------------------------------------------------------------------------------------
# Semantics:
# Function-predicate to check if file exists
# -------------------------------------------------------------------------------------------------
# Return:
# True                  - If file exists
# -------------------------------------------------------------------------------------------------
function File-Exists($path)
{
    if ((Test-Path -Path $path) -eq $true)
    {
        return $true
    }
    else
    {
        Write-Output "The $path file does not exist. Exiting"
        exit 1
    }
}

# -------------------------------------------------------------------------------------------------
# Function name: Stop-Spotify-Process
# -------------------------------------------------------------------------------------------------
# Semantics:
# It kills all Spotify processes
# -------------------------------------------------------------------------------------------------
function Stop-Spotify-Process
{
    $spotify = Get-Process Spotify -ErrorAction SilentlyContinue
    if ($spotify)
    {
        $spotify.CloseMainWindow()
        Sleep 5
        if (!$spotify.HasExited)
        {
            $spotify | Stop-Process -Force
        }
    }
    Remove-Variable spotify
}

# -------------------------------------------------------------------------------------------------
# Function name: Edit-Source
# -------------------------------------------------------------------------------------------------
# Semantics:
# It edits source of the xpui.js file from `spa`-archive
# -------------------------------------------------------------------------------------------------
function Edit-Source($path)
{
    Add-Type -Assembly 'System.IO.Compression.FileSystem'
    $zip = [System.IO.Compression.ZipFile]::Open($path, 'update')
    $entry = $zip.GetEntry('xpui.js')

    $reader = New-Object System.IO.StreamReader($entry.Open())
    $xpuiContents = $reader.ReadToEnd()
    $reader.Close()
    if ($xpuiContents)
    {
        $xpuiContents = $xpuiContents -replace '\,show\,', '\,'
        $xpuiContents = $xpuiContents -replace '\,episode\${i}', ''

        $writer = New-Object System.IO.StreamWriter($entry.Open())
        $writer.BaseStream.SetLength(0)
        $writer.Write($xpuiContents)
        $writer.Close()
        $zip.Dispose()
    }
}

# -------------------------------------------------------------------------------------------------
# Function name: Unzip-Package
# -------------------------------------------------------------------------------------------------
# Semantics:
# It checks for installation source of Spotify and invoke other functions to unzip source files
# -------------------------------------------------------------------------------------------------
# Constants:
# $package              - Default package name
# $std_prog_dir         - Default programs folder
# $ms_progs_dir         - Default MS Store programs folder
# $ms_spotify_dir       - Default MS Store Spotify folder
# $ms_spa_file          - Default MS Store Spotify xpui.spa filename
# $ms_spa_file_bak      - Default MS Store Spotify xpui.spa backup filename
# $std_spa_file         - Default non-MS Store Spotify xpui.spa filename
# $std_spa_bak          - Default non-MS Store Spotify xpui.spa backup filename
# -------------------------------------------------------------------------------------------------
# Return:
# 1                     - If xpui.spa.bak does not exist
# 10                    - If no Spotify binaries were found
# -------------------------------------------------------------------------------------------------
function Unzip-Package
{
    Set-Variable package            -Option ReadOnly -Value "SpotifyAB.SpotifyMusic"
    Set-Variable std_prog_dir       -Option ReadOnly -Value "$env:APPDATA\Spotify\Apps"
    Set-Variable ms_progs_dir       -Option ReadOnly -Value "$env:PROGRAMFILES\WindowsApps"
    Set-Variable ms_spotify_dir     -Option ReadOnly -Value "$env:PROGRAMFILES\WindowsApps\$package"
    Set-Variable ms_spa_file        -Option ReadOnly -Value "$ms_spotify_dir\xpui.spa"
    Set-Variable ms_spa_file_bak    -Option ReadOnly -Value "$ms_spa_file.bak"
    Set-Variable std_spa_file       -Option ReadOnly -Value "$std_prog_dir\xpui.spa"
    Set-Variable std_spa_bak        -Option ReadOnly -Value "$std_spa_file.bak"
    if (Downloaded-From-MStore)
    {
        if (File-Exists("$ms_spa_file"))
        {
            Copy-Item "$ms_spa_file" -Destination "$ms_spa_file_bak"
        }
        File-Exists("$ms_spa_file_bak")
        Edit-Source("$ms_spa_file")
    }
    elseif (Stored-In-ProgramFiles-Folder)
    {
        if (File-Exists("$std_spa_file"))
        {
            Copy-Item "$std_spa_file" -Destination "$std_spa_bak"
        }
        Copy-Item "$std_spa_file" -Destination "$std_spa_bak"
        if ((Test-Path -Path "$std_spa_bak") -eq $false)
        {
            Write-Output "Can not create $std_spa_bak file"
            return 1
        }
        Edit-Source("$std_spa_file")
    }
    else
    {
        Write-Output "Can not find Spotify app. Is it stored on your PC?"
        return 10
    }
    Stop-Spotify-Process
}

# -------------------------------------------------------------------------------------------------
# Function name: main
# -------------------------------------------------------------------------------------------------
# Semantics:
# Entrypoint for the program
# -------------------------------------------------------------------------------------------------
function main
{
    Unzip-Package
}

main
