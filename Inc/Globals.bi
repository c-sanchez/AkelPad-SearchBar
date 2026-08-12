#ifndef __GLOBALS_BI__
#define __GLOBALS_BI__
#include once "windows.bi"
#include once "win/commctrl.bi"
#include once "win/shlobj.bi"
#include once "win/shlwapi.bi"
#include once "win/objbase.bi"
#include once "Inc\AkelDLL.bi"
#ifndef LVM_INSERTITEMW
#define LVM_INSERTITEMW (LVM_FIRST + 77)
#endif
#ifndef LVM_SETITEMTEXTW
#define LVM_SETITEMTEXTW (LVM_FIRST + 116)
#endif
#ifndef LVM_GETITEMTEXTW
#define LVM_GETITEMTEXTW (LVM_FIRST + 115)
#endif
#ifndef GHND
#define GHND &h0042
#endif
#ifndef SIGDN_FILESYSPATH
#define SIGDN_FILESYSPATH &H80058000
#endif
#ifndef FOS_PICKFOLDERS
#define FOS_PICKFOLDERS &H20
#endif
#ifndef FOS_FORCEFILESYSTEM
#define FOS_FORCEFILESYSTEM &H40
#endif
type MyIShellItemVtbl
  QueryInterface as function stdcall(byval as any ptr, byval as const IID ptr, byval as any ptr ptr) as HRESULT
  AddRef as function stdcall(byval as any ptr) as ULONG
  Release as function stdcall(byval as any ptr) as ULONG
  BindToHandler as function stdcall(byval as any ptr, byval as any ptr, byval as const GUID ptr, byval as const IID ptr, byval as any ptr ptr) as HRESULT
  GetParent as function stdcall(byval as any ptr, byval as any ptr ptr) as HRESULT
  GetDisplayName as function stdcall(byval as any ptr, byval as DWORD, byval as WString ptr ptr) as HRESULT
  GetAttributes as function stdcall(byval as any ptr, byval as DWORD, byval as DWORD ptr) as HRESULT
  Compare as function stdcall(byval as any ptr, byval as any ptr, byval as DWORD, byval as integer ptr) as HRESULT
end type
type MyIShellItem
  lpVtbl as MyIShellItemVtbl ptr
end type
type MyIFileOpenDialogVtbl
  QueryInterface as function stdcall(byval as any ptr, byval as const IID ptr, byval as any ptr ptr) as HRESULT
  AddRef as function stdcall(byval as any ptr) as ULONG
  Release as function stdcall(byval as any ptr) as ULONG
  Show as function stdcall(byval as any ptr, byval as HWND) as HRESULT
  SetFileTypes as function stdcall(byval as any ptr, byval as UINT, byval as any ptr) as HRESULT
  SetFileTypeIndex as function stdcall(byval as any ptr, byval as UINT) as HRESULT
  GetFileTypeIndex as function stdcall(byval as any ptr, byval as UINT ptr) as HRESULT
  Advise as function stdcall(byval as any ptr, byval as any ptr, byval as DWORD ptr) as HRESULT
  Unadvise as function stdcall(byval as any ptr, byval as DWORD) as HRESULT
  SetOptions as function stdcall(byval as any ptr, byval as DWORD) as HRESULT
  GetOptions as function stdcall(byval as any ptr, byval as DWORD ptr) as HRESULT
  SetDefaultFolder as function stdcall(byval as any ptr, byval as MyIShellItem ptr) as HRESULT
  SetFolder as function stdcall(byval as any ptr, byval as MyIShellItem ptr) as HRESULT
  GetFolder as function stdcall(byval as any ptr, byval as MyIShellItem ptr ptr) as HRESULT
  GetCurrentSelection as function stdcall(byval as any ptr, byval as MyIShellItem ptr ptr) as HRESULT
  SetFileName as function stdcall(byval as any ptr, byval as LPCWSTR) as HRESULT
  GetFileName as function stdcall(byval as any ptr, byval as WString ptr ptr) as HRESULT
  SetTitle as function stdcall(byval as any ptr, byval as LPCWSTR) as HRESULT
  SetOkButtonLabel as function stdcall(byval as any ptr, byval as LPCWSTR) as HRESULT
  SetFileNameLabel as function stdcall(byval as any ptr, byval as LPCWSTR) as HRESULT
  GetResult as function stdcall(byval as any ptr, byval as MyIShellItem ptr ptr) as HRESULT
  AddPlace as function stdcall(byval as any ptr, byval as MyIShellItem ptr, byval as DWORD) as HRESULT
  SetDefaultExtension as function stdcall(byval as any ptr, byval as LPCWSTR) as HRESULT
  Close as function stdcall(byval as any ptr, byval as HRESULT) as HRESULT
  SetClientGuid as function stdcall(byval as any ptr, byval as const GUID ptr) as HRESULT
  ClearClientData as function stdcall(byval as any ptr) as HRESULT
  SetFilter as function stdcall(byval as any ptr, byval as any ptr) as HRESULT
  GetResults as function stdcall(byval as any ptr, byval as any ptr ptr) as HRESULT
  GetSelectedItems as function stdcall(byval as any ptr, byval as any ptr ptr) as HRESULT
end type
type MyIFileOpenDialog
  lpVtbl as MyIFileOpenDialogVtbl ptr
end type
type MYDROPFILES
  pFiles as DWORD
  pt as POINT
  fNC as WINBOOL
  fWide as WINBOOL
end type
#define IDD_TOPPANEL         1001
#define IDD_SIDEPANEL        1002
#define IDC_BTNCLOSE         1003
#define IDC_EDITSEARCH       1004
#define IDC_BTNPREV          1005
#define IDC_BTNNEXT          1006
#define IDC_CHKMATCHCASE     1007
#define IDC_CHKWHOLEWORD     1008
#define IDC_BTNADVANCED      1009
#define IDC_LBLFIND          1022
#define IDC_CHKALLFILES      1026
#define IDC_BTNCLEARSEARCH   1027
#define IDC_SIDEBTNCLOSE     1010
#define IDC_SIDEEDITSEARCH   1011
#define IDC_BTNBASIC         1012
#define IDC_SIDESTATUS       1013
#define IDC_SIDELBLFIND      1014
#define IDC_SIDELBLREPLACE   1015
#define IDC_SIDEEDITREPLACE  1016
#define IDC_SIDEPATH         1017
#define IDC_SIDEBTNBROWSE    1018
#define IDC_SIDECHKMATCHCASE 1019
#define IDC_SIDECHKWHOLEWORD 1020
#define IDC_SIDEBTNFINDNEXT  1021
#define IDC_SIDEBTNREPLACE   1023
#define IDC_SIDEBTNREPLACEALL 1024
#define IDC_SIDECHKALLFILES  1025
#define IDC_SIDEBTNCLEARSEARCH  1028
#define IDC_SIDEBTNCLEARREPLACE 1029
#define IDC_SIDECHKINFOLDER  1030
#define IDC_SIDELBLFILTER    1031
#define IDC_SIDEEDITFILTER   1032
#define IDC_SIDELISTRESULTS  1033
const PANEL_HEIGHT = 28
#define MAX_HISTORY 10
#define AKD_TEXTFINDW        (WM_USER + 174)
#define AKD_TEXTREPLACEW     (WM_USER + 177)
#define AKD_FRAMEACTIVATE    (WM_USER + 261)
#define AKD_FRAMEFIND        (WM_USER + 264)
#define FWF_CURRENT          1
#define FWF_NEXT             2
#define FWF_PREV             3
#define FRF_DOWN             &h00000001
#define FRF_WHOLEWORD        &h00000002
#define FRF_MATCHCASE        &h00000004
#define FRF_UP               &h00100000
#define FRF_BEGINNING        &h00200000
#define FRF_CYCLESEARCH      &h08000000
#define RRF_ALL              &h00000001
#define AKD_GOTOW             1206
#define GT_LINE               &h1
#define EM_FINDTEXTEX64W      (WM_USER + 1956)
#ifndef FR_DOWN
#define FR_DOWN &h00000001
#endif
#ifndef FR_MATCHCASE
#define FR_MATCHCASE &h00000004
#endif
#ifndef EM_LINEINDEX
#define EM_LINEINDEX &h00BB
#endif
#ifndef EM_SETSEL
#define EM_SETSEL &h00B1
#endif
#ifndef EM_SCROLLCARET
#define EM_SCROLLCARET &h00B7
#endif
type TEXTFINDW
  dwFlags as DWORD
  pFindIt as WString ptr
  nFindItLen as integer
end type
type TEXTREPLACEW
  dwFindFlags as DWORD
  pFindIt as WString ptr
  nFindItLen as integer
  pReplaceWith as WString ptr
  nReplaceWithLen as integer
  dwReplaceFlags as DWORD
  nChanges as INT_PTR
end type
type CHARRANGE64
  cpMin as INT_PTR
  cpMax as INT_PTR
end type
type FINDTEXTEX64W
  chrg as CHARRANGE64
  lpstrText as WString ptr
  chrgText as CHARRANGE64
end type
type FRAMEDATAMIN
  nextItem as any ptr
  prevItem as any ptr
  cb as DWORD
  nFrameID as INT_PTR
  hWndEditParent as HWND
  hWndEdit as HWND
end type
extern hMainWndGlobal as HWND
extern hInstanceGlobal as HINSTANCE
extern hInstanceEXEGlobal as HINSTANCE
extern hPanelDlg as HWND
extern lpMainProcData as WNDPROCDATA ptr
extern lpInputOldProc as WNDPROC
extern bPanelVisible as WINBOOL
extern hKbdHook as HHOOK
extern bAdvancedMode as WINBOOL
extern wsGlobalSearch as WString * 1024
extern wsGlobalReplace as WString * 1024
extern wsGlobalPath as WString * 1024
extern wsGlobalFilter as WString * 1024
extern bGlobalMatchCase as WINBOOL
extern bGlobalWholeWord as WINBOOL
extern bGlobalAllFiles as WINBOOL
extern bGlobalInFolder as WINBOOL
extern wsSearchHistory(0 to MAX_HISTORY - 1) as WString * 1024
extern nSearchHistoryCount as integer
extern wsReplaceHistory(0 to MAX_HISTORY - 1) as WString * 1024
extern nReplaceHistoryCount as integer
extern nAdvancedPanelWidth as integer
extern bDragging as WINBOOL
extern ptDragStart as POINT
extern nDragStartWidth as integer
extern hBtnClose as HWND
extern hLblFind as HWND
extern hEditSearch as HWND
extern hBtnClearSearch as HWND
extern hBtnPrev as HWND
extern hBtnNext as HWND
extern hChkMatchCase as HWND
extern hChkWholeWord as HWND
extern hChkAllFiles as HWND
extern hBtnAdvanced as HWND
extern hSideBtnClose as HWND
extern hSideBtnBasic as HWND
extern hSideLblFind as HWND
extern hSideEditSearch as HWND
extern hSideBtnClearSearch as HWND
extern hSideLblReplace as HWND
extern hSideEditReplace as HWND
extern hSideBtnClearReplace as HWND
extern hSidePath as HWND
extern hSideBtnBrowse as HWND
extern hSideChkMatchCase as HWND
extern hSideChkWholeWord as HWND
extern hSideChkAllFiles as HWND
extern hSideChkInFolder as HWND
extern hSideLblFilter as HWND
extern hSideEditFilter as HWND
extern hSideListResults as HWND
extern hSideBtnFindNext as HWND
extern hSideBtnReplace as HWND
extern hSideBtnReplaceAll as HWND
extern hSideStatus as HWND
extern wsIniPath as WString * 1024
declare sub CreateTopPanelControls(byval hDlg as HWND)
declare sub LayoutTopPanelControls(byval hDlg as HWND, byval w as integer, byval h as integer)
declare sub CreateSidePanelControls(byval hDlg as HWND)
declare sub LayoutSidePanelControls(byval hDlg as HWND, byval w as integer, byval h as integer)
declare function TopPanelDlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as INT_PTR
declare function SidePanelDlgProc(byval hDlg as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as INT_PTR
declare function EditSubclassProc(byval hWnd as HWND, byval uMsg as UINT, byval wParam as WPARAM, byval lParam as LPARAM) as LRESULT
declare sub SaveControlState()
declare sub LoadSettings()
declare sub SaveSettings()
declare sub SwitchMode(byval bAdvanced as WINBOOL)
declare sub SelectFolder(byval hOwner as HWND)
declare sub DeactivatePlugin()
declare sub OpenSearchResult(byref dirPath as WString, byref fileName as WString, byval lineNum as integer, byref searchText as WString)
declare sub LogResult(byref wsMsg as WString)
declare sub DoSearch(byval bDown as WINBOOL)
declare sub DoReplace(byval bReplaceAll as WINBOOL)
declare sub DoFindInFolder()
declare sub AddListViewItem(byval hList as HWND, byref dirPath as WString, byref fileName as WString, byval lineNum as integer, byref lineText as WString)
declare sub AddToHistory(byref wsText as WString, byval bIsSearch as WINBOOL, byval hComboTop as HWND, byval hComboSide as HWND)
declare sub RemoveFromHistory(byref wsText as WString, byval bIsSearch as WINBOOL, byval hComboTop as HWND, byval hComboSide as HWND)
declare sub PopulateCombo(byval hCombo as HWND, byval bIsSearch as WINBOOL)
#define AKD_SETMODELESS (WM_USER + 100)
#define MLA_ADD         1
#define MLA_DELETE      2
#endif