#requires -module msterminalsettings,threadjob

###QUICKSTART
#FIRST: Run this in your Powershell Windows Terminal: Install-Module threadjob,msterminalsettings -scope currentuser
#THEN: iex (iwr git.io/invoketerminalgif)
#THEN: Get-Help Search-Giphy -Examples
#THEN: Get-Help Invoke-TerminalGif -Examples
#THEN: Search-Giphy | Format-List -prop *
#THEN: Invoke-TerminalGif https://media.giphy.com/media/g9582DNuQppxC/giphy.gif


function Search-Giphy {
    <#
.SYNOPSIS
    Fetches Gif Information and direct Gif Links from Giphy, a meme delivery service
.DESCRIPTION
    This is a frontend to the Giphy API to find and request gifs from Giphy. It implements the API described here: https://developers.giphy.com/docs/api/
.EXAMPLE
    PS> Search-Giphy
    Returns a random gif information object
    title          bitly_url              username source
    -----          ---------              -------- ------
    nick jonas GIF https://gph.is/1SR6uiv          https://ddlovatosrps.tumblr.com/post/120447116655/positive-nick-jonas-gif-hunt-under-the-cut-you
.EXAMPLE
    PS> Search-Giphy -ImageType Sticker
    Returns a random sticker information object
    title                                                             bitly_url              username source
    -----                                                             ---------              -------- ------
    festival woodstock Sticker by Wielka Orkiestra Świątecznej Pomocy https://gph.is/2mZ7V2k WOSP
.EXAMPLE
    PS> Search-Giphy -DirectURL
    Returns only the direct link to a random gif
    https://media3.giphy.com/media/q9WSYOP1KUlgc/giphy.gif?cid=f499c4a35d19a6596653673632f7ddec&rid=giphy.gif
.EXAMPLE
    PS> Search-Giphy -Filter "Excited"
    Returns GIFs that match 'Excited'
.EXAMPLE
    PS> Search-Giphy -Filter Excited -Channel reactions -tag cat -first 3
    Returns 3 GIFs that match 'Excited' in the reactions channel with tag of Cat
.EXAMPLE
    PS> Search-Giphy -Trending -First 3
    Get the top 3 trending gifs
.EXAMPLE
    PS> Search-Giphy -Translate -Phrase "cute flying bat" -Weirdness 5
    Translates the phrase "cute flying bat" to a Gif with a weirdness factor of 5 using Giphy's special sauce
.EXAMPLE
    PS> Search-Giphy -Translate -Phrase "cute flying bat" -Weirdness 5 -DirectUrl
    Translate the phrase "cute flying bat" to a gif with a Weirdness rating of 5.
.NOTES
    Created 2019 by Justin Grote
    The giphy public beta API key is embedded in this script and is subject to very frequent rate limiting. You can sign up for your own free Giphy API key, just be aware no special means in this script are used to "protect" the key.
    Recommendation so you don't have to specify it each time: $PSDefaultParameterValues['Search-Giphy:ApiKey'] = 'yourapikey'
#>
    [CmdletBinding(SupportsPaging, DefaultParameterSetName = 'random')]
    param (
        #If performing a search, this is a query string of a word or phrase to find. If using -Translate, this is the phrase you want to convert to a gif
        [Parameter(Mandatory, Position = 0, ParameterSetName = 'search')]
        [String]$Filter,

        #If performing a search, limit to a verified channel. This is the same as specifying "@channelname" in the Filter parameter
        [Parameter(Position = 2, ParameterSetName = 'search')]
        [String]$Channel,

        #Specify a phrase and gfycat will translate that phrase into a gif
        [Parameter(Mandatory, Position = 1, ParameterSetName = 'translate')]
        [String]$Phrase,

        #Specify a weirdness factor from 0 to 10. The translations will get weirder the higher number you specify
        [Parameter(ParameterSetName = 'translate')]
        [ValidateRange(0, 10)][int]$Weirdness,

        [Parameter(Position = 1, ParameterSetName = 'search')]
        [Parameter(Position = 1, ParameterSetName = 'random')]
        [String]$Tag,

        #Search Trending Gifs
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'trending')][Switch]$Trending,

        #Perform a gif translate, which will use the giphy "secret sauce" to make your phrase into a gif
        [Parameter(Position = 0, Mandatory, ParameterSetName = 'translate')][Switch]$Translate,

        #Fetch a random gif
        [Parameter(ParameterSetName = 'random')][Switch]$Random,

        #Specifying this switch will only return the original URI of a gif or gifs, which is easier to integrate into tools
        [Switch]$DirectURL,

        #Type of image (Gif or Sticker). Defaults to Gif.
        [ValidateSet('Gif', 'Sticker')]$ImageType = 'Gif',

        #Content rating of the gif. Specify G, PG, PG-13, or R. Searches PG gifs by default.
        [ValidateSet('G', 'PG', 'PG-13', 'R')][String]$Rating = 'PG',

        #API Key. Defaults to the Giphy Public Beta Key. It is recommended you register your own apikey at Giphy and use it
        [String]$APIKey = 'dc6zaTOxFJmzC'
    )

    function Join-Uri ([string]$uri, [string]$relativePath) {
        [uri]::new([uri]"$uri/", $relativePath)
    }

    $erroractionPreference = 'stop'
    $baseuri = "https://api.giphy.com/v1"
    $requestUri = Join-Uri -uri $baseuri -relativepath "${ImageType}s".toLower()
    $requestUri = Join-Uri $requestUri $PSCmdlet.ParameterSetName.toLower()

    $irmParams = @{
        UseBasicParsing = $true
        Method          = 'Get'
        URI             = $requestUri
        BODY            = [ordered]@{
            api_key = $APIKey
            rating  = $Rating
        }
    }

    $queryParams = $irmparams.body

    switch ($PSCmdlet.ParameterSetName) {
        'search' {
            $queryParams.q = $Filter
            if ($tag) { [string]$queryParams.q = "#$tag " + $queryParams.q }
            if ($channel) { [string]$queryParams.q = "@$channel " + $queryParams.q }
        }
        'translate' {
            $queryParams.s = $Phrase
            if ($Weirdness) { $queryParams.weirdness = $Weirdness }
        }
        'random' {
            if ($tag) { $queryParams.tag = $Tag }
        }
    }

    if ($PSCmdlet.PagingParameters.First -and $PSCmdlet.PagingParameters.First -ne 18446744073709551615) { $queryParams.limit = $PSCmdlet.PagingParameters.First }
    if ($PSCmdlet.PagingParameters.Skip) { $queryParams.body.offset = $PSCmdlet.PagingParameters.Skip }

    $GiphyResult = Invoke-RestMethod @irmParams -ErrorAction Stop
    $GiphyResultData = $GiphyResult.data

    if (-not $DirectUrl) {
        if (-not (Get-TypeData giphy.image)) { Update-TypeData -TypeName Giphy.Image -DefaultDisplayPropertySet title, bitly_url, username, source }
        $GiphyResultData | ForEach-Object {
            $PSItem.PSObject.TypeNames.Insert(0, 'Giphy.Image')
            $PSItem
        }
    } else {
        $GiphyResultData.images.original.url
    }
}


function Invoke-TerminalGif {
    #requires -module threadjob
    <#
.SYNOPSIS
    Plays a gif from a URI to the terminal. Useful when used as part of programs or build scripts to show "reaction gifs" to the terminal to events. Plays in the "Powershell Core" profile by default, you must specify -TerminalProfileName to run in another profile window such as Windows Powershell or WSL
.DESCRIPTION
    This command plays animated GIFs on the Windows Terminal. It performs the operation in a background runspace and only allows one playback at a time. It also remembers your previous windows terminal settings and puts them back after it is done
.EXAMPLE
    PS C:\> Invoke-TerminalGif https://media.giphy.com/media/g9582DNuQppxC/giphy.gif
    Triggers a gif in the current Windows Terminal
.EXAMPLE
    PS C:\> Invoke-TerminalGif (Search-Giphy -DirectUrl)
    Triggers a gif in the current Windows Terminal
.NOTES
    Requires Windows Terminal Preview
#>
    param (
        #The URI of the GIF you want to display
        [Parameter(Mandatory)][uri]$Uri,
        #The name of your Windows Terminal Profile. If not specified, attempts to intelligently determine it from the executable name or if $ENV:WT_PROFILE was specified by adding -noexit -command \". {$env:WT_PROFILE='myprofilename'}\" to your terminal profile definition.
        [String]$TerminalProfileName,
        #How to resize the background image in the window. Options are None, Fill, Uniform, and UniformToFill
        [ValidateSet('none', 'fill', 'uniform', 'uniformToFill')][String]$StretchMode = 'uniformToFill',
        #Maximum duration of the gif invocation in seconds
        [int]$MaxDuration = 5
    )
    if (-not $env:WT_SESSION) { throw "This only works in Windows Terminal currently. Please install Windows Terminal and try again." }
    if ($PSEdition -eq 'Desktop') {
        if (-not (Get-Command start-threadjob -erroraction silentlycontinue)) {
            write-verbose "This requires the ThreadJob module on Windows Powershell 5.1"
            return
        }
    }
    #Pseudo Singleton to ensure only one prompt job is running at a time.
    $InvokeTerminalGifJobName = 'InvokeTerminalGif'
    $InvokeTerminalGifJob = Get-Job $InvokeTerminalGifJobName -Erroraction SilentlyContinue
    if ($invokeTerminalGifJob) {
        if ($invokeTerminalGifJob.state -notmatch 'Completed|Failed') {
            Write-Warning "Terminal Gif Already Running"
            return
        } else {
            Remove-Job $InvokeTerminalGifJob
        }
    }

    $TerminalProfileName = $env:WT_Profile
    $TerminalGifJobParams = @{ }
    ('uri', 'terminalprofilename', 'maxduration', 'stretchmode').foreach{
        $TerminalGifJobParams.$PSItem = (Get-Variable $PSItem).value
    }

    if (-not $InvokeTerminalGifJob -or ($InvokeTerminalGifJob.state -eq 'Completed')) {
        $null = Start-ThreadJob -Name $InvokeTerminalGifJobName -argumentlist $TerminalGifJobParams {
            $uri = $args.uri
            $terminalprofilename = $args.terminalprofilename
            $maxduration = $args.maxduration
            $stretchmode = $args.stretchmode

            if (-not $TerminalProfileName) {
                $exename = Split-Path (Get-Process -id $pid).path -leaf
                $terminalProfile = Get-MSTerminalProfile | Where-Object {
                    $psitem.commandline -like "*$exename*" -and $PSItem.commandline -notlike "*WT_PROFILE*"
                } | Select-Object -first 1
            } else {
                $terminalProfile = Get-MSTerminalProfile -Name $TerminalProfileName
            }

            if (-not $terminalProfile) { throw "Could not find the terminal profile $terminalProfileName." }

            Write-Output "Playing $uri"
            $erroractionpreference = 'stop'
            try {
                Set-MSTerminalProfile -Name $TerminalProfile.Name -BackgroundImage $uri -UseAcrylic:$false -BackgroundImageOpacity 0.6 -BackgroundImageStretchMode $StretchMode
                Start-Sleep $maxduration
            } catch { Write-Error $PSItem } finally {
                #Reset to a blank if for some reason the gif was the background previously.
                if ($terminalProfile.BackgroundImage -eq $uri) {
                    Write-Warning "Picture was same as previous picture, setting blank background"
                    $terminalProfile.BackgroundImage = $null
                }
                Set-MSTerminalProfile -Name $TerminalProfile.Name -BackgroundImage $TerminalProfile.BackgroundImage -BackgroundImageStretchMode $TerminalProfile.BackgroundImageStretchMode -UseAcrylic:$TerminalProfile.UseAcrylic -BackgroundImageOpacity $TerminalProfile.BackgroundImageOpacity
            }
        }
    } else {
        Write-Warning "Invoke Terminal Already Running"
    }
}