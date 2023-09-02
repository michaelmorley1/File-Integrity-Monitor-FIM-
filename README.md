# File Integrity Monitoring with PowerShell

This PowerShell script allows you to perform file integrity monitoring on a target folder. It calculates and maintains file hashes to detect any changes or deletions in the monitored files.

## Features

- Calculate SHA-512 file hashes.
- Create a new baseline of file hashes.
- Monitor file integrity based on an existing baseline.
- Detect changes and deletions in monitored files.

## Prerequisites

- PowerShell ISE for executing the script.
- Windows OS (Tested on Windows 11).

## Usage

1. Clone or download this repository to your local machine.

2. Open PowerShell ISE.

3. Navigate to the repository directory.

4. Execute the script by running the `fim.ps1` file.

5. Follow the on-screen instructions:
   - Choose to create a new baseline (Option 'A') or use an existing baseline (Option 'B').

6. For Option 'A':
   - The script will calculate file hashes for all files in the 'Files' directory.
   - The baseline will be stored in 'baseline.txt'.
  
     <p align="center">
<img src="https://i.imgur.com/5tLfVEH.png" height="80%" width="80%" alt="baseline"/>
</p>

_baseline file_

7. For Option 'B':
   - The script will load the baseline from 'baseline.txt'.
   - It will continuously monitor file integrity and display notifications for changes to the file, the addition of a file or deletions.

8. To stop monitoring, press `Ctrl+C` in the PowerShell console.

## File Structure

- `fim.ps1`: The main PowerShell script.
- `Files/`: The target folder where files are monitored.
- `baseline.txt`: Stores the baseline file hashes.

## Notes

- When choosing Option 'A', the script deletes an existing 'baseline.txt' file to avoid overwriting.

<p align="center">
<img src="https://i.imgur.com/VWMcGPp.png" height="80%" width="80%" alt="baseline"/>
</p>

*Script is running showing changes that have been made to the files*
