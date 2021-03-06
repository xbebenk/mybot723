; #FUNCTION# ====================================================================================================================
; Name ..........: MBR GUI Control Android
; Description ...: This file Includes all functions to current GUI
; Syntax ........: None
; Parameters ....:
; Return values .: None
; Author ........: MMHK (11-2016)
; Modified ......: CodeSlinger69 (2017)
; Remarks .......: This file is part of MyBot, previously known as ClashGameBot. Copyright 2015-2017
;                  MyBot is distributed under the terms of the GNU GPL
; Related .......:
; Link ..........: https://github.com/MyBotRun/MyBot/wiki
; Example .......: No
; ===============================================================================================================================
#include-once

Func LoadCOCDistributorsComboBox()
	Local $sDistributors = $g_sNO_COC
	Local $aDistributorsData = GetCOCDistributors()

	If @error = 2 Then
		$sDistributors = $g_sUNKNOWN_COC
	ElseIf IsArray($aDistributorsData) Then
		$sDistributors = _ArrayToString($aDistributorsData, "|")
	EndIf

	GUICtrlSetData($g_hCmbCOCDistributors, "", "")
	GUICtrlSetData($g_hCmbCOCDistributors, $sDistributors)
EndFunc   ;==>LoadCOCDistributorsComboBox

Func SetCurSelCmbCOCDistributors()
	Local $sIniDistributor
	Local $iIndex
	If _GUICtrlComboBox_GetCount($g_hCmbCOCDistributors) = 1 Then ; when no/unknown/one coc installed
		_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_DISABLE)
	Else
		$sIniDistributor = GetCOCTranslated($g_sAndroidGameDistributor)
		$iIndex = _GUICtrlComboBox_FindStringExact($g_hCmbCOCDistributors, $sIniDistributor)
		If $iIndex = -1 Then ; not found on combo
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, 0)
		Else
			_GUICtrlComboBox_SetCurSel($g_hCmbCOCDistributors, $iIndex)
		EndIf
		GUICtrlSetState($g_hCmbCOCDistributors, $GUI_ENABLE)
	EndIf
EndFunc   ;==>SetCurSelCmbCOCDistributors

Func cmbCOCDistributors()
	Local $sDistributor
	_GUICtrlComboBox_GetLBText($g_hCmbCOCDistributors, _GUICtrlComboBox_GetCurSel($g_hCmbCOCDistributors), $sDistributor)

	If $sDistributor = $g_sUserGameDistributor Then ; ini user option
		$g_sAndroidGameDistributor = $g_sUserGameDistributor
		$g_sAndroidGamePackage = $g_sUserGamePackage
		$g_sAndroidGameClass = $g_sUserGameClass
	Else
		GetCOCUnTranslated($sDistributor)
		If Not @error Then ; not no/unknown
			$g_sAndroidGameDistributor = GetCOCUnTranslated($sDistributor)
			$g_sAndroidGamePackage = GetCOCPackage($sDistributor)
			$g_sAndroidGameClass = GetCOCClass($sDistributor)
		EndIf ; else existing one (no emulator bot startup compatible), if wrong ini info either kept or replaced by cursel when saveconfig, not fall back to google
	EndIf
	readADConfig()
EndFunc   ;==>cmbCOCDistributors

Func DistributorsBotStopEvent()
	LoadCOCDistributorsComboBox()
	SetCurSelCmbCOCDistributors()
EndFunc   ;==>DistributorsBotStopEvent

Func AndroidSuspendFlagsToIndex($iFlags)
	Local $idx = 0
	If BitAND($iFlags, 2) > 0 Then
		$idx = 2
	ElseIf BitAND($iFlags, 1) > 0 Then
		$idx = 1
	EndIf
	If $idx > 0 And BitAND($iFlags, 4) > 0 Then $idx += 2
	Return $idx
EndFunc   ;==>AndroidSuspendFlagsToIndex

Func AndroidSuspendIndexToFlags($idx)
	Local $iFlags = 0
	Switch $idx
		Case 1
			$iFlags = 1
		Case 2
			$iFlags = 2
		Case 3
			$iFlags = 1 + 4
		Case 4
			$iFlags = 2 + 4
	EndSwitch
	Return $iFlags
EndFunc   ;==>AndroidSuspendFlagsToIndex

Func cmbSuspendAndroid()
	$g_iAndroidSuspendModeFlags = AndroidSuspendIndexToFlags(_GUICtrlComboBox_GetCurSel($g_hCmbSuspendAndroid))
EndFunc   ;==>cmbSuspendAndroid

Func ChkAndroidAdbClickDragScript()
	$g_bAndroidAdbClickDragScript = (GUICtrlRead($g_hChkAndroidAdbClickDragScript) = $GUI_CHECKED ? True : False)
EndFunc   ;==>ChkAndroidAdbClickDragScript
