#include once "Inc\Globals.bi"

function EditSubclassProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as LRESULT
  if uMsg = WM_GETDLGCODE then
    dim lRes as LRESULT = CallWindowProc(lpInputOldProc, hWnd, uMsg, wParam, lParam)
    return lRes and (not DLGC_WANTTAB)
  end if
  if uMsg = WM_KEYDOWN then
    if wParam = asc("A") andalso (GetKeyState(VK_CONTROL) and &h8000) then
      SendMessage(hWnd, EM_SETSEL, 0, -1)
      return 0
    end if
    if wParam = VK_RETURN then
      if bAdvancedMode then
        SendMessage(hPanelDlg, WM_COMMAND, MAKELONG(IDC_SIDEBTNFINDNEXT, 0), cast(LPARAM, hSideBtnFindNext))
      else
        SendMessage(hPanelDlg, WM_COMMAND, MAKELONG(IDC_BTNNEXT, 0), cast(LPARAM, hBtnNext))
      end if
      return 0
    end if
    if wParam = VK_ESCAPE then
      if bAdvancedMode then
        SendMessage(hPanelDlg, WM_COMMAND, MAKELONG(IDC_SIDEBTNCLOSE, 0), cast(LPARAM, hSideBtnClose))
      else
        SendMessage(hPanelDlg, WM_COMMAND, MAKELONG(IDC_BTNCLOSE, 0), cast(LPARAM, hBtnClose))
      end if
      return 0
    end if
  end if
  return CallWindowProc(lpInputOldProc, hWnd, uMsg, wParam, lParam)
end function

function TopPanelDlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as INT_PTR
  select case uMsg
    case WM_INITDIALOG
      CreateTopPanelControls(hDlg)
      SendMessage(hMainWndGlobal, AKD_SETMODELESS, cast(WPARAM, hDlg), MLA_ADD)
      return FALSE
    case WM_SIZE
      if hBtnClose <> NULL then LayoutTopPanelControls(hDlg, LOWORD(lParam), HIWORD(lParam))
      return TRUE
    case WM_SETFOCUS
      if hEditSearch <> NULL then SetFocus(hEditSearch)
      return TRUE
    case WM_COMMAND
      select case LOWORD(wParam)
        case IDC_BTNCLOSE
          DeactivatePlugin()
          return TRUE
        case IDC_BTNADVANCED
          SwitchMode(TRUE)
          return TRUE
        case IDC_BTNPREV
          DoSearch(FALSE)
          SetFocus(hEditSearch)
          return TRUE
        case IDC_BTNNEXT
          DoSearch(TRUE)
          SetFocus(hEditSearch)
          return TRUE
        case IDC_BTNCLEARSEARCH
          GetWindowTextW(hEditSearch, @wsGlobalSearch, 1024)
          RemoveFromHistory(wsGlobalSearch, TRUE, hEditSearch, hSideEditSearch)
          wsGlobalSearch = ""
          SetWindowTextW(hEditSearch, @wsGlobalSearch)
          SetFocus(hEditSearch)
          return TRUE
      end select
    case WM_DESTROY
      SendMessage(hMainWndGlobal, AKD_SETMODELESS, cast(WPARAM, hDlg), MLA_DELETE)
      hBtnClose = NULL : hEditSearch = NULL : hBtnClearSearch = NULL : hBtnPrev = NULL : hBtnNext = NULL
      hChkMatchCase = NULL : hChkWholeWord = NULL : hChkAllFiles = NULL : hBtnAdvanced = NULL : hLblFind = NULL
      return TRUE
  end select
  return FALSE
end function

function SidePanelDlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as INT_PTR
  select case uMsg
    case WM_INITDIALOG
      CreateSidePanelControls(hDlg)
      SendMessage(hMainWndGlobal, AKD_SETMODELESS, cast(WPARAM, hDlg), MLA_ADD)
      return FALSE
    case WM_SIZE
      if hSideBtnClose <> NULL then LayoutSidePanelControls(hDlg, LOWORD(lParam), HIWORD(lParam))
      return TRUE
    case WM_SETCURSOR
      if bDragging then
        SetCursor(LoadCursor(NULL, IDC_SIZEWE))
        return TRUE
      end if
      if LOWORD(lParam) = HTCLIENT then
        dim pt as POINT
        GetCursorPos(@pt)
        ScreenToClient(hDlg, @pt)
        if pt.x < 5 then
          SetCursor(LoadCursor(NULL, IDC_SIZEWE))
          return TRUE
        end if
      end if
      return FALSE
    case WM_LBUTTONDOWN
      dim pt as POINT
      GetCursorPos(@pt)
      ScreenToClient(hDlg, @pt)
      if pt.x < 5 then
        bDragging = TRUE
        SetCapture(hDlg)
        GetCursorPos(@ptDragStart)
        nDragStartWidth = nAdvancedPanelWidth
        return TRUE
      end if
    case WM_MOUSEMOVE
      if bDragging then
        dim pt as POINT
        GetCursorPos(@pt)
        dim newW as integer = nDragStartWidth + (ptDragStart.x - pt.x)
        dim rcMain as RECT
        GetClientRect(hMainWndGlobal, @rcMain)
        dim maxW as integer = (rcMain.right - rcMain.left) \ 2
        if newW > maxW then newW = maxW
        if newW < 250 then newW = 250
        if newW <> nAdvancedPanelWidth then
          nAdvancedPanelWidth = newW
          SendMessage(hMainWndGlobal, AKD_RESIZE, 0, 0)
        end if
      end if
      return TRUE
    case WM_LBUTTONUP
      if bDragging then
        bDragging = FALSE
        ReleaseCapture()
        return TRUE
      end if
    case WM_CAPTURECHANGED
      bDragging = FALSE
      return TRUE
    case WM_SETFOCUS
      if hSideEditSearch <> NULL then SetFocus(hSideEditSearch)
      return TRUE
    case WM_NOTIFY
      dim pnm as LPNMHDR = cast(LPNMHDR, lParam)
      if pnm->idFrom = IDC_SIDELISTRESULTS then
        if pnm->code = NM_DBLCLK then
          dim pnmia as LPNMITEMACTIVATE = cast(LPNMITEMACTIVATE, lParam)
          if pnmia->iItem >= 0 then
            dim lvi as LVITEMW
            dim wsDir as WString * 1024
            dim wsFile as WString * 1024
            dim wsLine as WString * 32
            lvi.iSubItem = 0
            lvi.pszText = @wsDir
            lvi.cchTextMax = 1024
            SendMessageW(hSideListResults, LVM_GETITEMTEXTW, pnmia->iItem, cast(LPARAM, @lvi))
            lvi.iSubItem = 1
            lvi.pszText = @wsFile
            lvi.cchTextMax = 1024
            SendMessageW(hSideListResults, LVM_GETITEMTEXTW, pnmia->iItem, cast(LPARAM, @lvi))
            lvi.iSubItem = 2
            lvi.pszText = @wsLine
            lvi.cchTextMax = 32
            SendMessageW(hSideListResults, LVM_GETITEMTEXTW, pnmia->iItem, cast(LPARAM, @lvi))
            dim nLineNum as integer = Val(wsLine)
            OpenSearchResult(wsDir, wsFile, nLineNum, wsGlobalSearch)
          end if
        end if
      end if
      return TRUE
    case WM_COMMAND
      select case LOWORD(wParam)
        case IDC_SIDEBTNCLOSE
          DeactivatePlugin()
          return TRUE
        case IDC_BTNBASIC
          SwitchMode(FALSE)
          return TRUE
        case IDC_SIDEBTNBROWSE
          SelectFolder(hDlg)
          return TRUE
        case IDC_SIDEBTNFINDNEXT
          DoSearch(TRUE)
          SetFocus(hSideEditSearch)
          return TRUE
        case IDC_SIDEBTNREPLACE
          DoReplace(FALSE)
          SetFocus(hSideEditSearch)
          return TRUE
        case IDC_SIDEBTNREPLACEALL
          DoReplace(TRUE)
          SetFocus(hSideEditSearch)
          return TRUE
        case IDC_SIDEBTNCLEARSEARCH
          GetWindowTextW(hSideEditSearch, @wsGlobalSearch, 1024)
          RemoveFromHistory(wsGlobalSearch, TRUE, hEditSearch, hSideEditSearch)
          wsGlobalSearch = ""
          SetWindowTextW(hSideEditSearch, @wsGlobalSearch)
          SetFocus(hSideEditSearch)
          return TRUE
        case IDC_SIDEBTNCLEARREPLACE
          GetWindowTextW(hSideEditReplace, @wsGlobalReplace, 1024)
          RemoveFromHistory(wsGlobalReplace, FALSE, NULL, hSideEditReplace)
          wsGlobalReplace = ""
          SetWindowTextW(hSideEditReplace, @wsGlobalReplace)
          SetFocus(hSideEditReplace)
          return TRUE
        case IDC_SIDECHKINFOLDER
          dim bChecked as WINBOOL = SendMessage(hSideChkInFolder, BM_GETCHECK, 0, 0)
          EnableWindow(hSidePath, bChecked)
          EnableWindow(hSideBtnBrowse, bChecked)
          return TRUE
      end select
    case WM_DESTROY
      SendMessage(hMainWndGlobal, AKD_SETMODELESS, cast(WPARAM, hDlg), MLA_DELETE)
      hSideBtnClose = NULL : hSideBtnBasic = NULL : hSideLblFind = NULL
      hSideEditSearch = NULL : hSideBtnClearSearch = NULL
      hSideLblReplace = NULL : hSideEditReplace = NULL : hSideBtnClearReplace = NULL
      hSidePath = NULL : hSideBtnBrowse = NULL : hSideChkMatchCase = NULL
      hSideChkWholeWord = NULL : hSideChkAllFiles = NULL : hSideChkInFolder = NULL
      hSideLblFilter = NULL : hSideEditFilter = NULL : hSideListResults = NULL
      hSideBtnFindNext = NULL : hSideBtnReplace = NULL : hSideBtnReplaceAll = NULL : hSideStatus = NULL
      return TRUE
  end select
  return FALSE
end function