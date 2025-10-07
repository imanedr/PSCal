function Format-CalendarYear {
    [CmdletBinding()]
    param 
    (
        [Parameter(Mandatory=$true)]
        [int]$Year,
        
        [Parameter(Mandatory=$false)]
        [object[]]$Holidays
    )
    
    # creating an empty array if $Holidays is $null
    if (-not $Holidays) {
        $Holidays = @(Get-Date "1900-01-01") # A date that will never match
    }
    # Get the current date
    $today = Get-Date

    # Determine if the year is a leap year
    $isLeapYear = [System.DateTime]::IsLeapYear($Year)

    # Define the number of days in each month
    $daysInMonth = @(31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31)

    # Adjust February for leap years
    if ($isLeapYear) {
        $daysInMonth[1] = 29
    }

    # Create an array to hold the month names
    $monthNames = @("January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")

    # Create a hashtable to store the days for each month
    $monthDays = @{}

    # Populate the hashtable with the days for each month
    for ($i = 0; $i -lt 12; $i++) {
        $month = $monthNames[$i]
        $days = 1..$daysInMonth[$i]
        $monthDays[$month] = $days
    }

    # Calculate the day of the week for the first day of each month
    $firstDayOfMonths = @()
    for ($i = 1; $i -le 12; $i++) {
        $firstDayOfMonth = Get-Date -Year $Year -Month $i -Day 1
        $firstDayOfMonths += $firstDayOfMonth.DayOfWeek.value__
    }

    # Create an empty hashtable to hold day placeholders for each month
    $months = @{}
    foreach ($monthName in $monthNames) {
        $months[$monthName] = @{}
    }

    # Loop through each month
    for ($i = 0; $i -lt 12; $i++) {
        # Get the month name
        $month = $monthNames[$i]

        # Get the days for the month
        $days = $monthDays[$month]

        # Get the first day of the month
        $firstDayOfMonth = $firstDayOfMonths[$i]

        # Calculate the offset for the first day of the month
        $offset = $firstDayOfMonth

        # Loop through each day of the month and populate the template variables
        for ($day = 1; $day -le $daysInMonth[$i]; $day++) {
            # Calculate the position in the grid (1-based index)
            $position = $offset + $day

            # Format the day with leading space
            if ($day -lt 10) {
                $formattedDay = " $day"
            } else {
                $formattedDay = "$day"
            }

            # Get the date for the day
            $date = Get-Date -Year $Year -Month ($i + 1) -Day $day

            # Check if the date is today
            if ($date.ToShortDateString() -eq $today.ToShortDateString()) {
                # Highlight today with inverted colors
                $months[$month][$position] = "[bg:gray,col:darkred]$formattedDay"
            }
            # Check if the date is a holiday
            elseif ($Holidays.ToShortDateString() -contains $date.ToShortDateString()) {
                # Output holiday in red
                $months[$month][$position] = "[col:red]$formattedDay"
            }
            else {
                # Output the day
                $months[$month][$position] = $formattedDay
            }
        }

        # Fill the remaining positions with spaces
        for ($j = $daysInMonth[$i] + $offset + 1; $j -le 37; $j++) {
            # Output empty day
            $months[$month][$j] = "  "
        }
        # Fill the starting positions with spaces
        for ($j = 1; $j -le $offset; $j++) {
            $months[$month][$j] = "  "
        }
    }
    
    $year_template = @"
                              $Year
      January               February               March
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
$($months['January'][1]) $($months['January'][2]) $($months['January'][3]) $($months['January'][4]) $($months['January'][5]) $($months['January'][6]) $($months['January'][7])  $($months['February'][1]) $($months['February'][2]) $($months['February'][3]) $($months['February'][4]) $($months['February'][5]) $($months['February'][6]) $($months['February'][7])  $($months['March'][1]) $($months['March'][2]) $($months['March'][3]) $($months['March'][4]) $($months['March'][5]) $($months['March'][6]) $($months['March'][7])
$($months['January'][8]) $($months['January'][9]) $($months['January'][10]) $($months['January'][11]) $($months['January'][12]) $($months['January'][13]) $($months['January'][14])  $($months['February'][8]) $($months['February'][9]) $($months['February'][10]) $($months['February'][11]) $($months['February'][12]) $($months['February'][13]) $($months['February'][14])  $($months['March'][8]) $($months['March'][9]) $($months['March'][10]) $($months['March'][11]) $($months['March'][12]) $($months['March'][13]) $($months['March'][14])
$($months['January'][15]) $($months['January'][16]) $($months['January'][17]) $($months['January'][18]) $($months['January'][19]) $($months['January'][20]) $($months['January'][21])  $($months['February'][15]) $($months['February'][16]) $($months['February'][17]) $($months['February'][18]) $($months['February'][19]) $($months['February'][20]) $($months['February'][21])  $($months['March'][15]) $($months['March'][16]) $($months['March'][17]) $($months['March'][18]) $($months['March'][19]) $($months['March'][20]) $($months['March'][21])
$($months['January'][22]) $($months['January'][23]) $($months['January'][24]) $($months['January'][25]) $($months['January'][26]) $($months['January'][27]) $($months['January'][28])  $($months['February'][22]) $($months['February'][23]) $($months['February'][24]) $($months['February'][25]) $($months['February'][26]) $($months['February'][27]) $($months['February'][28])  $($months['March'][22]) $($months['March'][23]) $($months['March'][24]) $($months['March'][25]) $($months['March'][26]) $($months['March'][27]) $($months['March'][28])
$($months['January'][29]) $($months['January'][30]) $($months['January'][31]) $($months['January'][32]) $($months['January'][33]) $($months['January'][34]) $($months['January'][35])  $($months['February'][29]) $($months['February'][30]) $($months['February'][31]) $($months['February'][32]) $($months['February'][33]) $($months['February'][34]) $($months['February'][35])  $($months['March'][29]) $($months['March'][30]) $($months['March'][31]) $($months['March'][32]) $($months['March'][33]) $($months['March'][34]) $($months['March'][35])
$($months['January'][36]) $($months['January'][37])                 $($months['February'][36]) $($months['February'][37])                 $($months['March'][36]) $($months['March'][37])

       April                  May                   June
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
$($months['April'][1]) $($months['April'][2]) $($months['April'][3]) $($months['April'][4]) $($months['April'][5]) $($months['April'][6]) $($months['April'][7])  $($months['May'][1]) $($months['May'][2]) $($months['May'][3]) $($months['May'][4]) $($months['May'][5]) $($months['May'][6]) $($months['May'][7])  $($months['June'][1]) $($months['June'][2]) $($months['June'][3]) $($months['June'][4]) $($months['June'][5]) $($months['June'][6]) $($months['June'][7])
$($months['April'][8]) $($months['April'][9]) $($months['April'][10]) $($months['April'][11]) $($months['April'][12]) $($months['April'][13]) $($months['April'][14])  $($months['May'][8]) $($months['May'][9]) $($months['May'][10]) $($months['May'][11]) $($months['May'][12]) $($months['May'][13]) $($months['May'][14])  $($months['June'][8]) $($months['June'][9]) $($months['June'][10]) $($months['June'][11]) $($months['June'][12]) $($months['June'][13]) $($months['June'][14])
$($months['April'][15]) $($months['April'][16]) $($months['April'][17]) $($months['April'][18]) $($months['April'][19]) $($months['April'][20]) $($months['April'][21])  $($months['May'][15]) $($months['May'][16]) $($months['May'][17]) $($months['May'][18]) $($months['May'][19]) $($months['May'][20]) $($months['May'][21])  $($months['June'][15]) $($months['June'][16]) $($months['June'][17]) $($months['June'][18]) $($months['June'][19]) $($months['June'][20]) $($months['June'][21])
$($months['April'][22]) $($months['April'][23]) $($months['April'][24]) $($months['April'][25]) $($months['April'][26]) $($months['April'][27]) $($months['April'][28])  $($months['May'][22]) $($months['May'][23]) $($months['May'][24]) $($months['May'][25]) $($months['May'][26]) $($months['May'][27]) $($months['May'][28])  $($months['June'][22]) $($months['June'][23]) $($months['June'][24]) $($months['June'][25]) $($months['June'][26]) $($months['June'][27]) $($months['June'][28])
$($months['April'][29]) $($months['April'][30]) $($months['April'][31]) $($months['April'][32]) $($months['April'][33]) $($months['April'][34]) $($months['April'][35])  $($months['May'][29]) $($months['May'][30]) $($months['May'][31]) $($months['May'][32]) $($months['May'][33]) $($months['May'][34]) $($months['May'][35])  $($months['June'][29]) $($months['June'][30]) $($months['June'][31]) $($months['June'][32]) $($months['June'][33]) $($months['June'][34]) $($months['June'][35])
$($months['April'][36]) $($months['April'][37])                 $($months['May'][36]) $($months['May'][37])                 $($months['June'][36]) $($months['June'][37])

        July                 August              September
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
$($months['July'][1]) $($months['July'][2]) $($months['July'][3]) $($months['July'][4]) $($months['July'][5]) $($months['July'][6]) $($months['July'][7])  $($months['August'][1]) $($months['August'][2]) $($months['August'][3]) $($months['August'][4]) $($months['August'][5]) $($months['August'][6]) $($months['August'][7])  $($months['September'][1]) $($months['September'][2]) $($months['September'][3]) $($months['September'][4]) $($months['September'][5]) $($months['September'][6]) $($months['September'][7])
$($months['July'][8]) $($months['July'][9]) $($months['July'][10]) $($months['July'][11]) $($months['July'][12]) $($months['July'][13]) $($months['July'][14])  $($months['August'][8]) $($months['August'][9]) $($months['August'][10]) $($months['August'][11]) $($months['August'][12]) $($months['August'][13]) $($months['August'][14])  $($months['September'][8]) $($months['September'][9]) $($months['September'][10]) $($months['September'][11]) $($months['September'][12]) $($months['September'][13]) $($months['September'][14])
$($months['July'][15]) $($months['July'][16]) $($months['July'][17]) $($months['July'][18]) $($months['July'][19]) $($months['July'][20]) $($months['July'][21])  $($months['August'][15]) $($months['August'][16]) $($months['August'][17]) $($months['August'][18]) $($months['August'][19]) $($months['August'][20]) $($months['August'][21])  $($months['September'][15]) $($months['September'][16]) $($months['September'][17]) $($months['September'][18]) $($months['September'][19]) $($months['September'][20]) $($months['September'][21])
$($months['July'][22]) $($months['July'][23]) $($months['July'][24]) $($months['July'][25]) $($months['July'][26]) $($months['July'][27]) $($months['July'][28])  $($months['August'][22]) $($months['August'][23]) $($months['August'][24]) $($months['August'][25]) $($months['August'][26]) $($months['August'][27]) $($months['August'][28])  $($months['September'][22]) $($months['September'][23]) $($months['September'][24]) $($months['September'][25]) $($months['September'][26]) $($months['September'][27]) $($months['September'][28])
$($months['July'][29]) $($months['July'][30]) $($months['July'][31]) $($months['July'][32]) $($months['July'][33]) $($months['July'][34]) $($months['July'][35])  $($months['August'][29]) $($months['August'][30]) $($months['August'][31]) $($months['August'][32]) $($months['August'][33]) $($months['August'][34]) $($months['August'][35])  $($months['September'][29]) $($months['September'][30]) $($months['September'][31]) $($months['September'][32]) $($months['September'][33]) $($months['September'][34]) $($months['September'][35])
$($months['July'][36]) $($months['July'][37])                 $($months['August'][36]) $($months['August'][37])                 $($months['September'][36]) $($months['September'][37])

      October               November              December
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
$($months['October'][1]) $($months['October'][2]) $($months['October'][3]) $($months['October'][4]) $($months['October'][5]) $($months['October'][6]) $($months['October'][7])  $($months['November'][1]) $($months['November'][2]) $($months['November'][3]) $($months['November'][4]) $($months['November'][5]) $($months['November'][6]) $($months['November'][7])  $($months['December'][1]) $($months['December'][2]) $($months['December'][3]) $($months['December'][4]) $($months['December'][5]) $($months['December'][6]) $($months['December'][7])
$($months['October'][8]) $($months['October'][9]) $($months['October'][10]) $($months['October'][11]) $($months['October'][12]) $($months['October'][13]) $($months['October'][14])  $($months['November'][8]) $($months['November'][9]) $($months['November'][10]) $($months['November'][11]) $($months['November'][12]) $($months['November'][13]) $($months['November'][14])  $($months['December'][8]) $($months['December'][9]) $($months['December'][10]) $($months['December'][11]) $($months['December'][12]) $($months['December'][13]) $($months['December'][14])
$($months['October'][15]) $($months['October'][16]) $($months['October'][17]) $($months['October'][18]) $($months['October'][19]) $($months['October'][20]) $($months['October'][21])  $($months['November'][15]) $($months['November'][16]) $($months['November'][17]) $($months['November'][18]) $($months['November'][19]) $($months['November'][20]) $($months['November'][21])  $($months['December'][15]) $($months['December'][16]) $($months['December'][17]) $($months['December'][18]) $($months['December'][19]) $($months['December'][20]) $($months['December'][21])
$($months['October'][22]) $($months['October'][23]) $($months['October'][24]) $($months['October'][25]) $($months['October'][26]) $($months['October'][27]) $($months['October'][28])  $($months['November'][22]) $($months['November'][23]) $($months['November'][24]) $($months['November'][25]) $($months['November'][26]) $($months['November'][27]) $($months['November'][28])  $($months['December'][22]) $($months['December'][23]) $($months['December'][24]) $($months['December'][25]) $($months['December'][26]) $($months['December'][27]) $($months['December'][28])
$($months['October'][29]) $($months['October'][30]) $($months['October'][31]) $($months['October'][32]) $($months['October'][33]) $($months['October'][34]) $($months['October'][35])  $($months['November'][29]) $($months['November'][30]) $($months['November'][31]) $($months['November'][32]) $($months['November'][33]) $($months['November'][34]) $($months['November'][35])  $($months['December'][29]) $($months['December'][30]) $($months['December'][31]) $($months['December'][32]) $($months['December'][33]) $($months['December'][34]) $($months['December'][35])
$($months['October'][36]) $($months['October'][37])                 $($months['November'][36]) $($months['November'][37])                 $($months['December'][36]) $($months['December'][37])
"@

    # Output the calendar using Write-HostColor
    Write-HostColor $year_template
}