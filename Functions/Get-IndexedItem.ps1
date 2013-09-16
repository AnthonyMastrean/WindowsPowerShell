
Function Get-IndexedItem {
    <#
       .SYNOPSIS
            Gets files which have been indexed by Windows desktop search
       .Description
            Searches the Windows index on the local computer or a remote file serving computer
            Looking for file properties or free text searching over contents       
        .PARAMETER Filter
            Alias WHERE, INCLUDE
            A single string containing a WHERE condition, or multiple conditions linked with AND
            or Multiple strings each with a single Condition, which will be joined together.
            The function tries to add Prefixes and single quotes if they are omitted
            If no =, >,< , Like or Contains is specified the terms will be used in a freeText contains search
            Syntax Information for CONTAINS and FREETEXT can be found at 
            http://msdn.microsoft.com/en-us/library/dd626247(v=office.11).aspx
        .PARAMETER OrderBy
            Alias SORT
            Either a single string containing one or more Order BY conditions, 
            or multiple string each with a single condition which will be joined together            
        .PARAMETER Path
            A single string containing a path which should be searched. 
            This may be a UNC path to a share on a remote computer 
        .PARAMETER First
            Alias TOP
            A single integer representing the number of items to be returned. 
        .PARAMETER Value
            Alias GROUP
            A single string containing a Field name. 
            If specified the search will return the Values in this field, instead of objects
            for the items found by the query terms. 
        .PARAMETER Recurse
            If Path is specified only a single folder is searched Unless -Recurse is specified
            If path is not specified the whole index is searched, and recurse is ignored. 
        .PARAMETER List
            Instead of querying the index produces a list of known field names, with short names and aliases
            which may be used instead.
        .PARAMETER NoFiles
            Normally if files are found the command returns a file object with additional properties,
            which can be piped into commands which accept files. This switch prevents the file being fetched
            improving performance when the file object is not needed. 
        .EXAMPLE
            Get-IndexedItem -Filter "Contains(*,'Stingray')", "kind = 'picture'", "keywords='portfolio'" 
            Finds picture files anywhere on the local machine, which have 'Portfolio' as a keyword tag,
            and 'stringray' in any indexed property.
        .EXAMPLE
            Get-IndexedItem Stingray, kind=picture, keyword=portfolio | copy -destination e:\
            Finds the same pictures as the previous example but uses Keyword as a alias for KeywordS, and
            leaves the ' marks round Portfolio and Contains() round stingray to be automatically inserted  
            Copies the found files to drive E: 
        .EXAMPLE
            Get-IndexedItem -filter stingray -path OneIndex14:// -recurse    
            Finds OneNote items containing "Stingray" (note, nothing will be found without -recurse) 
        .EXAMPLE
            start (Get-IndexedItem -filter stingray -path OneIndex14:// -recurse -first 1 -orderby rank)
            Finds the highest ranked one not page for stingray and opens it. 
            Note Start-process (canonical name for Start) does not support piped input. 
        .EXAMPLE
            Get-IndexedItem -filter stingray -path ([system.environment]::GetFolderPath( [system.environment+specialFolder]::MyPictures )) -recurse    
            Looks for pictures with stingray in any indexed property, limiting the scope of the search 
            to the current users 'My Pictures' folder and its subfolders.
        .EXAMPLE
            Get-IndexedItem -Filter "system.kind = 'recordedTV' " -order "System.RecordedTV.RecordingTime" -path "\\atom-engine\users" -recurse | format-list path,title,episodeName,programDescription
            Finds recorded TV files on a remote server named 'Atom-Engine' which are accessible via a share named 'users'. 
            Field name prefixes are specified explicitly instead of letting the function add them
            Results are displayed as a list using a subset of the available fields specific to recorded TV
        .EXAMPLE
            Get-IndexedItem -Value "kind" -path \\atom-engine\users  -recurse
            Lists the kinds of files available on the on the 'users' share of a remote server named 'Atom-Engine'
        .EXAMPLE    
            Get-IndexedItem -Value "title" -filter "kind=recordedtv" -path \\atom-engine\users  -recurse
            Lists the titles of RecordedTv files available on the on the 'users' share of a remote server named 'Atom-Engine'
        .EXAMPLE
           Start (Get-IndexedItem -path "\\atom-engine\users" -recurse -Filter "title= 'Formula 1' " -order "System.RecordedTV.RecordingTime DESC" -top 1 )    
           Finds files entitled "Formula 1" on the 'users' share of a remote server named 'Atom-Engine'
           Selects the most recent one by TV recording date, and opens it on the local computer. 
           Note: start does not support piped input. 
        .EXAMPLE
           Get-IndexedItem -Filter "System.Kind = 'Music' AND AlbumArtist like '%'  " | Group-Object -NoElement -Property "AlbumArtist" | sort -Descending -property count
           Gets all music files with an Album Artist set, using a single combined where condition and a mixture 
           of implicit and explicit field prefixes.  
           The result is grouped by Artist and sorted to give popular artist first
        .EXAMPLE
               Get-IndexedItem "itemtype='.mp3'","AlbumArtist like '%'","RatingText <> '1 star'" -NoFiles -orderby encodingBitrate,size | ft -a AlbumArtist, 
               Title, @{n="size"; e={($_.size/1MB).tostring("n2")+"MB" }},@{n="duration";e={$_.duration.totalseconds.tostring("n0")+"sec"}},
               @{n="Byes/Sec";e={($_.size/128/$_.duration.totalSeconds).tostring("n0")+"Kb/s"}},@{n="Encoding";e={($_.EncodingBitrate/1000).tostring("n0")+"Kb/s"}},
               @{n="Sample Rate";e={($_.sampleRate/1000).tostring("n1")+"KHz"}}
               Shows MP3 files with Artist and Track name, showing Size, duration, actual and encoding bits per second and sample rate
        .EXAMPLE
           Get-IndexedItem -path c:\ -recurse  -Filter cameramaker=pentax* -Property focallength | group focallength -no | sort -property @{e={[double]$_.name}}   
           Gets all the items which have a the camera maker set to pentax, anywhere on the C: driv
           but ONLY get thier focallength property, and return a sorted count of how many of each focal length there are. 
    #>
    #$t=(Get-IndexedItem -Value "title" -filter "kind=recordedtv" -path \\atom-engine\users  -recurse | Select-List -Property title).title
    #start (Get-IndexedItem -filter "kind=recordedtv","title='$t'" -path \\atom-engine\users  -recurse | Select-List -Property ORIGINALBROADCASTDATE,PROGRAMDESCRIPTION)
[CmdletBinding()]
Param ( [Alias("Where","Include")][String[]]$Filter , 
        [String]$path, 
        [Alias("Sort")][String[]]$orderby, 
        [Alias("Top")][int]$First,
        [Alias("Group")][String]$Value, 
        [Alias("Select")][String[]]$Property, 
        [Switch]$recurse,
        [Switch]$list,
        [Switch]$NoFiles)

#Alias definitions take the form  AliasName = "Full.Cannonical.Name" ; 
#Any defined here will be accepted as input field names in -filter and -OrderBy parameters
#and will be added to output objects as AliasProperties. 
 $PropertyAliases   = @{Width         ="System.Image.HorizontalSize"; Height        = "System.Image.VerticalSize";  Name    = "System.FileName" ; 
                        Extension     ="System.FileExtension"       ; CreationTime  = "System.DateCreated"       ;  Length  = "System.Size" ; 
                        LastWriteTime ="System.DateModified"        ; Keyword       = "System.Keywords"          ;  Tag     = "System.Keywords"
                        CameraMaker  = "System.Photo.Cameramanufacturer"}

 $fieldTypes = "System","Photo","Image","Music","Media","RecordedTv","Search","Audio" 
#For each of the field types listed above, define a prefix & a list of fields, formatted as "Bare_fieldName1|Bare_fieldName2|Bare_fieldName3"
#Anything which appears in FieldTypes must have a prefix and fields definition. 
#Any definitions which don't appear in fields types will be ignored 
#See http://msdn.microsoft.com/en-us/library/dd561977(v=VS.85).aspx for property info.  
 
 $SystemPrefix     = "System."            ;     $SystemFields = "ItemName|ItemUrl|FileExtension|FileName|FileAttributes|FileOwner|ItemType|ItemTypeText|KindText|Kind|MIMEType|Size|DateModified|DateAccessed|DateImported|DateAcquired|DateCreated|Author|Company|Copyright|Subject|Title|Keywords|Comment|SoftwareUsed|Rating|RatingText"
 $PhotoPrefix      = "System.Photo."      ;      $PhotoFields = "fNumber|ExposureTime|FocalLength|IsoSpeed|PeopleNames|DateTaken|Cameramodel|Cameramanufacturer|orientation"
 $ImagePrefix      = "System.Image."      ;      $ImageFields = "Dimensions|HorizontalSize|VerticalSize"
 $MusicPrefix      = "System.Music."      ;      $MusicFields = "AlbumArtist|AlbumID|AlbumTitle|Artist|BeatsPerMinute|Composer|Conductor|DisplayArtist|Genre|PartOfSet|TrackNumber"
 $AudioPrefix      = "System.Audio."      ;      $AudioFields = "ChannelCount|EncodingBitrate|PeakValue|SampleRate|SampleSize"
 $MediaPrefix      = "System.Media."      ;      $MediaFields = "Duration|Year"
 $RecordedTVPrefix = "System.RecordedTV." ; $RecordedTVFields = "ChannelNumber|EpisodeName|OriginalBroadcastDate|ProgramDescription|RecordingTime|StationName"
 $SearchPrefix     = "System.Search."     ;     $SearchFields = "AutoSummary|HitCount|Rank|Store"
 
 if ($list)  {  #Output a list of the fields and aliases we currently support. 
    $( foreach ($type in $fieldTypes) { 
          (get-variable "$($type)Fields").value -split "\|" | select-object @{n="FullName" ;e={(get-variable "$($type)prefix").value+$_}},
                                                                            @{n="ShortName";e={$_}}    
       }
    ) + ($PropertyAliases.keys | Select-Object  @{name="FullName" ;expression={$PropertyAliases[$_]}},
                                                @{name="ShortName";expression={$_}}
    ) | Sort-Object -Property @{e={$_.FullName -split "\.\w+$"}},"FullName" 
  return
 }  
  
#Make a giant SELECT clause from the field lists; replace "|" with ", " - field prefixes will be inserted later.
#There is an extra comma to ensure the last field name is recognized and gets a prefix. This is tidied up later
 if ($first)    {$SQL =  "SELECT TOP $first "}
 else           {$SQL =  "SELECT "}
 if ($property) {$SQL += ($property -join ", ") + ", "}
 else {
    foreach ($type in $fieldTypes) { 
        $SQL += ((get-variable "$($type)Fields").value -replace "\|",", " ) + ", " 
    }
 }   
  
#IF a UNC name was specified as the path, build the FROM ... WHERE clause to include the computer name.
 if ($path -match "\\\\([^\\]+)\\.") {
       $sql += " FROM $($matches[1]).SYSTEMINDEX WHERE "  
 } 
 else {$sql += " FROM SYSTEMINDEX WHERE "} 
 
#If a WHERE condidtion was provided via -Filter, add it now   

 if ($Filter) { #Convert * to % 
                $Filter = $Filter -replace "(?<=\w)\*","%"
                #Insert quotes where needed any condition specified as "keywords=stingray" is turned into "Keywords = 'stingray' "
                $Filter = $Filter -replace "\s*(=|<|>|like)\s*([^\''\d][^\d\s\'']*)$"  , ' $1 ''$2'' '
                # Convert "= 'wildcard'" to "LIKE 'wildcard'" 
                $Filter = $Filter -replace "\s*=\s*(?='.+%'\s*$)" ," LIKE " 
                #If a no predicate was specified, use the term in a contains search over all fields.
                $filter = ($filter | ForEach-Object {
                                if ($_ -match "'|=|<|>|like|contains|freetext") {$_}
                                else {"Contains(*,'$_')"}
                }) 
                #if $filter is an array of single conditions join them together with AND 
                  $SQL += $Filter -join " AND "  } 
                  
 #If a path was given add SCOPE or DIRECTORY to WHERE depending on whether -recurse was specified. 
 if ($path)     {if ($path -notmatch "\w{4}:") {$path = "file:" + (resolve-path -path $path).providerPath}  # Path has to be in the form "file:C:/users" 
                $path  = $path -replace "\\","/"
                if ($sql -notmatch "WHERE\s$") {$sql += " AND " }                       #If the SQL statement doesn't end with "WHERE", add "AND"  
                if ($recurse)                  {$sql += " SCOPE = '$path' "       }     #INDEX uses SCOPE <folder> for recursive search, 
                else                           {$sql += " DIRECTORY = '$path' "   }     # and DIRECTORY <folder> for non-recursive
 }   
 
 if ($Value) {
                if ($sql -notmatch "WHERE\s$") {$sql += " AND " }                       #If the SQL statement doesn't end with "WHERE", add "AND"  
                                                $sql += " $Value Like '%'" 
                                                $sql =  $SQL -replace "^SELECT.*?FROM","SELECT $Value, FROM"
 }
 
 #If the SQL statement Still ends with "WHERE" we'd return everything in the index. Bail out instead  
 if ($sql -match "WHERE\s*$")  { Write-warning "You need to specify either a path , or a filter." ; return} 
 
 #Add any order-by condition(s). Note there is an extra trailing comma to ensure field names are recognised when prefixes are inserted . 
 if ($Value) {$SQL =  "GROUP ON $Value, OVER ( $SQL )"}
 elseif ($orderby)  {$sql += " ORDER BY " + ($orderby   -join " , " ) + ","}             
 
 # For each entry in the PROPERTYALIASES Hash table look for the KEY part being used as a field name
 # and replace it with the associated value. The operation becomes
 # $SQL  -replace "(?<=\s)CreationTime(?=\s*(=|\>|\<|,|Like))","System.DateCreated" 
 # This translates to "Look for 'CreationTime' preceeded by a space and followed by ( optionally ) some spaces, and then
 # any of '=', '>' , '<', ',' or 'Like' (Looking for these prevents matching if the word is a search term, rather than a field name)
 # If you find it, replace it with "System.DateCreated" 
 
 $PropertyAliases.Keys | ForEach-Object { $sql= $SQL -replace "(?<=\s)$($_)(?=\s*(=|>|<|,|Like))",$PropertyAliases.$_}      

 # Now a similar process for all the field prefixes: this time the regular expression becomes for example,
 # $SQL -replace "(?<!\s)(?=(Dimensions|HorizontalSize|VerticalSize))","System.Image." 
 # This translates to: "Look for a place which is preceeded by space and  followed by 'Dimensions' or 'HorizontalSize'
 # just select the place (unlike aliases, don't select the fieldname here) and put the prefix at that point.  
 foreach ($type in $fieldTypes) { 
    $fields = (get-variable "$($type)Fields").value 
    $prefix = (get-variable "$($type)Prefix").value 
    $sql = $sql -replace "(?<=\s)(?=($Fields)\s*(=|>|<|,|Like))" , $Prefix
 }
 
 # Some commas were  put in just to ensure all the field names were found but need to be removed or the SQL won't run
 $sql = $sql -replace "\s*,\s*FROM\s+" , " FROM " 
 $sql = $sql -replace "\s*,\s*OVER\s+" , " OVER " 
 $sql = $sql -replace "\s*,\s*$"       , "" 
 
 #Finally we get to run the query: result comes back in a dataSet with 1 or more Datatables. Process each dataRow in the first (only) table
 write-debug $sql 
 $adapter = new-object system.data.oledb.oleDBDataadapter -argumentlist $sql, "Provider=Search.CollatorDSO;Extended Properties=’Application=Windows’;"
 $ds      = new-object system.data.dataset
 if ($adapter.Fill($ds)) { foreach ($row in $ds.Tables[0])  {
    #If the dataRow refers to a file output a file obj with extra properties, otherwise output a PSobject
    if ($Value) {$row | Select-Object -Property @{name=$Value; expression={$_.($ds.Tables[0].columns[0].columnname)}}}
    else {
        if (($row."System.ItemUrl" -match "^file:") -and (-not $NoFiles)) { 
               $obj = (Get-item -force -LiteralPath (($row."System.ItemUrl" -replace "^file:","") -replace "\/","\"))
               if (-not $obj) {$obj = New-Object psobject }
        }
        else { 
               if ($row."System.ItemUrl") {
                     $obj = New-Object psobject -Property @{Path = $row."System.ItemUrl"}
                     Add-Member -force -InputObject $obj -Name "ToString"  -MemberType "scriptmethod" -Value {$this.path} 
               }
               else {$obj = New-Object psobject }   
        }
        if ($obj) {
            #Add all the the non-null dbColumns removing the prefix from the property name. 
            foreach ($prop in (Get-Member -InputObject $row -MemberType property | where-object {$row."$($_.name)" -isnot [system.dbnull] })) {                            
                Add-member -ErrorAction "SilentlyContinue" -InputObject $obj -MemberType NoteProperty  -Name (($prop.name -split "\." )[-1]) -Value  $row."$($prop.name)"
            }                       
            #Add aliases 
            foreach ($prop in ($PropertyAliases.Keys | where-object {  ($row."$($propertyAliases.$_)" -isnot [system.dbnull] ) -and
                                                                       ($row."$($propertyAliases.$_)" -ne $null )})) {
                Add-member -ErrorAction "SilentlyContinue" -InputObject $obj -MemberType AliasProperty -Name $prop -Value ($propertyAliases.$prop  -split "\." )[-1] 
            }
            #Overwrite duration as a timespan not as 100ns ticks
            If ($obj.duration) { $obj.duration =([timespan]::FromMilliseconds($obj.Duration / 10000) )}
            $obj
        }
    }                               
 }}
} 