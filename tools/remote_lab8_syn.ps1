param(
    [ValidateSet("sync", "pre", "syn", "post", "fetch", "all")]
    [string]$Action = "all",

    [ValidateSet("auto", "iverilog", "vcs")]
    [string]$SimTool = "auto",

    [string]$RemoteHost = "digital_system_xzx",

    [string]$RemoteRoot = "~/Verilog",

    [string]$LabRelPath = "lab8_syn"
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Invoke-RemoteCommand {
    param(
        [Parameter(Mandatory = $true)]
        [string]$Command
    )

    Write-Host "[remote] $Command"
    & ssh $RemoteHost $Command
    if ($LASTEXITCODE -ne 0) {
        throw "Remote command failed with exit code $LASTEXITCODE"
    }
}

function Copy-DirectoryToRemote {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath
    )

    if (-not (Test-Path -LiteralPath $LocalPath)) {
        throw "Local path does not exist: $LocalPath"
    }

    Write-Host "[scp] $LocalPath -> $RemotePath"
    & scp -r $LocalPath "$RemoteHost`:$RemotePath"
    if ($LASTEXITCODE -ne 0) {
        throw "SCP failed with exit code $LASTEXITCODE"
    }
}

function Copy-FileToRemote {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter(Mandatory = $true)]
        [string]$RemoteDirForMkdir
    )

    if (-not (Test-Path -LiteralPath $LocalPath)) {
        Write-Warning "Skip missing local file: $LocalPath"
        return
    }

    Invoke-RemoteCommand ("mkdir -p {0}" -f $RemoteDirForMkdir)
    Write-Host "[scp] $LocalPath -> $RemotePath"
    & scp $LocalPath "$RemoteHost`:$RemotePath"
    if ($LASTEXITCODE -ne 0) {
        throw "SCP failed with exit code $LASTEXITCODE"
    }
}

function Try-CopyRemoteToLocal {
    param(
        [Parameter(Mandatory = $true)]
        [string]$RemotePath,

        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [switch]$Recursive
    )

    if (-not (Test-Path -LiteralPath $LocalPath)) {
        New-Item -ItemType Directory -Path $LocalPath -Force | Out-Null
    }

    $args = @()
    if ($Recursive) {
        $args += "-r"
    }
    $args += "$RemoteHost`:$RemotePath"
    $args += $LocalPath

    Write-Host "[scp] $($args -join ' ')"
    & scp @args
    if ($LASTEXITCODE -ne 0) {
        Write-Warning "Skip missing or inaccessible path: $RemotePath"
    }
}

$workspaceRoot = Split-Path -Parent $PSScriptRoot
$localLabPath = Join-Path $workspaceRoot ($LabRelPath -replace '/', [IO.Path]::DirectorySeparatorChar)

$remoteRootExpanded = $RemoteRoot
if ($RemoteRoot -eq "~") {
    $remoteRootExpanded = '$HOME'
}
elseif ($RemoteRoot.StartsWith("~/")) {
    $remoteRootExpanded = '$HOME/' + $RemoteRoot.Substring(2)
}

$remoteLabPath = "$remoteRootExpanded/$LabRelPath" -replace "//+", "/"
$remoteRootForScp = $RemoteRoot
$remoteLabPathForScp = "$remoteRootForScp/$LabRelPath" -replace "//+", "/"

$localPdkDbPath = Join-Path $workspaceRoot "lab7\ExampleDesign-15nm(1)\ExampleDesign-15nm\pdk\NanGate_15nm\front_end\timing_power_noise\CCS\NanGate_15nm_OCL_slow_conditional_ccs.db"
$localPdkVerilogPath = Join-Path $workspaceRoot "lab7\ExampleDesign-15nm(1)\ExampleDesign-15nm\pdk\NanGate_15nm\front_end\verilog\NanGate_15nm_OCL_conditional.v"

$remotePdkDbDirExpanded = "$remoteLabPath/pdk"
$remotePdkVerilogDirExpanded = "$remoteLabPath/pdk"

$remotePdkDbPathForScp = "$remoteLabPathForScp/pdk/NanGate_15nm_OCL_slow_conditional_ccs.db"
$remotePdkVerilogPathForScp = "$remoteLabPathForScp/pdk/NanGate_15nm_OCL_conditional.v"

function Sync-Lab {
    Invoke-RemoteCommand ("mkdir -p `"{0}`"" -f $remoteRootExpanded)
    Copy-DirectoryToRemote -LocalPath $localLabPath -RemotePath "$remoteRootForScp"

    # Keep lab8_syn relative PDK references valid on remote.
    Copy-FileToRemote -LocalPath $localPdkDbPath -RemotePath $remotePdkDbPathForScp -RemoteDirForMkdir $remotePdkDbDirExpanded
    Copy-FileToRemote -LocalPath $localPdkVerilogPath -RemotePath $remotePdkVerilogPathForScp -RemoteDirForMkdir $remotePdkVerilogDirExpanded
}

function Run-PreSim {
    switch ($SimTool) {
        "iverilog" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/pre-syn`" && make" -f $remoteLabPath)
        }
        "vcs" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/pre-syn`" && bash run_vcs_bash.sh" -f $remoteLabPath)
        }
        "auto" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/pre-syn`" && if command -v iverilog >/dev/null 2>&1; then make; elif command -v vcs >/dev/null 2>&1; then bash run_vcs_bash.sh; else echo 'No simulator found: need iverilog or vcs'; exit 127; fi" -f $remoteLabPath)
        }
    }
}

function Run-Synthesis {
    Invoke-RemoteCommand ("cd `"{0}/syn`" && make" -f $remoteLabPath)
}

function Run-PostSim {
    switch ($SimTool) {
        "iverilog" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/post-syn`" && make" -f $remoteLabPath)
        }
        "vcs" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/post-syn`" && bash run_vcs_bash.sh" -f $remoteLabPath)
        }
        "auto" {
            Invoke-RemoteCommand ("cd `"{0}/testbench/post-syn`" && if command -v iverilog >/dev/null 2>&1; then make; elif command -v vcs >/dev/null 2>&1; then bash run_vcs_bash.sh; else echo 'No simulator found: need iverilog or vcs'; exit 127; fi" -f $remoteLabPath)
        }
    }
}

function Fetch-Lab {
    Write-Host "[scp] $RemoteHost`:$remoteLabPathForScp/. -> $localLabPath"
    & scp -r "$RemoteHost`:$remoteLabPathForScp/." $localLabPath
    if ($LASTEXITCODE -ne 0) {
        throw "SCP failed with exit code $LASTEXITCODE"
    }

    Write-Host "Full lab synchronized back to local: $localLabPath"
}

switch ($Action) {
    "sync" {
        Sync-Lab
    }
    "pre" {
        Run-PreSim
    }
    "syn" {
        Run-Synthesis
    }
    "post" {
        Run-PostSim
    }
    "fetch" {
        Fetch-Lab
    }
    "all" {
        $stageErrors = @()

        try {
            Sync-Lab
        }
        catch {
            $stageErrors += "sync: $($_.Exception.Message)"
        }

        try {
            Run-PreSim
        }
        catch {
            $stageErrors += "pre: $($_.Exception.Message)"
        }

        try {
            Run-Synthesis
        }
        catch {
            $stageErrors += "syn: $($_.Exception.Message)"
        }

        try {
            Run-PostSim
        }
        catch {
            $stageErrors += "post: $($_.Exception.Message)"
        }

        try {
            Fetch-Lab
        }
        catch {
            $stageErrors += "fetch: $($_.Exception.Message)"
        }

        if ($stageErrors.Count -gt 0) {
            throw ("One or more stages failed:`n" + ($stageErrors -join "`n"))
        }
    }
}

Write-Host "Done: $Action"
