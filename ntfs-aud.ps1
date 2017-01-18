# cycles through all child directories
# ' FREQUENTLY get "path too long" message due to long unc paths on subdirs
# ' This script can be run as ps1 or imported to profile to use as function

function Get-PathPermissions {
 
param ( [Parameter(Mandatory=$true)] [System.String]${Path} )
 
    begin {
    $root = Get-Item $Path
        ($root | get-acl).Access | Add-Member -MemberType NoteProperty -Name "Path" -Value $($root.fullname).ToString() -PassThru
    }
    process {
    $containers = Get-ChildItem -path $Path -recurse | ? {$_.psIscontainer -eq $true}
    if ($containers -eq $null) {break}
        foreach ($container in $containers)
        {
            (Get-ACL $container.fullname).Access | ? { $_.IsInherited -eq $false } | Add-Member -MemberType NoteProperty -Name "Path" -Value $($container.fullname).ToString() -PassThru
        }
    }
}

# edit here if you are using ps1 and not importing function
$path = "\\fullunc\path\to\dir"

get-pathpermissions -path $path | out-file permsout.txt