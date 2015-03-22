Func CheckArmyCamp()
	SetLog("Checking Army Camp...", $COLOR_BLUE)

	If _Sleep(100) Then Return

	ClickP($TopLeftClient) ;Click Away

	If $ArmyPos[0] = "" Then
		LocateCamp()
		SaveConfig()
	Else
		If _Sleep(100) Then Return
		Click($ArmyPos[0], $ArmyPos[1]) ;Click Army Camp
	EndIf

	_CaptureRegion()
	If _Sleep(500) Then Return
	Local $BArmyPos = _PixelSearch(309, 581, 433, 583, Hex(0x4084B8, 6), 5) ;Finds Info button
	If IsArray($BArmyPos) = False Then
		SetLog("Your Army Camp is not available", $COLOR_RED)
	Else
		Click($BArmyPos[0], $BArmyPos[1]) ;Click Info button
		If _Sleep(2000) Then Return

		_CaptureRegion()
		Switch $icmbRaidcap
			Case 0 ; 70%
				Local $Campbar = _PixelSearch(620, 210, 622, 213, Hex(0x37A800,6), 5)
			Case 1 ; 80%
				Local $Campbar = _PixelSearch(649, 210, 651, 213, Hex(0x37A800,6), 5)
			Case 2 ; 90%
				Local $Campbar = _PixelSearch(677, 210, 679, 213, Hex(0x37A800,6), 5)
			Case 3 ; 100%
				Local $Campbar = _PixelSearch(707, 210, 709, 213, Hex(0x37A800,6), 5)
		EndSwitch
		$CurCamp = Number(getOther(586, 193, "Camp"))
		If $Curcamp > 0 Then
			SetLog("Total Troop Capacity: " & $CurCamp & "/" & $itxtcampCap, $COLOR_GREEN)
		EndIf
		If $CurCamp >= ($itxtcampCap * (GUICtrlRead($cmbRaidcap) / 100)) or IsArray($Campbar) = True Then
			$fullArmy = True
		Else
			_CaptureRegion()
			If $FirstStart Then
				$ArmyComp = 0
				$CurGiant = 0
				$CurWB = 0
				$CurArch = 0
				$CurBarb = 0
				$CurGoblin = 0
			Endif
			For $i = 0 To 6
				Local $TroopKind = _GetPixelColor(230 + 71 * $i, 359)
				Local $TroopName = 0
				Local $TroopQ = getOther(229 + 71 * $i, 413, "Camp")
				If _ColorCheck($TroopKind, Hex(0xF85CCB, 6), 20) Then
					If ($CurArch=0 and $FirstStart) then $CurArch -= $TroopQ
					$TroopName = "Archers"
				ElseIf _ColorCheck($TroopKind, Hex(0xF8E439, 6), 20) Then
					if ($CurBarb=0 and $FirstStart) then $CurBarb -= $TroopQ
					$TroopName = "Barbarians"
				ElseIf _ColorCheck($TroopKind, Hex(0xF8D198, 6), 20) Then
					if ($CurGiant=0 and $FirstStart) then $CurGiant -= $TroopQ
					$TroopName = "Giants"
				ElseIf _ColorCheck($TroopKind, Hex(0x93EC60, 6), 20) Then
					if ($CurGoblin=0 and $FirstStart) then $CurGoblin -= $TroopQ
					$TroopName = "Goblins"
				ElseIf _ColorCheck($TroopKind, Hex(0x48A8E8, 6), 20) Then
					if ($CurWB=0 and $FirstStart) then $CurWB -= $TroopQ
					$TroopName = "Wallbreakers"
				EndIf
				If $TroopQ <> 0 Then SetLog("- " & $TroopName & " " & $TroopQ, $COLOR_GREEN)
			Next
		EndIf
			If $fullArmy Then
			SetLog("Army Camp Full : " & $fullArmy, $COLOR_RED)
			EndIf
		ClickP($TopLeftClient) ;Click Away
		$FirstCampView = True
	EndIf
Endfunc  ;==>CheckArmyCamp