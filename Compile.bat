@echo off
fbc -dll -gen gcc "SearchBar.bas" "Src\Globals.bas" "Src\Utils.bas" "Src\History.bas" "Src\SearchReplace.bas" "Src\TopPanel.bas" "Src\SidePanel.bas" "Src\Dialogs.bas" "Resource.rc"
pause