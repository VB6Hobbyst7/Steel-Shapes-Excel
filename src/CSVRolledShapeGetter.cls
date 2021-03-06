VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "CSVRolledShapeGetter"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = False
Attribute VB_Exposed = False
'@Folder("SteelShapes.Data")
Option Explicit
Implements IRolledShapeGetter

Private Type TCSVRolledShapeGetter
    filePath As String
    fileNumber As Long
    keys() As String
    properties() As String
    text As String
    shapeFound As Boolean
End Type

Private This As TCSVRolledShapeGetter

Private Const Delimiter As String = ","
Private Const ModuleName As String = "CSVRolledShapeGetter"
Private Const DataNotFoundErrorMessage As String = _
    "The requested data was not found within the CSV file."

Private Sub Class_Initialize()
    With This
        .filePath = ThisWorkbook.Path & "\" & FileNames.DataFolder & "\" & FileNames.AiscCSVFileName
    End With
End Sub

Public Function GetRolledShape(ByVal shapeName As String) As Object
    On Error GoTo ErrorHandler
    
    This.shapeFound = False
    
    Const NameIndex As Long = 1
    
    This.fileNumber = FreeFile
    Open This.filePath For Input As This.fileNumber
    
    GetKeys
    
    GetProperties NameIndex, shapeName
    
    If Not This.shapeFound Then
        DataErrors.ThrowDataNotFoundError DataNotFoundErrorMessage, ModuleName
    End If
    
    #If Not LateBind Then
        Dim dict As Scripting.Dictionary
        Set dict = New Scripting.Dictionary
    #Else
        Dim dict As Object
        Set dict = CreateObject("Scripting.Dictionary")
    #End If
    
    PopulateDictionary dict

    Close #This.fileNumber
    
    Set GetRolledShape = dict
    
    Exit Function

ErrorHandler:
    ' close file and throw error that can be caught by the main subroutine
    Close #This.fileNumber
    ' Re-throw error so it is caught by the function caller
    Err.Raise Err.Number, Err.Source, Err.Description
End Function

Private Sub GetProperties(ByRef NameIndex As Long, ByRef shapeName As String)
    Do While Not EOF(This.fileNumber)
        Line Input #This.fileNumber, This.text
        This.properties = Split(This.text, Delimiter)
        If StrComp(shapeName, This.properties(NameIndex), vbTextCompare) = 0 Then
            This.shapeFound = True
            Exit Do
        End If
    Loop
End Sub

Private Sub GetKeys()
    Line Input #This.fileNumber, This.text
    This.keys = Split(This.text, Delimiter)
End Sub

Private Sub PopulateDictionary(ByVal dict As Object)
    Dim index As Long
    For index = 0 To UBound(This.keys)
        If dict.count > 0 And dict.Exists(This.keys(index)) Then
            Exit For
        End If
        
        ' The aisc database uses a hyphen character with an ascii
        ' code of 226. Ignore any character with an ascii code
        ' greater than the code for the letter "z" to ignore
        ' properties that do not exist for a given section.
        Const AsciiLowerZCode As Long = 122
        
        If IsNumeric(Trim$(This.properties(index))) Then
            dict.Add This.keys(index), CDbl(This.properties(index))
        ElseIf Not AscW(Trim$(This.properties(index))) > AsciiLowerZCode Then
            dict.Add This.keys(index), This.properties(index)
        End If
    Next index
End Sub

' IRolledShapeGetter implementation

Private Function IRolledShapeGetter_GetRolledShape(ByVal shapeName As String) As Object
    Set IRolledShapeGetter_GetRolledShape = Me.GetRolledShape(shapeName)
End Function


