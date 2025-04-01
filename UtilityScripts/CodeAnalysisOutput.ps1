# output markdown summary of sql code analysis errors and warnings
# parsed out of build output file

param(
    [Parameter(Mandatory=$true)]
    [string]$buildOutputFile
)


$markdownOutput = ""
# read in build output from buildoutput.txt
$buildOutput = Get-Content -Path $buildOutputFile -Raw
# split the output into lines
$lines = $buildOutput -split "`n"
# initialize an array to hold the warnings and errors
$warnings = @()
$caErrors = @()

# for each line in the output, look for "StaticCodeAnalysis warning"
foreach ($line in $lines) {
    # if the line contains "StaticCodeAnalysis warning"
    if ($line -match "StaticCodeAnalysis warning" -or $line -match "StaticCodeAnalysis error") {
        # split the line into parts
        $parts = $line -split ": "
        # get the warning message
        $warningMessage = $parts[1..($parts.Length - 1)] -join ": "
        $filePath = $parts[0] -replace ".*?([^\s]+)$", '$1'

        if ($line -match "StaticCodeAnalysis error") {
            # if the line contains "StaticCodeAnalysis error", add it to the errors array
            $caErrors += [PSCustomObject]@{
                Message = $warningMessage
                FilePath = $filePath
            }
        } else {
            # if the line contains "StaticCodeAnalysis warning", add it to the warnings array
            $warnings += [PSCustomObject]@{
                Message = $warningMessage
                FilePath = $filePath
            }
        }
    }
}

if ($caErrors.Count -eq 0) {
    # if there are no errors, output a message
    $markdownOutput += "# ✅ No Code Analysis Errors`n"
} else {
    # if there are errors, output the header
    $markdownOutput += "# ❌ Code Analysis Errors`n"
}
foreach ($caError in $caErrors) {
    # add the error to the markdown output
    $markdownOutput += "- **$($caError.Message)** $($caError.FilePath)`n"
}

$markdownOutput += "`n"

if ($warnings.Count -eq 0) {
    # if there are no warnings, output a message
    $markdownOutput += "# ✅ No Code Analysis Warnings`n"
} else {
    # if there are warnings, output the header
    $markdownOutput += "# 🟡 Code Analysis Warnings`n"
}

foreach ($warning in $warnings) {
    # add the warning to the markdown output
    $markdownOutput += "- **$($warning.Message)** $($warning.FilePath)`n"
}

# write the markdown output to a file
$markdownOutput | Out-File -FilePath "CodeAnalysisWarnings.md" -Encoding utf8