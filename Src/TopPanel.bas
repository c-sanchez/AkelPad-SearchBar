#include once "Inc\Globals.bi"

' -- Create Top Controls ----------------------------------------------------
sub CreateTopPanelControls(byval hDlg as HWND)
  dim hFont as HFONT = cast(HFONT, GetStockObject(DEFAULT_GUI_FONT))

  hBtnClose = CreateWindowEx(0, "BUTTON", "Close", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNCLOSE), hInstanceGlobal, NULL)
  hLblFind = CreateWindowEx(0, "STATIC", "Find:", WS_CHILD or WS_VISIBLE or SS_LEFT, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_LBLFIND), hInstanceGlobal, NULL)
  hEditSearch = CreateWindowEx(0, "COMBOBOX", "", WS_CHILD or WS_VISIBLE or CBS_DROPDOWN or CBS_AUTOHSCROLL or WS_VSCROLL or WS_TABSTOP, _
    0, 0, 10, 150, hDlg, cast(HMENU, IDC_EDITSEARCH), hInstanceGlobal, NULL)
  hBtnClearSearch = CreateWindowEx(0, "BUTTON", "Clear", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNCLEARSEARCH), hInstanceGlobal, NULL)
  hBtnPrev = CreateWindowEx(0, "BUTTON", "Prev", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNPREV), hInstanceGlobal, NULL)
  hBtnNext = CreateWindowEx(0, "BUTTON", "Next", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNNEXT), hInstanceGlobal, NULL)
  hChkMatchCase = CreateWindowEx(0, "BUTTON", "Match Case", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_CHKMATCHCASE), hInstanceGlobal, NULL)
  hChkWholeWord = CreateWindowEx(0, "BUTTON", "Whole Word", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_CHKWHOLEWORD), hInstanceGlobal, NULL)
  hChkAllFiles = CreateWindowEx(0, "BUTTON", "All Files", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_CHKALLFILES), hInstanceGlobal, NULL)
  hBtnAdvanced = CreateWindowEx(0, "BUTTON", "Advanced", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, _
    0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNADVANCED), hInstanceGlobal, NULL)

  dim ctls(9) as HWND = {hBtnClose, hLblFind, hEditSearch, hBtnClearSearch, hBtnPrev, hBtnNext, hChkMatchCase, hChkWholeWord, hChkAllFiles, hBtnAdvanced}
  for i as integer = 0 to 9
    SendMessage(ctls(i), WM_SETFONT, cast(WPARAM, hFont), TRUE)
  next

  ' Subclass a la caja de texto interna del ComboBox
  dim hEditTopSearch as HWND = FindWindowEx(hEditSearch, NULL, "EDIT", NULL)
  if hEditTopSearch <> NULL then
    lpInputOldProc = cast(WNDPROC, SetWindowLongPtr(hEditTopSearch, GWLP_WNDPROC, cast(LONG_PTR, @EditSubclassProc)))
  end if
  
  PopulateCombo(hEditSearch, TRUE)
  SetWindowTextW(hEditSearch, @wsGlobalSearch)
  SendMessage(hChkMatchCase, BM_SETCHECK, bGlobalMatchCase, 0)
  SendMessage(hChkWholeWord, BM_SETCHECK, bGlobalWholeWord, 0)
  SendMessage(hChkAllFiles, BM_SETCHECK, bGlobalAllFiles, 0)
end sub

' -- Layout Top -------------------------------------------------------------
sub LayoutTopPanelControls(byval hDlg as HWND, byval w as integer, byval h as integer)
  dim hDWP as HDWP = BeginDeferWindowPos(10)
  if hDWP <> NULL then
    dim x as integer = 4
    dim y as integer = 4
    dim ctrlH as integer = 20
    dim comboH as integer = 150
    dim m as integer = 4
    
    ' Left side flow
    hDWP = DeferWindowPos(hDWP, hLblFind, NULL, x, y + 2, 35, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 35 + m
    hDWP = DeferWindowPos(hDWP, hEditSearch, NULL, x, y, 110, comboH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 110
    hDWP = DeferWindowPos(hDWP, hBtnClearSearch, NULL, x, y, 40, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 40 + m
    hDWP = DeferWindowPos(hDWP, hBtnPrev, NULL, x, y, 45, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 45 + m
    hDWP = DeferWindowPos(hDWP, hBtnNext, NULL, x, y, 45, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 45 + m
    hDWP = DeferWindowPos(hDWP, hChkMatchCase, NULL, x, y, 85, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 85 + m
    hDWP = DeferWindowPos(hDWP, hChkWholeWord, NULL, x, y, 85, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    x += 85 + m
    hDWP = DeferWindowPos(hDWP, hChkAllFiles, NULL, x, y, 70, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    
    ' Right side flow
    dim rightX as integer = w - m
    
    rightX -= 45
    hDWP = DeferWindowPos(hDWP, hBtnClose, NULL, rightX, y, 45, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    
    rightX -= (80 + m)
    hDWP = DeferWindowPos(hDWP, hBtnAdvanced, NULL, rightX, y, 80, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    
    EndDeferWindowPos(hDWP)
  end if
  RedrawWindow(hDlg, NULL, NULL, RDW_INVALIDATE or RDW_ERASE or RDW_UPDATENOW or RDW_ALLCHILDREN)
end sub