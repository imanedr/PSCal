function Write-HostColor {
    <#
    .SYNOPSIS
        Writes colored text to the host using inline color tags (optimized version).
    
    .DESCRIPTION
        This function allows you to colorize console output using inline tags embedded in the text string.
        Color tags use the format [col:colorname] for foreground color, [bg:colorname] for background color,
        or [col:colorname,bg:colorname] for both. Colors apply to the first non-whitespace word/character
        after the tag and stop at the next whitespace character.
        
        Valid color names are PowerShell console colors: Black, DarkBlue, DarkGreen, DarkCyan, DarkRed,
        DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White.
        
        Multiple color tags can be used in the same string. Invalid tags are printed as-is.
    
    .PARAMETER Text
        The text string containing color tags and content to be displayed.
    
    .PARAMETER DefaultColor
        The default foreground color to use for text without color tags.
    
    .PARAMETER DefaultBackground
        The default background color to use for text without color tags.
    
    .EXAMPLE
        Write-HostColor "[col:red]Error: [col:yellow]Warning: Normal text"
    
    .EXAMPLE
        Write-HostColor "[col:green,bg:black]SUCCESS [col:red,bg:white]ERROR" -DefaultColor White
    #>
    
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0, ValueFromPipeline = $true)]
        [string]$Text,
        
        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$DefaultColor = $Host.UI.RawUI.ForegroundColor,
        
        [Parameter(Mandatory = $false)]
        [System.ConsoleColor]$DefaultBackground = $Host.UI.RawUI.BackgroundColor
    )
    
    # Valid console colors as a HashSet for O(1) lookup
    $validColors = [System.Collections.Generic.HashSet[string]]::new([System.StringComparer]::OrdinalIgnoreCase)
    @('Black', 'DarkBlue', 'DarkGreen', 'DarkCyan', 'DarkRed', 'DarkMagenta',
      'DarkYellow', 'Gray', 'DarkGray', 'Blue', 'Green', 'Cyan', 'Red',
      'Magenta', 'Yellow', 'White') | ForEach-Object { [void]$validColors.Add($_) }
    
    # Use regex to find all color tags and their positions
    $pattern = '\[(?:col:(\w+)|bg:(\w+)|col:(\w+),bg:(\w+)|bg:(\w+),col:(\w+))\]'
    $matches = [regex]::Matches($Text, $pattern)
    
    if ($matches.Count -eq 0) {
        # No tags found, write entire string at once
        Write-Host $Text -ForegroundColor $DefaultColor -BackgroundColor $DefaultBackground
        return
    }
    
    # Build segments to minimize Write-Host calls
    $segments = [System.Collections.Generic.List[object]]::new()
    $currentIndex = 0
    
    foreach ($match in $matches) {
        # Write any text before this tag
        if ($match.Index -gt $currentIndex) {
            $segments.Add(@{
                Text = $Text.Substring($currentIndex, $match.Index - $currentIndex)
                ForeColor = $DefaultColor
                BackColor = $DefaultBackground
            })
        }
        
        # Parse the tag to extract colors
        $foreColor = $null
        $backColor = $null
        $isValid = $false
        
        # Check which capture groups matched
        for ($i = 1; $i -le 6; $i++) {
            if ($match.Groups[$i].Success) {
                $colorName = $match.Groups[$i].Value
                if ($validColors.Contains($colorName)) {
                    $isValid = $true
                    # Groups 1,3,6 are foreground colors
                    if ($i -eq 1 -or $i -eq 3 -or $i -eq 6) {
                        $foreColor = [System.ConsoleColor]$colorName
                    }
                    # Groups 2,4,5 are background colors
                    else {
                        $backColor = [System.ConsoleColor]$colorName
                    }
                }
            }
        }
        
        $currentIndex = $match.Index + $match.Length
        
        if ($isValid) {
            # Find the next word (non-whitespace sequence)
            $wordMatch = [regex]::Match($Text.Substring($currentIndex), '^\s?\S+')
            
            if ($wordMatch.Success) {
                $coloredText = $wordMatch.Value
                $segments.Add(@{
                    Text = $coloredText
                    ForeColor = if ($foreColor) { $foreColor } else { $DefaultColor }
                    BackColor = if ($backColor) { $backColor } else { $DefaultBackground }
                })
                $currentIndex += $wordMatch.Length
            }
        }
        else {
            # Invalid tag, write it as literal text
            $segments.Add(@{
                Text = $match.Value
                ForeColor = $DefaultColor
                BackColor = $DefaultBackground
            })
        }
    }
    
    # Write any remaining text after the last tag
    if ($currentIndex -lt $Text.Length) {
        $segments.Add(@{
            Text = $Text.Substring($currentIndex)
            ForeColor = $DefaultColor
            BackColor = $DefaultBackground
        })
    }
    
    # Write all segments in one pass
    foreach ($segment in $segments) {
        Write-Host -Object $segment.Text -NoNewline `
            -ForegroundColor $segment.ForeColor -BackgroundColor $segment.BackColor
    }
    
    Write-Host  # Final newline
}