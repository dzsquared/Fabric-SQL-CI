# modifies a SQL project file to enable SQL code analysis
# and set the rules to use from a rules config file

param(
    [Parameter(Mandatory=$true)]
    [string]$sqlProjectFile,

    [Parameter(Mandatory=$true)]
    [string]$sqlCodeAnalysisRulesFile
)

# Load the XML file
[xml]$xml = Get-Content $sqlProjectFile

# add RunSqlCodeAnalysis property to the project
$project = $xml.Project

$checkForSqlCodeAnalysis = $project.PropertyGroup | Where-Object { $_.RunSqlCodeAnalysis -ne $null }

if ($checkForSqlCodeAnalysis) {
    $runSqlCodeAnalysis = $xml.Project.PropertyGroup.RunSqlCodeAnalysis
    if ($runSqlCodeAnalysis -eq "false") {
        $xml.Project.PropertyGroup.RunSqlCodeAnalysis = "true"
    }

} else {
    $runSqlCodeAnalysis = $xml.CreateElement("RunSqlCodeAnalysis")
    $runSqlCodeAnalysis.InnerText = "true"
    $project.PropertyGroup.AppendChild($runSqlCodeAnalysis)
}

# read in SqlCodeAnalysisRules.config text
$sqlCodeAnalysisRules = Get-Content -Path $sqlCodeAnalysisRulesFile -Raw

$checkForSqlCodeAnalysisRules = $project.PropertyGroup | Where-Object { $_.SqlCodeAnalysisRules -ne $null }
if ($checkForSqlCodeAnalysisRules) {
    $sqlCodeAnalysisRulesProperty = $xml.Project.PropertyGroup.SqlCodeAnalysisRules
    if ($sqlCodeAnalysisRulesProperty -ne $sqlCodeAnalysisRules) {
        $xml.Project.PropertyGroup.SqlCodeAnalysisRules = $sqlCodeAnalysisRules
    }
} else {
    # create the SqlCodeAnalysisRules property
    $sqlCodeAnalysisRulesProperty = $xml.CreateElement("SqlCodeAnalysisRules")
    $sqlCodeAnalysisRulesProperty.InnerText = $sqlCodeAnalysisRules
    $project.PropertyGroup.AppendChild($sqlCodeAnalysisRulesProperty)
}


# write the changes back to the file
$xml.Save($sqlProjectFile)