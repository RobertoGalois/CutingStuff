; Declarer ses variables convenablement
AutoItSetOption("MustDeclareVars", 1)
; Activation du mode evenementiel
Opt("GUIOnEventMode", 1)

; Constantes des GUI
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <GDIPlus.au3>

; Creation de la fenetre principale
Dim $FenetrePrincipale = GUICreate("Automatisation de Scan", 400, 200, 300, 200)
; Fermer le programme en cas de fermeture d'une fenetre.
GUISetOnEvent($GUI_EVENT_CLOSE, "EndProg")

; Creation des elements de la fenetre principale
Dim $FenetrePrincipale_Bouton1 = GUICtrlCreateButton("START", 150,75,100,50)
; Association du bouton1 a la fonction bouton1
GUICtrlSetOnEvent($FenetrePrincipale_Bouton1, FenetrePrincipale_Bouton1)

; Affichage de la fenetre principale
GUISetState(@SW_SHOW, $FenetrePrincipale)

; boucle infinie d'affichage du programme
while 1
; Economie du CPU
Sleep(5000)

WEnd

; Definition des fonctions event
Func EndProg()
	Exit
EndFunc

Func FenetrePrincipale_Bouton1()
	If (GUICtrlRead($FenetrePrincipale_Bouton1) == "START") Then
		scanStart()

	ElseIf (GUICtrlRead($FenetrePrincipale_Bouton1) == "STOP") Then
		scanStop()
	EndIf

EndFunc

Func scanStart()
	GUICtrlSetData($FenetrePrincipale_Bouton1, "STOP")

	For $i = 141 To 482 Step 1
		scanImg($i & "")
	Next

	MsgBox(0, "Finito", "Fini !")
EndFunc

Func scanStop()
	GUICtrlSetData($FenetrePrincipale_Bouton1, "START")
EndFunc

Func scanImg($pName)
	;Load png files as gdi
	_GDIPlus_Startup()

	; get original image
	Local $gdi_pngSrc = @ScriptDir & "\" & $pName &".png"
	Local $gdi_hImage = _GDIPlus_ImageLoadFromFile($gdi_pngSrc)
	; get Y coord when page starts
	local $yCut = getYStart($gdi_hImage)

	; cut the image
	Local $cutImage = _GDIPlus_BitmapCloneArea($gdi_hImage, 0, $yCut, 1061, 1389)

	_GDIPlus_ImageSaveToFile($cutImage, @ScriptDir&"\final\" & $pName & ".png")

	; Release resources
	_GDIPlus_ImageDispose($cutImage)
	_GDIPlus_ImageDispose($gdi_hImage)

	_GDIPlus_Shutdown()

EndFunc

Func getYStart($pGdi_hImage)
	Local $tempY = 110
	Local $found = False

	While (($tempY < 500) AND ($found == False))
		$tempY += 1
		$found = IsConformLine($pGdi_hImage, $tempY)
	WEnd

	Return $tempY + 2
EndFunc

Func IsConformLine($pGdi_hImage, $pY)
	Local $conform = False
	Local $color = (Hex(_GDIPlus_BitmapGetPixel ($pGdi_hImage, 0, $pY)))
	local $tempX = 1
	Local $boolContinue = True

	If ($color == "00000000FFFFFFFF") Then
		$boolContinue = False
	EndIf

	while (($tempX < 100) AND ($boolContinue == True))
		If ((Hex(_GDIPlus_BitmapGetPixel ($pGdi_hImage, $tempX, $pY)) <> $color)) Then
			$boolContinue = False
		EndIf

		$tempX += 1
	WEnd

	Return $boolContinue
EndFunc
