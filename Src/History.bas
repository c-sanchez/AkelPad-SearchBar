#include once "Inc\Globals.bi"

sub PopulateCombo(byval hCombo as HWND, byval bIsSearch as WINBOOL)
  if hCombo = NULL then exit sub
  SendMessageW(hCombo, CB_RESETCONTENT, 0, 0)
  if bIsSearch then
    for i as integer = 0 to nSearchHistoryCount - 1
      SendMessageW(hCombo, CB_ADDSTRING, 0, cast(LPARAM, @wsSearchHistory(i)))
    next
  else
    for i as integer = 0 to nReplaceHistoryCount - 1
      SendMessageW(hCombo, CB_ADDSTRING, 0, cast(LPARAM, @wsReplaceHistory(i)))
    next
  end if
end sub

sub AddToHistory(byref wsText as WString, byval bIsSearch as WINBOOL, byval hComboTop as HWND, byval hComboSide as HWND)
  if len(wsText) = 0 then exit sub
  
  dim foundIdx as integer = -1
  dim nCount as integer = iif(bIsSearch, nSearchHistoryCount, nReplaceHistoryCount)
  
  if bIsSearch then
    for i as integer = 0 to nCount - 1
      if wsSearchHistory(i) = wsText then
        foundIdx = i
        exit for
      end if
    next
  else
    for i as integer = 0 to nCount - 1
      if wsReplaceHistory(i) = wsText then
        foundIdx = i
        exit for
      end if
    next
  end if
  
  if foundIdx = 0 then exit sub
  
  dim startIdx as integer = iif(foundIdx > 0, foundIdx, iif(nCount < MAX_HISTORY, nCount, MAX_HISTORY - 1))
  
  if bIsSearch then
    for i as integer = startIdx to 1 step -1
      wsSearchHistory(i) = wsSearchHistory(i - 1)
    next
    wsSearchHistory(0) = wsText
    if foundIdx = -1 andalso nSearchHistoryCount < MAX_HISTORY then nSearchHistoryCount += 1
  else
    for i as integer = startIdx to 1 step -1
      wsReplaceHistory(i) = wsReplaceHistory(i - 1)
    next
    wsReplaceHistory(0) = wsText
    if foundIdx = -1 andalso nReplaceHistoryCount < MAX_HISTORY then nReplaceHistoryCount += 1
  end if
  
  PopulateCombo(hComboTop, bIsSearch)
  PopulateCombo(hComboSide, bIsSearch)
end sub

sub RemoveFromHistory(byref wsText as WString, byval bIsSearch as WINBOOL, byval hComboTop as HWND, byval hComboSide as HWND)
  if len(wsText) = 0 then exit sub
  
  dim nCount as integer = iif(bIsSearch, nSearchHistoryCount, nReplaceHistoryCount)
  dim foundIdx as integer = -1
  
  if bIsSearch then
    for i as integer = 0 to nCount - 1
      if wsSearchHistory(i) = wsText then
        foundIdx = i
        exit for
      end if
    next
    if foundIdx <> -1 then
      for i as integer = foundIdx to nCount - 2
        wsSearchHistory(i) = wsSearchHistory(i + 1)
      next
      nSearchHistoryCount -= 1
    end if
  else
    for i as integer = 0 to nCount - 1
      if wsReplaceHistory(i) = wsText then
        foundIdx = i
        exit for
      end if
    next
    if foundIdx <> -1 then
      for i as integer = foundIdx to nCount - 2
        wsReplaceHistory(i) = wsReplaceHistory(i + 1)
      next
      nReplaceHistoryCount -= 1
    end if
  end if
  
  if foundIdx <> -1 then
    PopulateCombo(hComboTop, bIsSearch)
    PopulateCombo(hComboSide, bIsSearch)
  end if
end sub