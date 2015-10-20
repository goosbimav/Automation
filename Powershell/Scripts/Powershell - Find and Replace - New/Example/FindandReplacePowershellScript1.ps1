#script variables
$filePath     = 'F:\Scripts\DR Test\ZeusProxy'
$processFiles = Get-ChildItem -Exclude *.bak, *.log -Filter *.conf -Recurse -Path $filePath

$query1        = 'services.icg360.com'
$query2       = 'agencyadmin.icg360.com'
$replace1      = 'dr-services.icg360.com'
$replace2      = 'dr-agencyadmin.icg360.com'

#script begin
foreach ( $file in $processFiles ) {
    #Pre-Processing | backup the file for archival
    $file | Copy-Item -Destination "$file.bak"
	#$file | Copy-Item -Destination "$backup/file.bak"

    $arrayData = Get-Content $file
    for ($i=0; $i -lt $arrayData.Count; $i++)
    {
        #if ( $arrayData[$i] -match $query1 ) {
            
                $arrayData[$i+1] = $arrayData[$i+1].Replace($query1,$replace1,$query2,$replace2)
				#$arrayData[$i+1] = $arrayData[$i+1].Replace($query2,$replace2)
        #}
        #else {
            #Catch if the first query1 isn't matched.
        #}
    }

    #Overwrites the original text file that was being processed
    $arrayData | Out-File $file -Force
}