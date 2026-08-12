#include once "Inc\Globals.bi"
sub LogResult(byref wsMsg as WString)
  if hSideStatus = NULL then exit sub
  SendMessage(hSideStatus, SB_SETTEXTW, 0, cast(LPARAM, @wsMsg))
end sub
sub SelectFolder(byval hOwner as HWND)
  CoInitialize(NULL)
  dim pfd as MyIFileOpenDialog ptr
  dim CLSID_FileOpenDialog_ as GUID
  CLSID_FileOpenDialog_.Data1 = &hdc1c5a9c : CLSID_FileOpenDialog_.Data2 = &he88a : CLSID_FileOpenDialog_.Data3 = &h4dde
  CLSID_FileOpenDialog_.Data4(0) = &ha5 : CLSID_FileOpenDialog_.Data4(1) = &ha1 : CLSID_FileOpenDialog_.Data4(2) = &h60 : CLSID_FileOpenDialog_.Data4(3) = &hf8
  CLSID_FileOpenDialog_.Data4(4) = &h2a : CLSID_FileOpenDialog_.Data4(5) = &h20 : CLSID_FileOpenDialog_.Data4(6) = &hae : CLSID_FileOpenDialog_.Data4(7) = &hf7
  dim IID_IFileOpenDialog_ as GUID
  IID_IFileOpenDialog_.Data1 = &hd57c7288 : IID_IFileOpenDialog_.Data2 = &hd4ad : IID_IFileOpenDialog_.Data3 = &h4768
  IID_IFileOpenDialog_.Data4(0) = &hbe : IID_IFileOpenDialog_.Data4(1) = &h02 : IID_IFileOpenDialog_.Data4(2) = &h9d : IID_IFileOpenDialog_.Data4(3) = &h96
  IID_IFileOpenDialog_.Data4(4) = &h95 : IID_IFileOpenDialog_.Data4(5) = &h32 : IID_IFileOpenDialog_.Data4(6) = &hd9 : IID_IFileOpenDialog_.Data4(7) = &h60
  if CoCreateInstance(@CLSID_FileOpenDialog_, NULL, CLSCTX_INPROC_SERVER, @IID_IFileOpenDialog_, cast(any ptr ptr, @pfd)) = S_OK then
    dim dwOptions as DWORD
    pfd->lpVtbl->GetOptions(pfd, @dwOptions)
    pfd->lpVtbl->SetOptions(pfd, dwOptions or FOS_PICKFOLDERS or FOS_FORCEFILESYSTEM)
    if pfd->lpVtbl->Show(pfd, hOwner) = S_OK then
      dim psi as MyIShellItem ptr
      if pfd->lpVtbl->GetResult(pfd, @psi) = S_OK then
        dim pszName as WString ptr
        if psi->lpVtbl->GetDisplayName(psi, SIGDN_FILESYSPATH, @pszName) = S_OK then
          SetWindowTextW(hSidePath, pszName)
          CoTaskMemFree(pszName)
        end if
        psi->lpVtbl->Release(psi)
      end if
    end if
    pfd->lpVtbl->Release(pfd)
  end if
  CoUninitialize()
end sub
sub SaveControlState()
  if hPanelDlg <> NULL then
    if bAdvancedMode then
      if hSideEditSearch <> NULL then
        GetWindowTextW(hSideEditSearch, @wsGlobalSearch, 1024)
        GetWindowTextW(hSideEditReplace, @wsGlobalReplace, 1024)
        GetWindowTextW(hSidePath, @wsGlobalPath, 1024)
        GetWindowTextW(hSideEditFilter, @wsGlobalFilter, 1024)
        bGlobalMatchCase = SendMessage(hSideChkMatchCase, BM_GETCHECK, 0, 0)
        bGlobalWholeWord = SendMessage(hSideChkWholeWord, BM_GETCHECK, 0, 0)
        bGlobalAllFiles = SendMessage(hSideChkAllFiles, BM_GETCHECK, 0, 0)
        bGlobalInFolder = SendMessage(hSideChkInFolder, BM_GETCHECK, 0, 0)
      end if
    else
      if hEditSearch <> NULL then
        GetWindowTextW(hEditSearch, @wsGlobalSearch, 1024)
        bGlobalMatchCase = SendMessage(hChkMatchCase, BM_GETCHECK, 0, 0)
        bGlobalWholeWord = SendMessage(hChkWholeWord, BM_GETCHECK, 0, 0)
        bGlobalAllFiles = SendMessage(hChkAllFiles, BM_GETCHECK, 0, 0)
      end if
    end if
  end if
end sub
sub LoadSettings()
  bAdvancedMode = GetPrivateProfileIntW("Settings", "AdvancedMode", 0, @wsIniPath)
  bGlobalMatchCase = GetPrivateProfileIntW("Settings", "MatchCase", 0, @wsIniPath)
  bGlobalWholeWord = GetPrivateProfileIntW("Settings", "WholeWord", 0, @wsIniPath)
  bGlobalAllFiles = GetPrivateProfileIntW("Settings", "AllFiles", 0, @wsIniPath)
  bGlobalInFolder = GetPrivateProfileIntW("Settings", "InFolder", 0, @wsIniPath)
  nAdvancedPanelWidth = GetPrivateProfileIntW("Settings", "PanelWidth", 280, @wsIniPath)
  GetPrivateProfileStringW("Settings", "SearchText", "", @wsGlobalSearch, 1024, @wsIniPath)
  GetPrivateProfileStringW("Settings", "ReplaceText", "", @wsGlobalReplace, 1024, @wsIniPath)
  GetPrivateProfileStringW("Settings", "FolderPath", "C:\", @wsGlobalPath, 1024, @wsIniPath)
  GetPrivateProfileStringW("Settings", "FilterText", "*.txt;*.ini", @wsGlobalFilter, 1024, @wsIniPath)
  nSearchHistoryCount = GetPrivateProfileIntW("History", "SearchCount", 0, @wsIniPath)
  if nSearchHistoryCount > MAX_HISTORY then nSearchHistoryCount = MAX_HISTORY
  for i as integer = 0 to nSearchHistoryCount - 1
    dim key as WString * 32 = "Search" & i
    GetPrivateProfileStringW("History", @key, "", @wsSearchHistory(i), 1024, @wsIniPath)
  next
  nReplaceHistoryCount = GetPrivateProfileIntW("History", "ReplaceCount", 0, @wsIniPath)
  if nReplaceHistoryCount > MAX_HISTORY then nReplaceHistoryCount = MAX_HISTORY
  for i as integer = 0 to nReplaceHistoryCount - 1
    dim key as WString * 32 = "Replace" & i
    GetPrivateProfileStringW("History", @key, "", @wsReplaceHistory(i), 1024, @wsIniPath)
  next
end sub
sub SaveSettings()
  SaveControlState()
  dim sVal as WString * 32
  sVal = wstr(bAdvancedMode)
  WritePrivateProfileStringW("Settings", "AdvancedMode", @sVal, @wsIniPath)
  sVal = wstr(bGlobalMatchCase)
  WritePrivateProfileStringW("Settings", "MatchCase", @sVal, @wsIniPath)
  sVal = wstr(bGlobalWholeWord)
  WritePrivateProfileStringW("Settings", "WholeWord", @sVal, @wsIniPath)
  sVal = wstr(bGlobalAllFiles)
  WritePrivateProfileStringW("Settings", "AllFiles", @sVal, @wsIniPath)
  sVal = wstr(bGlobalInFolder)
  WritePrivateProfileStringW("Settings", "InFolder", @sVal, @wsIniPath)
  sVal = wstr(nAdvancedPanelWidth)
  WritePrivateProfileStringW("Settings", "PanelWidth", @sVal, @wsIniPath)
  WritePrivateProfileStringW("Settings", "SearchText", @wsGlobalSearch, @wsIniPath)
  WritePrivateProfileStringW("Settings", "ReplaceText", @wsGlobalReplace, @wsIniPath)
  WritePrivateProfileStringW("Settings", "FolderPath", @wsGlobalPath, @wsIniPath)
  WritePrivateProfileStringW("Settings", "FilterText", @wsGlobalFilter, @wsIniPath)
  sVal = wstr(nSearchHistoryCount)
  WritePrivateProfileStringW("History", "SearchCount", @sVal, @wsIniPath)
  for i as integer = 0 to nSearchHistoryCount - 1
    dim key as WString * 32 = "Search" & i
    WritePrivateProfileStringW("History", @key, @wsSearchHistory(i), @wsIniPath)
  next
  sVal = wstr(nReplaceHistoryCount)
  WritePrivateProfileStringW("History", "ReplaceCount", @sVal, @wsIniPath)
  for i as integer = 0 to nReplaceHistoryCount - 1
    dim key as WString * 32 = "Replace" & i
    WritePrivateProfileStringW("History", @key, @wsReplaceHistory(i), @wsIniPath)
  next
end sub
sub SwitchMode(byval bAdvanced as WINBOOL)
  if hPanelDlg <> NULL then
    SaveControlState()
    SendMessage(hMainWndGlobal, AKD_SETMODELESS, cast(WPARAM, hPanelDlg), MLA_DELETE)
    DestroyWindow(hPanelDlg)
    hPanelDlg = NULL
  end if
  bAdvancedMode = bAdvanced
  dim idDlg as integer = iif(bAdvancedMode, IDD_SIDEPANEL, IDD_TOPPANEL)
  dim pProc as any ptr = iif(bAdvancedMode, @SidePanelDlgProc, @TopPanelDlgProc)
  hPanelDlg = CreateDialogParam(hInstanceGlobal, MAKEINTRESOURCE(idDlg), hMainWndGlobal, pProc, 0)
  SendMessage(hMainWndGlobal, AKD_RESIZE, 0, 0)
end sub
sub OpenSearchResult(byref dirPath as WString, byref fileName as WString, byval lineNum as integer, byref searchText as WString)
  dim filePath as WString * 1024 = dirPath & "\" & fileName
  dim memSize as SIZE_T = len(MYDROPFILES) + (len(filePath) + 2) * 2
  dim hGlobal as HGLOBAL = GlobalAlloc(GHND, memSize)
  if hGlobal <> NULL then
    dim pDrop as MYDROPFILES ptr = cast(MYDROPFILES ptr, GlobalLock(hGlobal))
    pDrop->pFiles = len(MYDROPFILES)
    pDrop->fWide = TRUE
    dim pDest as WString ptr = cast(WString ptr, cast(UBYTE ptr, pDrop) + len(MYDROPFILES))
    *pDest = filePath
    GlobalUnlock(hGlobal)
    SendMessageW(hMainWndGlobal, WM_DROPFILES, cast(WPARAM, hGlobal), 0)
  end if
  dim wsGoto as WString * 32 = lineNum & ":1"
  SendMessageW(hMainWndGlobal, AKD_GOTOW, GT_LINE, cast(LPARAM, @wsGoto))
  dim lpFrame as any ptr = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_CURRENT, 0))
  if lpFrame <> NULL then
    dim hWndEdit as HWND = cast(FRAMEDATAMIN ptr, lpFrame)->hWndEdit
    if hWndEdit <> NULL then
      SetFocus(hWndEdit)
      dim lineIdx as integer = lineNum - 1
      if lineIdx < 0 then lineIdx = 0
      dim charOffset as integer = SendMessage(hWndEdit, EM_LINEINDEX, lineIdx, 0)
      dim bFound as WINBOOL = FALSE
      if len(searchText) > 0 then
        dim fte as FINDTEXTEX64W
        fte.chrg.cpMin = charOffset
        fte.chrg.cpMax = -1
        fte.lpstrText = @searchText
        dim dwFlags as DWORD = FR_DOWN
        if bGlobalMatchCase then dwFlags or= FR_MATCHCASE
        dim nResult as INT_PTR = SendMessage(hWndEdit, EM_FINDTEXTEX64W, dwFlags, cast(LPARAM, @fte))
        if nResult <> -1 then
          SendMessage(hWndEdit, EM_SETSEL, fte.chrgText.cpMax, fte.chrgText.cpMin)
          SendMessage(hWndEdit, EM_SCROLLCARET, 0, 0)
          bFound = TRUE
        end if
      end if
      if not bFound then
        SendMessage(hWndEdit, EM_SETSEL, charOffset, charOffset)
        SendMessage(hWndEdit, EM_SCROLLCARET, 0, 0)
      end if
    end if
  end if
end sub