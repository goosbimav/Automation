Param (
	#List of Values to read in from a .CSV file
	[String]$List = "D:\E-stuff\Automation\Powershell\Scripts\Powershell - Find and Replace - New\iLand\Iland.csv",
	#Path to config files
	[String]$Files = "D:\E-stuff\Projects\iLand\web.config\iQA"
	
		
)
$ReplacementList = Import-Csv $List;
#Get-ChildItem $Files -recurse -include *.conf |
Get-ChildItem $Files -recurse -include *.config, *.asp |
ForEach-Object {
    $Content = Get-Content -Path $_.FullName;
    foreach ($ReplacementItem in $ReplacementList)
    {
        #$Content = $Content.Replace($ReplacementItem.OldValue, $ReplacementItem.NewValue)
		$old = $ReplacementItem.OldValue
		$new = $ReplacementItem.NewValue
			$Content = $Content -Replace "$old", "$new"
    }
    Set-Content -Path $_.FullName -Value $Content
}