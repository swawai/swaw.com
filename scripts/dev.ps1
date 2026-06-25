Set-StrictMode -Version Latest

$ErrorActionPreference = 'Stop'

function Get-BanyanDevHelp {
    @'
Usage:
  dev.cmd [options] [-- extra hugo/dev-server options]

Options:
  -h, --help, /?             Show this help and exit.
  -p, --port <port>          Set the public dev server port. Default: 5120.
      --port=<port>
  -b, --bind <ip>            Set the public bind IP. Alias: --ip, --host.
      --bind=<ip>
      --ip <ip>
      --host <ip>
      --processes, --ps      List bun/node/hugo processes for this project.
      --stop, --kill         Stop bun/node/hugo processes for this project.

Environment:
  BANYAN_DEV_PORT            Default port when --port is omitted.
  BANYAN_DEV_BIND            Default bind IP when --bind/--ip is omitted.

Examples:
  dev.cmd
  dev.cmd --port 5121
  dev.cmd --ip 0.0.0.0 --port 5120
  dev.cmd --processes
  dev.cmd --stop
  dev.cmd -- --printPathWarnings
'@
}

function ConvertTo-BanyanDevOptions {
    param(
        [string[]] $CliArgs = @()
    )

    $bind = ''
    $port = ''
    $showHelp = $false
    $listProcesses = $false
    $stopProcesses = $false
    $forwardArgs = New-Object System.Collections.Generic.List[string]

    for ($index = 0; $index -lt $CliArgs.Count; $index += 1) {
        $arg = $CliArgs[$index]

        if ($arg -eq '--') {
            for ($forwardIndex = $index + 1; $forwardIndex -lt $CliArgs.Count; $forwardIndex += 1) {
                $forwardArgs.Add($CliArgs[$forwardIndex])
            }
            break
        }

        switch -Regex ($arg) {
            '^(--help|-h|/\?)$' {
                $showHelp = $true
                continue
            }
            '^(--processes|--ps|--list-processes)$' {
                $listProcesses = $true
                continue
            }
            '^(--stop|--kill|--kill-processes)$' {
                $stopProcesses = $true
                continue
            }
            '^(--port|-p)=(.+)$' {
                $port = $Matches[2]
                continue
            }
            '^(--bind|--ip|--host|-b)=(.+)$' {
                $bind = $Matches[2]
                continue
            }
            '^(--port|-p)$' {
                $index += 1
                if ($index -ge $CliArgs.Count -or [string]::IsNullOrWhiteSpace($CliArgs[$index])) {
                    throw "Missing value for $arg."
                }
                $port = $CliArgs[$index]
                continue
            }
            '^(--bind|--ip|--host|-b)$' {
                $index += 1
                if ($index -ge $CliArgs.Count -or [string]::IsNullOrWhiteSpace($CliArgs[$index])) {
                    throw "Missing value for $arg."
                }
                $bind = $CliArgs[$index]
                continue
            }
            default {
                $forwardArgs.Add($arg)
                continue
            }
        }
    }

    if ([string]::IsNullOrWhiteSpace($bind)) {
        $bind = $env:BANYAN_DEV_BIND
    }

    if ($showHelp -or $listProcesses -or $stopProcesses) {
        return [pscustomobject] @{
            Bind = $bind
            Port = $port
            ShowHelp = $showHelp
            ListProcesses = $listProcesses
            StopProcesses = $stopProcesses
            ForwardArgs = [string[]] $forwardArgs.ToArray()
        }
    }

    if ([string]::IsNullOrWhiteSpace($port)) {
        $port = $env:BANYAN_DEV_PORT
    }
    if ([string]::IsNullOrWhiteSpace($port)) {
        $port = '5120'
    }

    [int] $parsedPort = 0
    if (-not [int]::TryParse($port, [ref] $parsedPort) -or $parsedPort -lt 1 -or $parsedPort -gt 65535) {
        throw "Invalid --port value '$port'. Use a port from 1 to 65535."
    }

    [pscustomobject] @{
        Bind = $bind
        Port = [string] $parsedPort
        ShowHelp = $showHelp
        ListProcesses = $listProcesses
        StopProcesses = $stopProcesses
        ForwardArgs = [string[]] $forwardArgs.ToArray()
    }
}

function Resolve-BanyanDevBind {
    param(
        [string] $Bind
    )

    if (-not [string]::IsNullOrWhiteSpace($Bind)) {
        return $Bind
    }

    $detectedBind = Get-NetIPAddress -AddressFamily IPv4 -ErrorAction SilentlyContinue |
        Where-Object {
            $_.IPAddress -notlike '127.*' -and
            $_.IPAddress -notlike '169.254.*' -and
            $_.IPAddress -notlike '0.*'
        } |
        Sort-Object InterfaceMetric, InterfaceIndex |
        Select-Object -First 1 -ExpandProperty IPAddress

    if ([string]::IsNullOrWhiteSpace($detectedBind)) {
        return '127.0.0.1'
    }

    $detectedBind
}

function Get-BanyanProjectDevProcess {
    param(
        [Parameter(Mandatory)]
        [string] $RootDir
    )

    $root = (Resolve-Path -LiteralPath $RootDir).Path.TrimEnd('\')
    $rootAlt = $root.Replace('\', '/')

    Get-CimInstance Win32_Process |
        Where-Object {
            $_.CommandLine -and
            ($_.CommandLine -like ('*' + $root + '*') -or $_.CommandLine -like ('*' + $rootAlt + '*')) -and
            $_.Name -match '^(bun|node|hugo)(\.exe)?$'
        } |
        Sort-Object ProcessId |
        Select-Object ProcessId, Name, CommandLine
}

function Show-BanyanProjectDevProcesses {
    param(
        [Parameter(Mandatory)]
        [string] $RootDir
    )

    $processes = @(Get-BanyanProjectDevProcess -RootDir $RootDir)
    if ($processes.Count -eq 0) {
        Write-Host 'No bun/node/hugo project processes found.'
        return
    }

    $processes | Format-Table -Wrap
}

function Stop-BanyanProjectDevProcesses {
    param(
        [Parameter(Mandatory)]
        [string] $RootDir
    )

    $processes = @(Get-BanyanProjectDevProcess -RootDir $RootDir)
    if ($processes.Count -eq 0) {
        Write-Host 'No bun/node/hugo project processes found.'
        return 0
    }

    $processes | Format-Table -Wrap

    foreach ($process in $processes) {
        Stop-Process -Id $process.ProcessId -Force -ErrorAction Stop
    }

    Write-Host ("Stopped {0} project process(es)." -f $processes.Count)
    0
}

function Remove-BanyanPublicDirectory {
    param(
        [Parameter(Mandatory)]
        [string] $RootDir
    )

    $public = Join-Path $RootDir 'public'
    if (-not (Test-Path -LiteralPath $public)) {
        return
    }

    $resolved = (Resolve-Path -LiteralPath $public).Path
    $expected = [System.IO.Path]::GetFullPath((Join-Path $RootDir 'public'))

    if ($resolved.TrimEnd('\') -ne $expected.TrimEnd('\')) {
        throw "Refusing to delete unexpected path: $resolved"
    }

    Remove-Item -LiteralPath $resolved -Recurse -Force -ErrorAction Stop
}

function Invoke-BanyanDev {
    param(
        [string[]] $CliArgs = @(),
        [string] $RootDir = (Resolve-Path -LiteralPath (Join-Path $PSScriptRoot '..')).Path
    )

    $root = (Resolve-Path -LiteralPath $RootDir).Path
    $options = ConvertTo-BanyanDevOptions -CliArgs $CliArgs

    if ($options.ShowHelp) {
        Write-Host (Get-BanyanDevHelp)
        return 0
    }

    if ($options.ListProcesses) {
        Show-BanyanProjectDevProcesses -RootDir $root
        return 0
    }

    if ($options.StopProcesses) {
        return (Stop-BanyanProjectDevProcesses -RootDir $root)
    }

    $bind = Resolve-BanyanDevBind -Bind $options.Bind
    $xvenv = Join-Path $root '.xvenv\env.ps1'
    if (-not (Test-Path -LiteralPath $xvenv)) {
        throw "Missing xvenv environment: $xvenv"
    }

    . $xvenv

    if (-not (Get-Command bun -ErrorAction SilentlyContinue)) {
        throw 'bun was not found after loading .xvenv\env.ps1'
    }

    Remove-BanyanPublicDirectory -RootDir $root
    Set-Location -LiteralPath $root

    $env:BANYAN_DEV_BIND = $bind
    $env:BANYAN_DEV_PORT = $options.Port

    Write-Host ('Starting swaw.com dev server on {0}:{1}' -f $env:BANYAN_DEV_BIND, $env:BANYAN_DEV_PORT)

    $bun = (Get-Command bun -ErrorAction Stop).Source
    $devServerScript = 'themes/banyan/scripts/adapters/edgeone/dev-server.mjs'
    $devServerArgs = New-Object System.Collections.Generic.List[string]
    $devServerArgs.Add($devServerScript)
    $devServerArgs.Add('-D')
    if ($options.ForwardArgs.Count -gt 0) {
        $devServerArgs.Add('--')
        foreach ($arg in $options.ForwardArgs) {
            $devServerArgs.Add($arg)
        }
    }

    $process = Start-Process `
        -FilePath $bun `
        -ArgumentList $devServerArgs.ToArray() `
        -WorkingDirectory $root `
        -NoNewWindow `
        -Wait `
        -PassThru
    $process.ExitCode
}

if ($MyInvocation.InvocationName -ne '.') {
    try {
        $exitCode = Invoke-BanyanDev -CliArgs $args
        exit $exitCode
    } catch {
        [Console]::Error.WriteLine($_.Exception.Message)
        exit 1
    }
}
