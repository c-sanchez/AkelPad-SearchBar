#include once "Inc\Globals.bi"
function GetMsgProc(byval nCode as integer, byval wParam as WPARAM, byval lParam as LPARAM) as LRESULT
  if nCode = HC_ACTION andalso wParam = PM_REMOVE then
    dim pMsg as MSG ptr = cast(MSG ptr, lParam)
    if pMsg->message >= WM_KEYFIRST andalso pMsg->message <= WM_KEYLAST then
      dim hFocus as HWND = GetFocus()
      if hPanelDlg <> NULL andalso hFocus <> NULL andalso (hFocus = hPanelDlg orelse IsChild(hPanelDlg, hFocus)) then
        if IsDialogMessage(hPanelDlg, pMsg) then
          pMsg->message = WM_NULL
        end if
      end if
    end if
  end if
  return CallNextHookEx(hKbdHook, nCode, wParam, lParam)
end function
sub DeactivatePlugin()
  bDragging = FALSE
  if hPanelDlg <> NULL then
    SaveSettings()
  end if
  if hKbdHook <> NULL then
    UnhookWindowsHookEx(hKbdHook)
    hKbdHook = NULL
  end if
  if lpMainProcData <> NULL then
    SendMessage(hMainWndGlobal, AKD_SETMAINPROC, 0, cast(LPARAM, @lpMainProcData))
    lpMainProcData = NULL
  end if
  if hPanelDlg <> NULL then
    DestroyWindow(hPanelDlg)
    hPanelDlg = NULL
  end if
  bPanelVisible = FALSE
  SendMessage(hMainWndGlobal, AKD_RESIZE, 0, 0)
end sub
function NewMainProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as LRESULT
  select case uMsg
    case AKDN_MAIN_ONSTART_PRESHOW
      if hPanelDlg = NULL then
        hPanelDlg = CreateDialogParam(hInstanceGlobal, MAKEINTRESOURCE(iif(bAdvancedMode, IDD_SIDEPANEL, IDD_TOPPANEL)), hMainWndGlobal, iif(bAdvancedMode, @SidePanelDlgProc, @TopPanelDlgProc), 0)
      end if
    case AKDN_SIZE_ONSTART
      dim ns as NSIZE ptr = cast(NSIZE ptr, lParam)
      if hPanelDlg <> NULL then
        if bAdvancedMode then
          dim maxW as integer = (ns->rcCurrent.right - ns->rcCurrent.left) \ 2
          dim pW as integer = nAdvancedPanelWidth
          if pW > maxW then pW = maxW
          if pW < 250 then pW = 250
          nAdvancedPanelWidth = pW
          dim pH as integer = ns->rcCurrent.bottom - ns->rcCurrent.top
          MoveWindow(hPanelDlg, ns->rcCurrent.right - pW, ns->rcCurrent.top, pW, pH, TRUE)
          ShowWindow(hPanelDlg, SW_SHOW)
          ns->rcCurrent.right -= pW
        else
          dim pW as integer = ns->rcCurrent.right - ns->rcCurrent.left
          MoveWindow(hPanelDlg, ns->rcCurrent.left, ns->rcCurrent.top, pW, PANEL_HEIGHT, TRUE)
          ShowWindow(hPanelDlg, SW_SHOW)
          ns->rcCurrent.top += PANEL_HEIGHT
        end if
        bPanelVisible = TRUE
      end if
    case AKDN_MAIN_ONFINISH
      DeactivatePlugin()
      return 0
  end select
  if lpMainProcData <> NULL andalso lpMainProcData->NextProc <> NULL then
    return lpMainProcData->NextProc(hWnd, uMsg, wParam, lParam)
  end if
  return 0
end function
extern "C"
sub DllAkelPadID alias "DllAkelPadID" (byval pv as PLUGINVERSION ptr) export
  pv->dwAkelDllVersion = AKELDLL
  pv->dwExeMinVersion3x = MAKE_IDENTIFIER(-1, -1, -1, -1)
  pv->dwExeMinVersion4x = MAKE_IDENTIFIER(4, 9, 7, 0)
  pv->pPluginName = @"SearchBar"
end sub
sub Main alias "Main" (byval pd as PLUGINDATA ptr) export
  pd->dwSupport or= PDS_NOANSI
  if (pd->dwSupport and PDS_GETSUPPORT) then exit sub
  hMainWndGlobal = pd->hMainWnd
  hInstanceGlobal = pd->hInstanceDLL
  hInstanceEXEGlobal = pd->hInstanceEXE
  if wsIniPath = "" then
    dim szModule as WString * MAX_PATH
    GetModuleFileNameW(hInstanceGlobal, @szModule, MAX_PATH)
    dim p as integer = InStrRev(szModule, ".")
    if p > 0 then
      wsIniPath = Left(szModule, p - 1) & ".ini"
    else
      wsIniPath = szModule & ".ini"
    end if
    LoadSettings()
  end if
  if (not pd->bOnStart) andalso (lpMainProcData <> NULL) then
    DeactivatePlugin()
  else
    lpMainProcData = NULL
    SendMessage(hMainWndGlobal, AKD_SETMAINPROC, cast(WPARAM, @NewMainProc), cast(LPARAM, @lpMainProcData))
    if hKbdHook = NULL then
      hKbdHook = SetWindowsHookEx(WH_GETMESSAGE, cast(HOOKPROC, @GetMsgProc), NULL, GetCurrentThreadId())
    end if
    if not pd->bOnStart then
      if hPanelDlg = NULL then
        hPanelDlg = CreateDialogParam(hInstanceGlobal, MAKEINTRESOURCE(iif(bAdvancedMode, IDD_SIDEPANEL, IDD_TOPPANEL)), hMainWndGlobal, iif(bAdvancedMode, @SidePanelDlgProc, @TopPanelDlgProc), 0)
      end if
      SendMessage(hMainWndGlobal, AKD_RESIZE, 0, 0)
      if bAdvancedMode then
        if hSideEditSearch <> NULL then SetFocus(hSideEditSearch)
      else
        if hEditSearch <> NULL then SetFocus(hEditSearch)
      end if
    end if
    pd->nUnload = UD_NONUNLOAD_ACTIVE
  end if
end sub
end extern