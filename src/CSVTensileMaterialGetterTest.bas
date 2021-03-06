Attribute VB_Name = "CSVTensileMaterialGetterTest"
'@IgnoreModule ProcedureNotUsed
'@Folder("Tests.Data")
Option Explicit

Private Sub Test()

    On Error GoTo ErrorHandler

    Dim getter As ITensileMaterialGetter
    Set getter = New CSVTensileMaterialGetter
    
    Dim matArray() As String
    
    matArray = getter.GetMaterial("ASTM A709", "50W")
    
    Dim item As Variant
    For Each item In matArray
        Debug.Print item
    Next
    
    Exit Sub
ErrorHandler:
    MsgBox Err.Number & ": " & Err.Description

End Sub
