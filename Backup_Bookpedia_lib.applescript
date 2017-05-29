(* MIT License

 Copyright (c) 2017 Justin Marshall

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE. *)

set old to (path to frontmost application as text)

tell application "Bookpedia" to activate

tell application "System Events" to tell process "Bookpedia"
	
	set homeDirectory to "~/"
	set backupDirectoryName to "Bookpedia_automated_backups"
	set backupDirectoryPath to homeDirectory & backupDirectoryName
	set backupFileName to "Bookpedia_library_backup"
	
	my deleteFileNamed(backupDirectoryPath)
	
	set libraryCollectionIndex to 1
	my clickRow(libraryCollectionIndex)
	
	set titleButton to my selectButton(1)
	my makeAscendingIfNotAlready(titleButton)
	
	my scrollToTop()
	
	# .bookpedia (XML)
	my exportViaTabNumber(1, backupFileName)
	
	delay 3
	
	# ZIP archive
	my exportViaTabNumber(2, backupFileName)
	
	delay 3
	
	# HTML
	my exportViaTabNumber(3, backupFileName)
	
	my createBackupDirectory(backupDirectoryName)
	my moveFilesToCommonDirectory(homeDirectory & backupFileName, backupDirectoryPath)
end tell

delay 1
activate application old

on clickRow(rowNumber)
	tell application "System Events" to tell process "Bookpedia"
		tell row rowNumber of outline 1 of scroll area 1 of splitter group 1 of splitter group 1 of window 1
			set selected to true
		end tell
	end tell
end clickRow

on selectButton(buttonNumber)
	tell application "System Events" to tell process "Bookpedia"
		return button buttonNumber of group 1 of table 1 of scroll area 1 of group 1 of splitter group 2 of splitter group 1 of window 1
	end tell
end selectButton

on allFilesNamed(theFileName)
	return {theFileName, theFileName & ".bookpedia", theFileName & ".zip"}
end allFilesNamed

on createBackupDirectory(directoryName)
	tell application "Finder"
		# TODO: only do this if the directory does not already exist. this would save you from having to delete the directory at the beginning of the script
		make new folder at home with properties {name:directoryName}
	end tell
end createBackupDirectory

on moveFilesToCommonDirectory(backupFileName, commonDirectory)
	repeat with theFile in allFilesNamed(backupFileName)
		do shell script "mv " & theFile & " " & commonDirectory & "/"
	end repeat
end moveFilesToCommonDirectory

on deleteFileNamed(theFile)
	do shell script "rm -rf " & theFile
end deleteFileNamed

on makeAscendingIfNotAlready(theButton)
	tell application "System Events" to tell process "Bookpedia"
		if value of attribute "AXSortDirection" of theButton is "AXDescendingSortDirection" then
			perform action "AXPress" of theButton
		end if
	end tell
end makeAscendingIfNotAlready

on scrollToTop()
	tell application "System Events" to tell process "Bookpedia"
		key code 115 -- fn + left arrow
	end tell
end scrollToTop

on showExportUI()
	tell application "System Events" to tell process "Bookpedia"
		keystroke "s" using command down
	end tell
end showExportUI

on selectExportTabNumber(exportTabNumber)
	tell application "System Events" to tell process "Bookpedia"
		click button exportTabNumber of toolbar 1 of sheet 1 of window 1
	end tell
end selectExportTabNumber

on clickExport()
	tell application "System Events" to tell process "Bookpedia"
		click last button of sheet 1 of window 1
	end tell
end clickExport

on changeFileNameTo(newFileName)
	tell application "System Events" to tell process "Bookpedia"
		set value of text field 1 of sheet 1 of window 1 to newFileName
	end tell
end changeFileNameTo

on changeDirectoryToHome()
	tell application "System Events" to tell process "Bookpedia"
		keystroke "h" using {command down, shift down}
	end tell
end changeDirectoryToHome

on exportViaTabNumber(exportTabNumber, newFileName)
	my showExportUI()
	my selectExportTabNumber(exportTabNumber)
	my clickExport()
	my changeFileNameTo(newFileName)
	my changeDirectoryToHome()
	my saveIt()
end exportViaTabNumber

on saveIt()
	tell application "System Events" to tell process "Bookpedia"
		click button 1 of sheet 1 of window 1
	end tell
end saveIt

