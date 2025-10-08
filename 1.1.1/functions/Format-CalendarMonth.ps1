function Format-CalendarMonth {
    [CmdletBinding()]
    param (
        # Parameter help description
        [ValidateNotNullOrEmpty()]
        [ValidateSet("Month", "MonthAndYear")]
        [string]
        $Title = "Month",

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Year,

        [parameter(Mandatory)]
        [ValidateNotNullOrEmpty()]
        [string]
        $Month,

        [parameter(Mandatory = $false)]
        [allownull()]
        [int[]]
        $holidays
    )

    # Convert the year and month to integers
    $yearInt = [int]$Year
    $monthInt = [DateTime]::ParseExact($Month, "MMMM", $null).Month

    # Determine the first day of the month
    $firstDayOfMonth = (Get-Date -Year $yearInt -Month $monthInt -Day 1).DayOfWeek
    
    #Convert DayOfWeek enum to integer 
    switch ($firstDayOfMonth) {
        "Sunday" {$FirstDayOfMonthInt = 0}
        "Monday" {$FirstDayOfMonthInt = 1}
        "Tuesday" {$FirstDayOfMonthInt = 2}
        "Wednesday" {$FirstDayOfMonthInt = 3}
        "Thursday" {$FirstDayOfMonthInt = 4}
        "Friday" {$FirstDayOfMonthInt = 5}
        "Saturday" {$FirstDayOfMonthInt = 6}
    }

    # Determine the number of days in the month
    $daysInMonth = [DateTime]::DaysInMonth($yearInt, $monthInt)

    # Get today's date
    $today = Get-Date

    # Determine the title based on the Title parameter
    if ($Title -eq "MonthAndYear") {
        $titleString = "$Month $Year"
    }
    else {
        $titleString = "$Month"
    }

    # Calculate padding for centering the title
    $paddingLength = [int]([Math]::Floor((20 - $titleString.Length) / 2))
    $padding = " " * $paddingLength

    # Output the title centered
    Write-Host "$padding$titleString"

    # Output the header
    Write-Host "Su Mo Tu We Th Fr Sa"

    # Output leading spaces based on the first day of the month
    $leadingSpaces = "   " * $FirstDayOfMonthInt
    Write-Host -NoNewline $leadingSpaces

    # Loop through the days of the month
    for ($i = 1; $i -le $daysInMonth; $i++) {
        # Check if the current day is today
        if ($i -eq $today.day -and $monthInt -eq $today.Month -and $yearInt -eq $today.Year) {
            # Highlight today with inverted colors
            Write-Host -NoNewline ("{0,2}" -f $i) -BackgroundColor Gray -ForegroundColor DarkRed
        }
        # Check if the current day is a holiday
        elseif ($holidays -contains $i) {
            # Output holiday in a different color
            Write-Host -NoNewline ("{0,2}" -f $i) -ForegroundColor Red
        }
        else {
            # Output the day
            Write-Host -NoNewline ("{0,2}" -f $i)
        }

        # Add a space after each day
        Write-Host -NoNewline " "

        # Check if we need to start a new line
        if ((($FirstDayOfMonthInt + $i) % 7) -eq 0) {
            Write-Host ""
        }
    }

    # Add a final newline if necessary
    if ((($FirstDayOfMonthInt + $daysInMonth) % 7) -ne 0) {
        Write-Host ""
    }
}