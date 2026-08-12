#include once "Inc\Globals.bi"

sub CreateSidePanelControls(byval hDlg as HWND)
  dim hFont as HFONT = cast(HFONT, GetStockObject(DEFAULT_GUI_FONT))
  hSideBtnClose = CreateWindowEx(0, "BUTTON", "Close", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNCLOSE), hInstanceGlobal, NULL)
  hSideBtnBasic = CreateWindowEx(0, "BUTTON", "Basic Mode", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_BTNBASIC), hInstanceGlobal, NULL)
  hSideLblFind = CreateWindowEx(0, "STATIC", "Find:", WS_CHILD or WS_VISIBLE or SS_LEFT, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDELBLFIND), hInstanceGlobal, NULL)
  hSideEditSearch = CreateWindowEx(0, "COMBOBOX", "", WS_CHILD or WS_VISIBLE or CBS_DROPDOWN or CBS_AUTOHSCROLL or WS_VSCROLL or WS_TABSTOP, 0, 0, 10, 150, hDlg, cast(HMENU, IDC_SIDEEDITSEARCH), hInstanceGlobal, NULL)
  hSideBtnClearSearch = CreateWindowEx(0, "BUTTON", "Clear", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNCLEARSEARCH), hInstanceGlobal, NULL)
  hSideLblReplace = CreateWindowEx(0, "STATIC", "Replace:", WS_CHILD or WS_VISIBLE or SS_LEFT, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDELBLREPLACE), hInstanceGlobal, NULL)
  hSideEditReplace = CreateWindowEx(0, "COMBOBOX", "", WS_CHILD or WS_VISIBLE or CBS_DROPDOWN or CBS_AUTOHSCROLL or WS_VSCROLL or WS_TABSTOP, 0, 0, 10, 150, hDlg, cast(HMENU, IDC_SIDEEDITREPLACE), hInstanceGlobal, NULL)
  hSideBtnClearReplace = CreateWindowEx(0, "BUTTON", "Clear", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNCLEARREPLACE), hInstanceGlobal, NULL)
  hSidePath = CreateWindowEx(WS_EX_CLIENTEDGE, "EDIT", "C:\", WS_CHILD or WS_VISIBLE or ES_AUTOHSCROLL or WS_TABSTOP or ES_READONLY, 0, 0, 10, 22, hDlg, cast(HMENU, IDC_SIDEPATH), hInstanceGlobal, NULL)
  hSideBtnBrowse = CreateWindowEx(0, "BUTTON", "...", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNBROWSE), hInstanceGlobal, NULL)
  hSideChkMatchCase = CreateWindowEx(0, "BUTTON", "Match Case", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDECHKMATCHCASE), hInstanceGlobal, NULL)
  hSideChkWholeWord = CreateWindowEx(0, "BUTTON", "Whole Word", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDECHKWHOLEWORD), hInstanceGlobal, NULL)
  hSideChkAllFiles = CreateWindowEx(0, "BUTTON", "All Files", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDECHKALLFILES), hInstanceGlobal, NULL)
  hSideChkInFolder = CreateWindowEx(0, "BUTTON", "In Folder", WS_CHILD or WS_VISIBLE or BS_AUTOCHECKBOX or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDECHKINFOLDER), hInstanceGlobal, NULL)
  hSideLblFilter = CreateWindowEx(0, "STATIC", "Filter:", WS_CHILD or WS_VISIBLE or SS_LEFT, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDELBLFILTER), hInstanceGlobal, NULL)
  hSideEditFilter = CreateWindowEx(WS_EX_CLIENTEDGE, "EDIT", "", WS_CHILD or WS_VISIBLE or ES_AUTOHSCROLL or WS_TABSTOP, 0, 0, 10, 22, hDlg, cast(HMENU, IDC_SIDEEDITFILTER), hInstanceGlobal, NULL)
  hSideBtnFindNext = CreateWindowEx(0, "BUTTON", "Find Next", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNFINDNEXT), hInstanceGlobal, NULL)
  hSideBtnReplace = CreateWindowEx(0, "BUTTON", "Replace", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNREPLACE), hInstanceGlobal, NULL)
  hSideBtnReplaceAll = CreateWindowEx(0, "BUTTON", "Replace All", WS_CHILD or WS_VISIBLE or BS_PUSHBUTTON or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDEBTNREPLACEALL), hInstanceGlobal, NULL)
  hSideListResults = CreateWindowEx(WS_EX_CLIENTEDGE, WC_LISTVIEW, "", WS_CHILD or WS_VISIBLE or LVS_REPORT or LVS_SHOWSELALWAYS or WS_TABSTOP, 0, 0, 10, 10, hDlg, cast(HMENU, IDC_SIDELISTRESULTS), hInstanceGlobal, NULL)
  SendMessage(hSideListResults, LVM_SETEXTENDEDLISTVIEWSTYLE, 0, LVS_EX_FULLROWSELECT or LVS_EX_GRIDLINES)
  dim lvc as LVCOLUMN
  lvc.mask = LVCF_TEXT or LVCF_WIDTH
  lvc.cx = 60
  lvc.pszText = @"Directory"
  SendMessage(hSideListResults, LVM_INSERTCOLUMN, 0, cast(LPARAM, @lvc))
  lvc.cx = 60
  lvc.pszText = @"File"
  SendMessage(hSideListResults, LVM_INSERTCOLUMN, 1, cast(LPARAM, @lvc))
  lvc.cx = 40
  lvc.pszText = @"Line"
  SendMessage(hSideListResults, LVM_INSERTCOLUMN, 2, cast(LPARAM, @lvc))
  lvc.cx = 120
  lvc.pszText = @"Text"
  SendMessage(hSideListResults, LVM_INSERTCOLUMN, 3, cast(LPARAM, @lvc))
  hSideStatus = CreateWindowEx(0, "msctls_statusbar32", "", WS_CHILD or WS_VISIBLE, 0, 0, 0, 0, hDlg, cast(HMENU, IDC_SIDESTATUS), hInstanceGlobal, NULL)
  dim ctls(20) as HWND = {hSideBtnClose, hSideBtnBasic, hSideLblFind, hSideEditSearch, hSideBtnClearSearch, hSideLblReplace, hSideEditReplace, hSideBtnClearReplace, hSidePath, hSideBtnBrowse, hSideChkMatchCase, hSideChkWholeWord, hSideChkAllFiles, hSideChkInFolder, hSideLblFilter, hSideEditFilter, hSideBtnFindNext, hSideBtnReplace, hSideBtnReplaceAll, hSideListResults, hSideStatus}
  for i as integer = 0 to 20
    SendMessage(ctls(i), WM_SETFONT, cast(WPARAM, hFont), TRUE)
  next
  dim hEditSideSearch as HWND = FindWindowEx(hSideEditSearch, NULL, "EDIT", NULL)
  if hEditSideSearch <> NULL then
    lpInputOldProc = cast(WNDPROC, SetWindowLongPtr(hEditSideSearch, GWLP_WNDPROC, cast(LONG_PTR, @EditSubclassProc)))
  end if
  dim hEditSideReplace as HWND = FindWindowEx(hSideEditReplace, NULL, "EDIT", NULL)
  if hEditSideReplace <> NULL then
    SetWindowLongPtr(hEditSideReplace, GWLP_WNDPROC, cast(LONG_PTR, @EditSubclassProc))
  end if
  SetWindowLongPtr(hSidePath, GWLP_WNDPROC, cast(LONG_PTR, @EditSubclassProc))
  PopulateCombo(hSideEditSearch, TRUE)
  PopulateCombo(hSideEditReplace, FALSE)
  SetWindowTextW(hSideEditSearch, @wsGlobalSearch)
  SetWindowTextW(hSideEditReplace, @wsGlobalReplace)
  SetWindowTextW(hSidePath, @wsGlobalPath)
  SetWindowTextW(hSideEditFilter, @wsGlobalFilter)
  SendMessage(hSideChkMatchCase, BM_SETCHECK, bGlobalMatchCase, 0)
  SendMessage(hSideChkWholeWord, BM_SETCHECK, bGlobalWholeWord, 0)
  SendMessage(hSideChkAllFiles, BM_SETCHECK, bGlobalAllFiles, 0)
  SendMessage(hSideChkInFolder, BM_SETCHECK, bGlobalInFolder, 0)
  EnableWindow(hSidePath, bGlobalInFolder)
  EnableWindow(hSideBtnBrowse, bGlobalInFolder)
  dim wsReady as WString * 32 = "Ready"
  SendMessage(hSideStatus, SB_SETTEXTW, 0, cast(LPARAM, @wsReady))
end sub

sub LayoutSidePanelControls(byval hDlg as HWND, byval w as integer, byval h as integer)
  dim hDWP as HDWP = BeginDeferWindowPos(20)
  if hDWP <> NULL then
    dim m as integer = 4
    dim leftM as integer = 8
    dim ctrlH as integer = 22
    dim comboH as integer = 150
    dim topBtnH as integer = 20
    dim lblW as integer = 55
    dim btnBrowseW as integer = 30
    dim clearBtnW as integer = 40
    dim inputW as integer = w - leftM - lblW - clearBtnW - m
    dim y as integer = m
    hDWP = DeferWindowPos(hDWP, hSideBtnClose, NULL, w - 45 - m, y, 45, topBtnH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnBasic, NULL, w - 45 - m - 80 - m, y, 80, topBtnH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += topBtnH + m
    hDWP = DeferWindowPos(hDWP, hSideLblFind, NULL, leftM, y + 2, lblW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideEditSearch, NULL, leftM + lblW, y, inputW, comboH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnClearSearch, NULL, leftM + lblW + inputW, y, clearBtnW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    hDWP = DeferWindowPos(hDWP, hSideLblReplace, NULL, leftM, y + 2, lblW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideEditReplace, NULL, leftM + lblW, y, inputW, comboH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnClearReplace, NULL, leftM + lblW + inputW, y, clearBtnW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    dim inFolderW as integer = 75
    dim pathW as integer = w - leftM - inFolderW - btnBrowseW - (m * 2)
    hDWP = DeferWindowPos(hDWP, hSideChkInFolder, NULL, leftM, y, inFolderW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSidePath, NULL, leftM + inFolderW + m, y, pathW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnBrowse, NULL, w - btnBrowseW - m, y, btnBrowseW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    dim chk1W as integer = 80
    dim chk2W as integer = 85
    dim chk3W as integer = 70
    hDWP = DeferWindowPos(hDWP, hSideChkMatchCase, NULL, leftM, y, chk1W, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideChkWholeWord, NULL, leftM + chk1W + m, y, chk2W, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideChkAllFiles, NULL, leftM + chk1W + chk2W + (m * 2), y, chk3W, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    hDWP = DeferWindowPos(hDWP, hSideLblFilter, NULL, leftM, y + 2, 40, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideEditFilter, NULL, leftM + 40, y, w - leftM - 40 - m, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    dim actionSpace as integer = w - leftM - m - (m * 2)
    dim btnW as integer = actionSpace \ 3
    hDWP = DeferWindowPos(hDWP, hSideBtnFindNext, NULL, leftM, y, btnW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnReplace, NULL, leftM + btnW + m, y, btnW, ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    hDWP = DeferWindowPos(hDWP, hSideBtnReplaceAll, NULL, leftM + (btnW * 2) + (m * 2), y, w - leftM - m - (btnW * 2) - (m * 2), ctrlH, SWP_NOZORDER or SWP_NOACTIVATE)
    y += ctrlH + m
    dim rcStatus as RECT
    GetWindowRect(hSideStatus, @rcStatus)
    dim statusH as integer = rcStatus.bottom - rcStatus.top
    if statusH = 0 then statusH = 22
    dim listH as integer = h - y - statusH - m
    if listH < 0 then listH = 0
    hDWP = DeferWindowPos(hDWP, hSideListResults, NULL, leftM, y, w - leftM - m, listH, SWP_NOZORDER or SWP_NOACTIVATE)
    EndDeferWindowPos(hDWP)
  end if
  SendMessage(hSideStatus, WM_SIZE, 0, 0)
  RedrawWindow(hDlg, NULL, NULL, RDW_INVALIDATE or RDW_ERASE or RDW_UPDATENOW or RDW_ALLCHILDREN)
end sub