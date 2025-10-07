function Get-Holidays {
	
    [CmdletBinding()]
    param 
    (
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1500, 3000)]
        [int]
        $Year,
        
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1, 12)]
        [int]
        $Month
    )
    if (Test-Path ($PSScriptRoot + "\" + "holidays.txt")) {
        $arrHolidays = New-Object System.Collections.ArrayList
        $rawHolidays = Get-Content ($PSScriptRoot + "\" + "holidays.txt")
        foreach ($item in $rawHolidays) {
            $splitArr = $item.Split("/")
            $objDate = Get-Date -Year $splitArr[0] -Month $splitArr[1] -Day $splitArr[2]
            $arrHolidays.Add($objDate) | Out-Null          
        }
        if ($Month) {
            Return $arrHolidays | where-object { ($_.Year -eq $Year) -and ($_.Month -eq $Month) } 
        }
        else {
            Return $arrHolidays | where-object { $_.Year -eq $Year } 
        }
    
    }
}
function Show-Calendar {
    <#  
   .Synopsis  
    Show Linux-Like Console Calendar
   .Description  
    A PowerShell module to display a Linux-like calendar on the console.
   .Example  
    Show-Calendar
    Displays the current month calendar on the console.
   .Example 
    Show-Calendar -Month July 
    Displays the July calendar of the current year on the console.
   .Example  
    Show-Calendar -Year 2021
    Displays the whole 2021 calendar (all 12 months) on the console.
   .Example  
    Show-Calendar -Year 2021 -Month May
    Displays the calendar of May 2021 on the console.	
   .Notes 
    NAME:  PSCal  
    AUTHOR: Iman Edrisian 
 #>  
    [CmdletBinding()]
    param 
    (
        [ValidateNotNullOrEmpty()]
        [ValidateRange(1500, 3000)]
        [int]
        $Year,
        
        [ValidateNotNullOrEmpty()]
        [ValidateSet("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")]
        [string]
        $Month

    )
    $arrMonth = @("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
    #$objPcal = New-Object System.Globalization.PersianCalendar
    $toDay = Get-Date
    if ($Year -and (-not $Month)) {
        Format-CalendarYear -Year $Year -Holidays (Get-Holidays -Year $Year)  
    }
    elseif ($Year -and $month) {
        $holidays = Get-Holidays -Year $Year -Month ($arrMonth.IndexOf($Month)+1)
        Format-CalendarMonth -Title MonthAndYear -Year $Year -Month $Month -holidays $holidays.Day
    }
    elseif ($Month) {
        $holidays = Get-Holidays -Year $toDay.Year -Month ($arrMonth.IndexOf($Month)+1)
        Format-CalendarMonth -Title MonthAndYear -Year $toDay.Year -Month $toDay.ToString("MMMM") -holidays $holidays.Day
    }
    else {
        $holidays = Get-Holidays -Year $toDay.Year -Month $toDay.Month
        Format-CalendarMonth -Title MonthAndYear -Year $toDay.Year -Month $toDay.ToString("MMMM") -holidays $holidays.Day
    }
    
}