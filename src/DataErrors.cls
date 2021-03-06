VERSION 1.0 CLASS
BEGIN
  MultiUse = -1  'True
END
Attribute VB_Name = "DataErrors"
Attribute VB_GlobalNameSpace = False
Attribute VB_Creatable = False
Attribute VB_PredeclaredId = True
Attribute VB_Exposed = False
'@Folder("SteelShapes.Errors")
Option Explicit
'@PredeclaredId

Public Enum DataError
    DataNotFound = vbObjectError + 100
    PropertyNotFound
End Enum

'@Description "Raise an error when requested data is not found in a data source."
Public Sub ThrowDataNotFoundError(ByRef errorMessage As String, ByRef errorSource As String)
Attribute ThrowDataNotFoundError.VB_Description = "Raise an error when requested data is not found in a data source."
    Err.Raise Number:=DataError.DataNotFound, _
              Source:=errorSource, _
              Description:=errorMessage
End Sub


'@Description "Raise an error when requested property is not found in a data source."
Public Sub ThrowPropertyNotFoundError(ByRef errorMessage As String, ByRef errorSource As String)
Attribute ThrowPropertyNotFoundError.VB_Description = "Raise an error when requested property is not found in a data source."
    Err.Raise Number:=DataError.PropertyNotFound, _
              Source:=errorSource, _
              Description:=errorMessage
End Sub
