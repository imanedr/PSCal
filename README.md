# PSCal

A PowerShell module that displays a Linux-like calendar directly in your console with support for holiday highlighting and multiple display modes.

<img width="190" height="157" alt="image" src="https://github.com/user-attachments/assets/9113a263-4c9c-4dca-8d1b-45222b838cbb" />

<img width="217" height="151" alt="image" src="https://github.com/user-attachments/assets/d298b61b-43e3-406f-bb3c-0841f70a0cfe" />

<img width="609" height="702" alt="image" src="https://github.com/user-attachments/assets/c28b693e-eac6-4613-946e-80caf317ffc1" />

![PowerShell](https://img.shields.io/badge/PowerShell-5.1+-blue.svg)
![Version](https://img.shields.io/badge/version-1.1.0-green.svg)
![License](https://img.shields.io/badge/license-Copyright%202025-red.svg)

## Features

- 🗓️ Display current month, specific month, or entire year calendar
- 🎨 Color-coded dates with customizable highlighting
- 📅 Holiday support with configurable dates
- 🔍 Current date highlighting with inverted colors
- 💻 Linux `cal` command-like interface with PowerShell alias
- 🎯 Clean, minimal console output

## Installation

### Manual Installation

1. Clone or download this repository:
```powershell
git clone https://github.com/imanedr/PSCal.git
```

2. Copy the `1.1.0` folder to one of your PowerShell module paths:
```powershell
$env:PSModulePath -split ';'
# Copy to a path from the list above, e.g.:
Copy-Item -Path ".\PSCal\1.1.0\*" -Destination "$env:USERPROFILE\Documents\PowerShell\Modules\PSCal" -Recurse
```

3. Import the module:
```powershell
Import-Module PSCal
```

### Auto-load on Startup (Optional)

Add the following line to your PowerShell profile:
```powershell
Import-Module PSCal
```

To find your profile location:
```powershell
$PROFILE
```

## Usage

### Basic Commands

**Display current month:**
```powershell
Show-Calendar
# or use the alias
cal
```

**Display specific month:**
```powershell
Show-Calendar -Month July
cal -Month December
```

**Display entire year:**
```powershell
Show-Calendar -Year 2025
cal -Year 2026
```

**Display specific month and year:**
```powershell
Show-Calendar -Year 2025 -Month May
cal -Year 2024 -Month January
```

### Parameters

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `-Year` | Int | No | Year to display (1500-3000) |
| `-Month` | String | No | Month name (January-December) |

## Configuration

### Holiday Configuration

Holidays are defined in the `holidays.txt` file located in the module directory. Each line represents a holiday in `YYYY/MM/DD` format.

**Example holidays.txt:**
```
2025/01/01
2025/02/17
2025/04/18
2025/05/19
2025/07/01
2025/12/25
```

To customize holidays:
1. Navigate to your module installation directory
2. Edit the `holidays.txt` file
3. Add or remove dates in `YYYY/MM/DD` format
4. Save the file

Holidays will be displayed in red color in the calendar.

## Module Architecture

### Core Functions

#### `Show-Calendar`
Main entry point function that orchestrates calendar display based on provided parameters.

**Features:**
- Validates year (1500-3000) and month ranges
- Loads holidays from configuration file
- Routes to appropriate formatting function
- Provides comprehensive help documentation

#### `Format-CalendarMonth`
Formats and displays a single month calendar.

**Features:**
- Centered month/year title
- Week starts on Sunday (Su Mo Tu We Th Fr Sa)
- Current date highlighting (gray background, dark red text)
- Holiday highlighting (red text)
- Proper day alignment based on first day of month
- Leap year support

#### `Format-CalendarYear`
Formats and displays a full year calendar with all 12 months in a grid layout.

**Features:**
- 3-column grid layout (4 rows of 3 months)
- Year header centered at top
- All months aligned and properly spaced
- Current date and holiday highlighting
- Efficient template-based rendering
- Leap year detection and handling

#### `Get-Holidays`
Retrieves holiday dates from configuration file.

**Features:**
- Reads from `holidays.txt` file
- Filters by year and optionally by month
- Returns DateTime objects for easy comparison
- Handles missing file gracefully

#### `Write-HostColor`
Custom console output function supporting inline color tags.

**Features:**
- Inline color syntax: `[col:colorname]` and `[bg:colorname]`
- Supports all PowerShell console colors
- Optimized regex-based parsing
- Minimal Write-Host calls for performance
- Default color fallback

**Supported Colors:** Black, DarkBlue, DarkGreen, DarkCyan, DarkRed, DarkMagenta, DarkYellow, Gray, DarkGray, Blue, Green, Cyan, Red, Magenta, Yellow, White

## Color Scheme

| Element | Foreground | Background | Description |
|---------|------------|------------|-------------|
| Normal dates | Default | Default | Regular calendar days |
| Current date | Dark Red | Gray | Today's date (highlighted) |
| Holidays | Red | Default | Configured holiday dates |

## Module Structure

```
PSCal/
├── PSCal.psd1                    # Module manifest
├── PSCal.psm1                    # Module loader
├── Format-CalendarMonth.ps1      # Single month formatter
├── Format-CalendarYear.ps1       # Full year formatter
├── Show-Calendar.ps1             # Main function & holiday loader
├── Write-HostColor.ps1           # Color output utility
└── holidays.txt                  # Holiday configuration
```

## Technical Details

- **Module Version:** 1.1.0
- **GUID:** 8a9ca80f-357f-435a-9a77-cbeb2a1637f5
- **PowerShell Version:** 5.1+ compatible
- **Exported Function:** `Show-Calendar`
- **Exported Alias:** `cal`

## Examples

### Example 1: Quick Month View
```powershell
PS C:\> cal
    October 2025
Su Mo Tu We Th Fr Sa
          1  2  3  4
 5  6  7  8  9 10 11
12 13 14 15 16 17 18
19 20 21 22 23 24 25
26 27 28 29 30 31
```

### Example 2: Specific Month
```powershell
PS C:\> Show-Calendar -Month December -Year 2025
    December 2025
Su Mo Tu We Th Fr Sa
    1  2  3  4  5  6
 7  8  9 10 11 12 13
14 15 16 17 18 19 20
21 22 23 24 25 26 27
28 29 30 31
```

### Example 3: Full Year View
```powershell
PS C:\> cal -Year 2025
# Displays all 12 months in a grid format
                              2025
      January               February               March
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
          1  2  3  4                     1                     1
 5  6  7  8  9 10 11   2  3  4  5  6  7  8   2  3  4  5  6  7  8
12 13 14 15 16 17 18   9 10 11 12 13 14 15   9 10 11 12 13 14 15
19 20 21 22 23 24 25  16 17 18 19 20 21 22  16 17 18 19 20 21 22
26 27 28 29 30 31     23 24 25 26 27 28     23 24 25 26 27 28 29
                                            30 31

       April                  May                   June
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
       1  2  3  4  5               1  2  3   1  2  3  4  5  6  7
 6  7  8  9 10 11 12   4  5  6  7  8  9 10   8  9 10 11 12 13 14
13 14 15 16 17 18 19  11 12 13 14 15 16 17  15 16 17 18 19 20 21
20 21 22 23 24 25 26  18 19 20 21 22 23 24  22 23 24 25 26 27 28
27 28 29 30           25 26 27 28 29 30 31  29 30


        July                 August              September
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
       1  2  3  4  5                  1  2      1  2  3  4  5  6
 6  7  8  9 10 11 12   3  4  5  6  7  8  9   7  8  9 10 11 12 13
13 14 15 16 17 18 19  10 11 12 13 14 15 16  14 15 16 17 18 19 20
20 21 22 23 24 25 26  17 18 19 20 21 22 23  21 22 23 24 25 26 27
27 28 29 30 31        24 25 26 27 28 29 30  28 29 30
                      31

      October               November              December
Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa  Su Mo Tu We Th Fr Sa
          1  2  3  4                     1      1  2  3  4  5  6
 5  6  7  8  9 10 11   2  3  4  5  6  7  8   7  8  9 10 11 12 13
12 13 14 15 16 17 18   9 10 11 12 13 14 15  14 15 16 17 18 19 20
19 20 21 22 23 24 25  16 17 18 19 20 21 22  21 22 23 24 25 26 27
26 27 28 29 30 31     23 24 25 26 27 28 29  28 29 30 31
                      30
```

## Known Limitations

- Week starts on Sunday (not configurable)
- Holiday file must be in module directory
- Requires manual holiday file editing (no GUI)
- Date range limited to years 1500-3000

## Changelog

### Version 1.1.0
- Fixed some minor issues
- Improved stability and performance

### Version 1.0.0
- Initial release
- Basic calendar display functionality
- Holiday support
- Year and month views

## Contributing

Contributions are welcome! Please feel free to submit issues or pull requests.

## Author

**Iman Edrisian**

## License

Copyright (c) 2025 Iman Edrisian, Inc. All rights reserved.

## Acknowledgments

Inspired by the classic Unix/Linux `cal` command, bringing familiar functionality to PowerShell users.

---

⭐ If you find this module useful, please consider giving it a star on GitHub!
