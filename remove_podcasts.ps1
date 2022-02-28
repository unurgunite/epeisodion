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

function Stored-In-ProgramFiles-Folder
{
    if (Test-Path -Path $exe_dir)
    {
        return $true
    }
}

function File-Exists($path)
{
    if (Test-Path -Path $path -eq $true)
    {
        return $true
    }
    else
    {
        Write-Output "The $path file does not exist. Exiting"
        exit 1
    }
}


function Add-File-To-Archive($archive, $file)
{
    clear-host
    Add-Type -AssemblyName System.IO.Compression
    Add-Type -AssemblyName System.IO.Compression.FileSystem

    [System.IO.Compression.ZipArchive]$ZipFile = [System.IO.Compression.ZipFile]::Open($archive, ([System.IO.Compression.ZipArchiveMode]::Update))
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile($ZipFile, $file, (Split-Path $file -Leaf))
    $ZipFile.Dispose()
}

function Edit-Source($path, $ouput_dir)
{
    Add-Type -AssemblyName System.IO.Compression.FileSystem
    $Name = 'xpui.js'
    $zip = [System.IO.Compression.ZipFile]::OpenRead($path)
    $zip.Entries |
            Where-Object { $_.FullName -like $Name } |
            ForEach-Object {
                $FileName = $_.Name
                [System.IO.Compression.ZipFileExtensions]::ExtractToFile($_, "$ouput_dir", $true)
            }
    $zip.Dispose()
    (Get-Content "$path/$Name") -replace ',show,', ',' | Set-Content "$path/$Name"
    (Get-Content "$path/$Name") -replace ',episode${i}', '' | Set-Content "$path/$Name"
    Add-File-To-Archive($path, "$path/$Name")
}

function Unzip-Package
{
    if (Downloaded-From-MStore)
    {
        $archive_dir = "$ms_dir/$package/Apps"
        if (File-Exists("$exe_dir/xpui.xpa"))
        {
            Copy-Item "$archive_dir/xpui.xpa" -Destination "$archive_dir/xpui.xpa.bak"
        }
        File-Exists("$exe_dir/xpui.xpa.bak")
        Edit-Source("$archive_dir/xpui.xpa", "$archive_dir")
    }
    elseif (Stored-In-ProgramFiles-Folder)
    {
        if (File-Exists("$exe_dir/xpui.xpa"))
        {
            Copy-Item "$archive_dir/xpui.xpa" -Destination "$archive_dir/xpui.xpa.bak"
        }
        Copy-Item "$exe_dir/xpui.xpa" -Destination "$exe_dir/xpui.xpa.bak"
        if (Test-Path -Path "$exe_dir/xpui.xpa.bak" -eq $false)
        {
            return 1
        }
        Edit-Source("$exe_dir/xpui.xpa", "$exe_dir")
    }
    Stop-Process -Name "Spotify"
}
