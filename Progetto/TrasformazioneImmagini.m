(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Wolfram 14.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       154,          7]
NotebookDataLength[      4218,        119]
NotebookOptionsPosition[      3866,        105]
NotebookOutlinePosition[      4261,        121]
CellTagsIndexPosition[      4218,        118]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{
Cell[BoxData[
 RowBox[{
  RowBox[{"(*", 
   RowBox[{
   "Qui", " ", "solo", " ", "funzioni", " ", "per", " ", "modificare", " ", 
    "immagini"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Title", ":", 
    RowBox[{"Trasformazioni", " ", "Immagini"}]}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Context", ":", 
    RowBox[{"MappaCartesiana`", 
     RowBox[{"??", "?"}]}]}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Author", ":", "GS"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Summary", ":", 
    RowBox[{
    "a", " ", "preliminary", " ", "version", " ", "of", " ", "the", " ", 
     "ComplexMap", " ", "package"}]}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Copyright", ":", 
    RowBox[{"GS", " ", "2026"}]}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", 
    RowBox[{"Package", " ", "Version"}], ":", "0"}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", 
    RowBox[{"Mathematica", " ", "Version"}], ":", "14.3"}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "History", ":", 
    RowBox[{"last", " ", "modified", " ", 
     RowBox[{
      RowBox[{"10", "/", "4"}], "/", "2026"}]}]}], "*)"}], 
  "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{":", "Keywords", ":", "immagini"}], ",", " ", "trasposizioni"}], 
   "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Sources", ":", "biblio"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{
    RowBox[{":", "Limitations", ":", 
     RowBox[{
     "this", " ", "is", " ", "a", " ", "preliminary", " ", "version"}]}], ",", 
    RowBox[{"for", " ", "educational", " ", "purposes", " ", 
     RowBox[{"only", "."}]}]}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Discussion", ":"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", " ", 
   RowBox[{":", "Requirements", ":"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"BeginPackage", "[", "\"\<TrasformazioneImmagini`\>\"", "]"}], 
    ";"}], "\[IndentingNewLine]", "\t", 
   RowBox[{"(*", 
    RowBox[{"Funzioni", " ", "che", " ", "saranno", " ", "esterne"}], "*)"}], 
   "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{
     RowBox[{"x", "::", "usage"}], " ", "=", "\"\<\>\""}], ";"}], "\[IndentingNewLine]",
    "\t", 
   RowBox[{
    RowBox[{"Begin", "[", "\"\<Private`\>\"", "]"}], ";"}], "\[IndentingNewLine]",
    "\t\t", 
   RowBox[{
    RowBox[{"x", " ", "=", "3"}], ";"}], "\[IndentingNewLine]", "\t", 
   RowBox[{"(*", "Codice", "*)"}], "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{"End", "[", "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"EndPackage", "[", "]"}], ";"}], 
   "\[IndentingNewLine]"}]}]], "Input",
 CellChangeTimes->{{3.98481206816646*^9, 3.9848120964769382`*^9}, {
   3.98481247823518*^9, 3.984812611768198*^9}, {3.9848127328362885`*^9, 
   3.9848127960229588`*^9}, {3.9848131988234577`*^9, 3.984813302480421*^9}, {
   3.9848135597958813`*^9, 3.9848135886680984`*^9}, {3.9848138071813087`*^9, 
   3.984813898658329*^9}, 
   3.984817755385786*^9},ExpressionUUID->"83c80bd8-0237-de4f-8b6a-\
d9776d21b4fc"]
},
WindowSize->{949, 461},
WindowMargins->{{0, Automatic}, {Automatic, 0}},
FrontEndVersion->"14.3 for Microsoft Windows (64-bit) (July 8, 2025)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"fea2792b-45b5-1e49-b782-49cd739290f0"
]
(* End of Notebook Content *)

(* Internal cache information *)
(*CellTagsOutline
CellTagsIndex->{}
*)
(*CellTagsIndex
CellTagsIndex->{}
*)
(*NotebookFileOutline
Notebook[{
Cell[554, 20, 3308, 83, 446, "Input",ExpressionUUID->"83c80bd8-0237-de4f-8b6a-d9776d21b4fc"]
}
]
*)

