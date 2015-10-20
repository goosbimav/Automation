#script variables



$lookupTable = @{
    'services.icg360.com' = 'dr-services.icg360.com' 
    'agencyadmin.icg360.com' = 'dr-agencyadmin.icg360.com' 
    #'something3' = 'something3cc' 
    #'something4' = 'something4dd' 
    #'something5' = 'something5dsf' 
    #'something6' = 'something6dfsfds'
}

$filePath     = 'F:\Scripts\DR Test\ZeusProxy'
#$destination_file =  'F:\Scripts\DR Test\ZeusProxy'
#$processFiles = Get-ChildItem -Exclude *.bak, *.log -Filter *.conf -Recurse -Path $filePath

#foreach ( $file in $processFiles ) {
    #Pre-Processing | backup the file for archival
    #$file | Copy-Item -Destination "$file.bak"
	#script begin
	Get-Content -Path $filepath | ForEach-Object { 
    $line = $_

		$lookupTable.GetEnumerator() | ForEach-Object {
			if ($line -match $_.Key)
			{
				$line -replace $_.Key, $_.Value
				break
			}
		}
	
	#Overwrites the original text file that was being processed
    #$arrayData | Out-File $file -Force
	#}
}	
#} | Set-Content -Path $destination_file