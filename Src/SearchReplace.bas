#include once "Inc\Globals.bi"

' -- Helpers to Populate ListView -------------------------------------------
sub AddListViewItem(byval hList as HWND, byref dirPath as WString, byref fileName as WString, byval lineNum as integer, byref lineText as WString)
  dim lvi as LVITEMW
  dim row as integer = SendMessage(hList, LVM_GETITEMCOUNT, 0, 0)
  
  lvi.mask = LVIF_TEXT
  lvi.iItem = row
  lvi.iSubItem = 0
  lvi.pszText = cast(WString ptr, @dirPath)
  SendMessageW(hList, LVM_INSERTITEMW, 0, cast(LPARAM, @lvi))
  
  lvi.iSubItem = 1
  lvi.pszText = cast(WString ptr, @fileName)
  SendMessageW(hList, LVM_SETITEMTEXTW, row, cast(LPARAM, @lvi))
  
  dim wsLine as WString * 32 = wstr(lineNum)
  lvi.iSubItem = 2
  lvi.pszText = cast(WString ptr, @wsLine)
  SendMessageW(hList, LVM_SETITEMTEXTW, row, cast(LPARAM, @lvi))
  
  lvi.iSubItem = 3
  lvi.pszText = cast(WString ptr, @lineText)
  SendMessageW(hList, LVM_SETITEMTEXTW, row, cast(LPARAM, @lvi))
end sub

' -- File Processing Logic --------------------------------------------------
sub ProcessFile(byref dirPath as WString, byref fileName as WString, byref nMatches as integer, byref nFiles as integer)
  nFiles += 1
  dim wsFullPath as WString * 1024 = dirPath & "\" & fileName
  
  dim hFile as HANDLE = CreateFileW(@wsFullPath, GENERIC_READ, FILE_SHARE_READ, NULL, OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL)
  if hFile <> INVALID_HANDLE_VALUE then
    dim fileSize as DWORD = GetFileSize(hFile, NULL)
    if fileSize > 0 then
      ' Leer contenido como bytes
      dim buffer as UBYTE ptr = callocate(fileSize + 1)
      dim bytesRead as DWORD
      ReadFile(hFile, buffer, fileSize, @bytesRead, NULL)
      
      ' Convertir simple a UTF-16 asumiendo base UTF-8/ANSI
      dim wLen as integer = MultiByteToWideChar(CP_UTF8, 0, cast(LPCCH, buffer), bytesRead, NULL, 0)
      dim wBuffer as WString ptr = callocate((wLen + 1) * 2)
      MultiByteToWideChar(CP_UTF8, 0, cast(LPCCH, buffer), bytesRead, wBuffer, wLen)
      
      dim as integer lineNum = 1
      dim as WString ptr pStart = wBuffer
      dim as WString ptr pEnd = wBuffer
      
      while *pEnd <> 0
        if *pEnd = 13 orelse *pEnd = 10 then
          dim oldChar as USHORT = *pEnd
          *pEnd = 0
          
          dim bMatch as WINBOOL = FALSE
          if bGlobalMatchCase then
            if InStr(*pStart, wsGlobalSearch) > 0 then bMatch = TRUE
          else
            if InStr(LCase(*pStart), LCase(wsGlobalSearch)) > 0 then bMatch = TRUE
          end if
          
          if bMatch then
            AddListViewItem(hSideListResults, dirPath, fileName, lineNum, *pStart)
            nMatches += 1
          end if
          
          *pEnd = oldChar
          
          ' Saltear CRLF si lo hay
          if *pEnd = 13 andalso *(pEnd + 1) = 10 then
            pEnd += 1
          end if
          lineNum += 1
          pStart = pEnd + 1
        end if
        pEnd += 1
      wend
      
      ' Verificar ultima linea (sin salto al final)
      if pStart < pEnd then
        dim bMatch as WINBOOL = FALSE
        if bGlobalMatchCase then
          if InStr(*pStart, wsGlobalSearch) > 0 then bMatch = TRUE
        else
          if InStr(LCase(*pStart), LCase(wsGlobalSearch)) > 0 then bMatch = TRUE
        end if
        if bMatch then
          AddListViewItem(hSideListResults, dirPath, fileName, lineNum, *pStart)
          nMatches += 1
        end if
      end if
      
      deallocate(wBuffer)
      deallocate(buffer)
    end if
    CloseHandle(hFile)
  end if
end sub

' -- Directory Processing Logic (Recursive) ---------------------------------
sub ProcessDirectory(byref dirPath as WString, byref nMatches as integer, byref nFiles as integer)
  dim fd as WIN32_FIND_DATAW
  dim wsSearchPattern as WString * 1024 = dirPath & "\*"
  dim hFind as HANDLE = FindFirstFileW(@wsSearchPattern, @fd)
  
  if hFind <> INVALID_HANDLE_VALUE then
    do
      if (fd.dwFileAttributes and FILE_ATTRIBUTE_DIRECTORY) then
        ' Ignorar los directorios "." y ".." para evitar bucles infinitos
        if fd.cFileName <> "." andalso fd.cFileName <> ".." then
          dim nextDir as WString * 1024 = dirPath & "\" & fd.cFileName
          ProcessDirectory(nextDir, nMatches, nFiles)
        end if
      else
        dim bMatch as WINBOOL = FALSE
        if len(wsGlobalFilter) = 0 then
          bMatch = TRUE
        else
          bMatch = PathMatchSpecW(fd.cFileName, @wsGlobalFilter)
        end if
        
        if bMatch then
          ProcessFile(dirPath, fd.cFileName, nMatches, nFiles)
        end if
      end if
    loop while FindNextFileW(hFind, @fd) <> 0
    FindClose(hFind)
  end if
end sub

' -- Find In Folder Custom Logic --------------------------------------------
sub DoFindInFolder()
  if len(wsGlobalPath) = 0 then
    dim msg as WString * 64 = "Search path is empty."
    LogResult(msg)
    exit sub
  end if
  
  SendMessageW(hSideListResults, LVM_DELETEALLITEMS, 0, 0)
  
  dim nMatches as integer = 0
  dim nFiles as integer = 0
  
  dim msgStart as WString * 64 = "Searching in files..."
  LogResult(msgStart)
  
  ' Iniciar el escaneo recursivo
  ProcessDirectory(wsGlobalPath, nMatches, nFiles)
  
  dim wsMsg as WString * 128 = "Found " & nMatches & " match(es) in " & nFiles & " file(s)."
  LogResult(wsMsg)
end sub

' -- Standard Search Logic --------------------------------------------------
sub DoSearch(byval bDown as WINBOOL)
  SaveControlState()
  if len(wsGlobalSearch) = 0 then exit sub
  
  ' Add to history and preserve text in edit controls
  AddToHistory(wsGlobalSearch, TRUE, hEditSearch, hSideEditSearch)
  if hEditSearch <> NULL then SetWindowTextW(hEditSearch, @wsGlobalSearch)
  if hSideEditSearch <> NULL then SetWindowTextW(hSideEditSearch, @wsGlobalSearch)
  
  ' Check if custom In-Folder search applies
  if bAdvancedMode andalso bGlobalInFolder then
    DoFindInFolder()
    exit sub
  end if
  
  ' Standard AkelPad Search
  dim tf as TEXTFINDW
  tf.dwFlags = iif(bDown, FRF_DOWN, FRF_UP)
  if bGlobalMatchCase then tf.dwFlags or= FRF_MATCHCASE
  if bGlobalWholeWord then tf.dwFlags or= FRF_WHOLEWORD
  
  tf.pFindIt = @wsGlobalSearch
  tf.nFindItLen = -1
  
  if bGlobalAllFiles then
    dim res as integer = SendMessage(hMainWndGlobal, AKD_TEXTFINDW, 0, cast(LPARAM, @tf))
    if res = -1 then
      dim lpFrameInit as any ptr = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_CURRENT, 0))
      dim lpFrame as any ptr = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_NEXT, cast(LPARAM, lpFrameInit)))
      
      while (lpFrame <> lpFrameInit) andalso (lpFrame <> 0)
        SendMessage(hMainWndGlobal, AKD_FRAMEACTIVATE, 0, cast(LPARAM, lpFrame))
        tf.dwFlags or= FRF_BEGINNING
        res = SendMessage(hMainWndGlobal, AKD_TEXTFINDW, 0, cast(LPARAM, @tf))
        
        if res <> -1 then
          dim wsMsg as WString * 128 = "Found match."
          LogResult(wsMsg)
          exit while
        end if
        
        lpFrame = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_NEXT, cast(LPARAM, lpFrame)))
      wend
      
      if res = -1 then
        dim wsMsg as WString * 128 = "No matches found."
        LogResult(wsMsg)
      end if
    else
      dim wsMsg as WString * 128 = "Found match."
      LogResult(wsMsg)
    end if
  else
    tf.dwFlags or= FRF_CYCLESEARCH
    dim res as integer = SendMessage(hMainWndGlobal, AKD_TEXTFINDW, 0, cast(LPARAM, @tf))
    if res <> -1 then
      dim wsMsg as WString * 128 = "Found match."
      LogResult(wsMsg)
    else
      dim wsMsg as WString * 128 = "No matches found."
      LogResult(wsMsg)
    end if
  end if
end sub

sub DoReplace(byval bReplaceAll as WINBOOL)
  SaveControlState()
  if len(wsGlobalSearch) = 0 then exit sub
  
  ' Reemplazo funciona de la forma habitual (Interna de AkelPad)
  AddToHistory(wsGlobalSearch, TRUE, hEditSearch, hSideEditSearch)
  AddToHistory(wsGlobalReplace, FALSE, NULL, hSideEditReplace)
  if hEditSearch <> NULL then SetWindowTextW(hEditSearch, @wsGlobalSearch)
  if hSideEditSearch <> NULL then SetWindowTextW(hSideEditSearch, @wsGlobalSearch)
  if hSideEditReplace <> NULL then SetWindowTextW(hSideEditReplace, @wsGlobalReplace)
  
  dim tr as TEXTREPLACEW
  dim nTotalChanges as integer = 0
  dim bIterateAll as WINBOOL = bGlobalAllFiles
  
  if bReplaceAll andalso bIterateAll then
    dim lpFrameInit as any ptr = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_CURRENT, 0))
    dim lpFrame as any ptr = lpFrameInit
    do
      SendMessage(hMainWndGlobal, AKD_FRAMEACTIVATE, 0, cast(LPARAM, lpFrame))
      
      tr.dwFindFlags = FRF_DOWN or FRF_BEGINNING
      if bGlobalMatchCase then tr.dwFindFlags or= FRF_MATCHCASE
      if bGlobalWholeWord then tr.dwFindFlags or= FRF_WHOLEWORD
      tr.dwReplaceFlags = RRF_ALL
      tr.pFindIt = @wsGlobalSearch : tr.nFindItLen = -1
      tr.pReplaceWith = @wsGlobalReplace : tr.nReplaceWithLen = -1
      
      SendMessage(hMainWndGlobal, AKD_TEXTREPLACEW, 0, cast(LPARAM, @tr))
      if tr.nChanges > 0 then nTotalChanges += tr.nChanges
      
      lpFrame = cast(any ptr, SendMessage(hMainWndGlobal, AKD_FRAMEFIND, FWF_NEXT, cast(LPARAM, lpFrame)))
    loop while (lpFrame <> lpFrameInit) andalso (lpFrame <> 0)
  else
    if bReplaceAll then
      tr.dwFindFlags = FRF_DOWN or FRF_BEGINNING
      tr.dwReplaceFlags = RRF_ALL
    else
      tr.dwFindFlags = FRF_DOWN or FRF_CYCLESEARCH
      tr.dwReplaceFlags = 0
    end if
    
    if bGlobalMatchCase then tr.dwFindFlags or= FRF_MATCHCASE
    if bGlobalWholeWord then tr.dwFindFlags or= FRF_WHOLEWORD
    
    tr.pFindIt = @wsGlobalSearch : tr.nFindItLen = -1
    tr.pReplaceWith = @wsGlobalReplace : tr.nReplaceWithLen = -1
    
    SendMessage(hMainWndGlobal, AKD_TEXTREPLACEW, 0, cast(LPARAM, @tr))
    nTotalChanges = tr.nChanges
  end if
  
  if bReplaceAll then
    dim wsMsg as WString * 128 = "Replaced " & nTotalChanges & " occurrence(s)."
    LogResult(wsMsg)
  else
    if nTotalChanges <> -1 then
      dim wsMsg as WString * 128 = "Replaced 1 occurrence."
      LogResult(wsMsg)
    end if
  end if
end sub