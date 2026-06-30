param(
    [ValidateSet("sync", "build", "run", "check", "all")]
    [string]$Action = "all",

    [Parameter(Mandatory = $true)]
    [string]$RemoteHost,

    [string]$RemoteRoot = "~/Verilog",

    [string]$LabRelPath = "lab8/lab8_flow_fast/lab8_flow_fast"
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

function Copy-FileToRemote {
    param(
        [Parameter(Mandatory = $true)]
        [string]$LocalPath,

        [Parameter(Mandatory = $true)]
        [string]$RemotePath
    )

    if (-not (Test-Path -LiteralPath $LocalPath)) {
        return
    }

    Write-Host "[scp] $LocalPath -> $RemotePath"
    & scp $LocalPath "$RemoteHost`:$RemotePath"
    if ($LASTEXITCODE -ne 0) {
        throw "SCP failed with exit code $LASTEXITCODE"
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

if (-not (Test-Path -LiteralPath $localLabPath)) {
    throw "Local path does not exist: $localLabPath"
}

$filesToSync = @(
    "accelerator.v",
    "mem.v",
    "testbench_top.v",
    "makefile",
    "sim_main.cpp",
    "InputGen.py",
    "CheckResult.py",
    "input_mem.csv",
    "result_mem.csv",
    "in.npy"
)

function Sync-Lab {
    Invoke-RemoteCommand "mkdir -p \"$remoteLabPath\""
    foreach ($name in $filesToSync) {
        $localFile = Join-Path $localLabPath $name
        Copy-FileToRemote -LocalPath $localFile -RemotePath "$remoteLabPath/$name"
    }
}

function Build-Lab {
    Invoke-RemoteCommand "cd \"$remoteLabPath\" && make verilator"
    Invoke-RemoteCommand "cd \"$remoteLabPath/obj_dir\" && make -f Vtestbench_top.mk"
}

function Run-Lab {
    Invoke-RemoteCommand "cd \"$remoteLabPath/obj_dir\" && ./Vtestbench_top"
}

function Check-Lab {
    Invoke-RemoteCommand "cd \"$remoteLabPath\" && python3 CheckResult.py"
}

switch ($Action) {
    "sync" {
        Sync-Lab
    }
    "build" {
        Build-Lab
    }
    "run" {
        Run-Lab
    }
    "check" {
        Check-Lab
    }
    "all" {
        Sync-Lab
        Build-Lab
        Run-Lab
        Check-Lab
    }
}

Write-Host "Done: $Action"
