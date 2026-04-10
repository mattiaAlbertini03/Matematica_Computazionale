(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Wolfram 14.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       154,          7]
NotebookDataLength[      5223,        140]
NotebookOptionsPosition[      4643,        122]
NotebookOutlinePosition[      5042,        138]
CellTagsIndexPosition[      4999,        135]
WindowFrame->Normal*)

(* Beginning of Notebook Content *)
Notebook[{

Cell[CellGroupData[{
Cell[BoxData[
 RowBox[{
  RowBox[{"(*", 
   RowBox[{"Qui", " ", "il", " ", "gioco"}], "*)"}], "\[IndentingNewLine]", 
  RowBox[{"(*", 
   RowBox[{"La", " ", "graffa", " ", "equivale", " ", "al", " ", "need"}], 
   "*)"}], "\[IndentingNewLine]", 
  RowBox[{
   RowBox[{
    RowBox[{"BeginPackage", "[", 
     RowBox[{"\"\<Interfaccia`\>\"", ",", " ", 
      RowBox[{"{", "\"\<TrasformazioneImmagini`\>\"", "}"}]}], "]"}], ";"}], 
   "\[IndentingNewLine]", "\t", 
   RowBox[{"(*", 
    RowBox[{"Controlla", " ", "che", " ", "sia", " ", "caricata", " ", 
     RowBox[{"l", "'"}], "altra", " ", "libreria"}], "*)"}], "\[IndentingNewLine]",
    "\t", 
   RowBox[{
    RowBox[{
     RowBox[{
      RowBox[{"Gioca", " ", "[", "]"}], "::", " ", "usage"}], " ", "=", 
     " ", "\"\<Esegue il gioco\>\""}], ";"}], "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{
     RowBox[{
      RowBox[{"Studia", "[", "]"}], "::", "usage"}], " ", "=", 
     " ", "\"\<Esegue la parte didattica\>\""}], ";"}], "\[IndentingNewLine]",
    "\t", 
   RowBox[{"(*", 
    RowBox[{"Funzioni", " ", "che", " ", "saranno", " ", "esterne"}], "*)"}], 
   "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{"Begin", "[", "\"\<Private`\>\"", "]"}], ";"}], "\[IndentingNewLine]",
    "\t\t", 
   RowBox[{
    RowBox[{
     RowBox[{"Gioca", "[", "]"}], " ", ":=", " ", 
     RowBox[{"DynamicModule", "[", 
      RowBox[{
       RowBox[{"{", "}"}], ",", " ", "None"}], "]"}]}], ";"}], "\[IndentingNewLine]",
    "\t\t", 
   RowBox[{
    RowBox[{
     RowBox[{"Studia", "[", "]"}], " ", ":=", " ", 
     RowBox[{"DynamicModule", "[", 
      RowBox[{
       RowBox[{"{", "}"}], ",", " ", "None"}], "]"}]}], ";"}], 
   "\[IndentingNewLine]", "\t", 
   RowBox[{"(*", "Codice", "*)"}], "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{"End", "[", "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"EndPackage", "[", "]"}], ";"}]}]}]], "Input",
 CellChangeTimes->{{3.9848121165644855`*^9, 3.9848121201387463`*^9}, {
   3.984812687591337*^9, 3.984812691627371*^9}, 3.984812956539385*^9, {
   3.984813002068432*^9, 3.9848130660768356`*^9}, {3.98481310644462*^9, 
   3.9848131407629375`*^9}, 3.984813173140251*^9, {3.984813342243744*^9, 
   3.9848133647002754`*^9}, {3.984813424998642*^9, 3.984813466283907*^9}, {
   3.984814558151102*^9, 3.984814560247364*^9}, {3.9848146729695663`*^9, 
   3.9848148168668404`*^9}, {3.984815065039318*^9, 3.984815081976864*^9}, {
   3.9848172888990383`*^9, 3.9848173287380905`*^9}, {3.984817664760891*^9, 
   3.9848176925326424`*^9}, {3.984817768108551*^9, 
   3.9848177702488937`*^9}},ExpressionUUID->"9808ba5d-9110-7f4e-a7a7-\
ae7a6a8d9fcb"],

Cell[BoxData[
 TemplateBox[{
  "Gioca", "shdw", 
   "\"Symbol \\!\\(\\*RowBox[{\\\"\\\\\\\"Gioca\\\\\\\"\\\"}]\\) appears in \
multiple contexts \\!\\(\\*RowBox[{\\\"{\\\", \
RowBox[{\\\"\\\\\\\"Interfaccia`\\\\\\\"\\\", \\\",\\\", \
\\\"\\\\\\\"Global`\\\\\\\"\\\"}], \\\"}\\\"}]\\); definitions in context \\!\
\\(\\*RowBox[{\\\"\\\\\\\"Interfaccia`\\\\\\\"\\\"}]\\) may shadow or be \
shadowed by other definitions.\"", 2, 11, 1, 34128462117395342722, "Local", 
   "Interfaccia`Gioca"},
  "MessageTemplate2",
  BaseStyle->"MSG"]], "Message",
 CellChangeTimes->{3.9848152001907444`*^9},
 CellLabel->
  "During evaluation of \
In[10]:=",ExpressionUUID->"44e8b25b-d424-664d-8994-9f2330f3102a"],

Cell[BoxData[
 TemplateBox[{
  "Studia", "shdw", 
   "\"Symbol \\!\\(\\*RowBox[{\\\"\\\\\\\"Studia\\\\\\\"\\\"}]\\) appears in \
multiple contexts \\!\\(\\*RowBox[{\\\"{\\\", \
RowBox[{\\\"\\\\\\\"Interfaccia`\\\\\\\"\\\", \\\",\\\", \
\\\"\\\\\\\"Global`\\\\\\\"\\\"}], \\\"}\\\"}]\\); definitions in context \\!\
\\(\\*RowBox[{\\\"\\\\\\\"Interfaccia`\\\\\\\"\\\"}]\\) may shadow or be \
shadowed by other definitions.\"", 2, 12, 2, 34128462117395342722, "Local", 
   "Interfaccia`Studia"},
  "MessageTemplate2",
  BaseStyle->"MSG"]], "Message",
 CellChangeTimes->{3.9848152002703476`*^9},
 CellLabel->
  "During evaluation of \
In[10]:=",ExpressionUUID->"d8bea047-3805-184c-9fb3-437ee24f595b"]
}, Open  ]]
},
WindowSize->{571, 418},
WindowMargins->{{Automatic, 152}, {-34, Automatic}},
FrontEndVersion->"14.3 for Microsoft Windows (64-bit) (July 8, 2025)",
StyleDefinitions->"Default.nb",
ExpressionUUID->"85532a06-8df7-4d41-a3a7-ce2ad91bdc81"
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
Cell[CellGroupData[{
Cell[576, 22, 2656, 63, 256, "Input",ExpressionUUID->"9808ba5d-9110-7f4e-a7a7-ae7a6a8d9fcb"],
Cell[3235, 87, 693, 15, 40, "Message",ExpressionUUID->"44e8b25b-d424-664d-8994-9f2330f3102a"],
Cell[3931, 104, 696, 15, 40, "Message",ExpressionUUID->"d8bea047-3805-184c-9fb3-437ee24f595b"]
}, Open  ]]
}
]
*)

