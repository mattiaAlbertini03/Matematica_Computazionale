(* Content-type: application/vnd.wolfram.mathematica *)

(*** Wolfram Notebook File ***)
(* http://www.wolfram.com/nb *)

(* CreatedBy='Wolfram 14.3' *)

(*CacheID: 234*)
(* Internal cache information:
NotebookFileLineBreakTest
NotebookFileLineBreakTest
NotebookDataPosition[       154,          7]
NotebookDataLength[      9422,        238]
NotebookOptionsPosition[      8852,        220]
NotebookOutlinePosition[      9243,        236]
CellTagsIndexPosition[      9200,        233]
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
    RowBox[{
     RowBox[{"imagesEqual", "::", "usage"}], 
     "=", "\"\<Funzione che ritorna TRUE se le due immagini messe a confronto \
sono uguali, FALSE altrimenti\>\""}], ";"}], "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{"Begin", "[", "\"\<Private`\>\"", "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"imgageFromSeed", "::", "usage"}], 
    "=", "\"\<Funzione che ritorna un'immagine specifica in base al seed \
numerico di input\>\""}], "\[IndentingNewLine]", "\t\t", 
   RowBox[{
    RowBox[{"x", " ", "=", "3"}], ";"}], "\[IndentingNewLine]", "\t", 
   RowBox[{"(*", "Codice", "*)"}], "\[IndentingNewLine]", 
   "\[IndentingNewLine]", "\[IndentingNewLine]", 
   RowBox[{"(*", 
    RowBox[{"La", " ", 
     RowBox[{"varabile", " ", "'"}], 
     RowBox[{"animali", "'"}], " ", "funge", " ", "da", " ", 
     RowBox[{"database", "/", "lista"}], " ", "locale", " ", "di", " ", 
     "foto", " ", "per", " ", "50", " ", "specie", " ", "di", " ", 
     "mammiferi", " ", "differenti"}], "*)"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"animali", "=", 
     RowBox[{
      RowBox[{"EntityList", "[", 
       RowBox[{"EntityClass", "[", 
        RowBox[{"\"\<Species\>\"", ",", "\"\<MammalSpecies\>\""}], "]"}], 
       "]"}], "[", 
      RowBox[{"[", 
       RowBox[{"1", ";;", "50"}], "]"}], "]"}]}], ";"}], "\n", 
   "\[IndentingNewLine]", 
   RowBox[{"(*", 
    RowBox[{"Funzione", " ", "che", " ", "ritorna", " ", 
     RowBox[{"un", "'"}], "immagine", " ", "specifica", " ", "in", " ", 
     "base", " ", "al", " ", "seed", " ", "numerico", " ", "dato", " ", "in", 
     " ", "input"}], "*)"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"imageFromSeed", "[", "seed_Integer", "]"}], ":=", 
    RowBox[{"Module", "[", 
     RowBox[{
      RowBox[{"{", "indice", "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{"(*", 
       RowBox[{
        RowBox[{"Si", " ", "ricava", " ", 
         RowBox[{"l", "'"}], "indice", " ", "viene", " ", "ricavato", " ", 
         "tramite", " ", "operazione", " ", "MODULO", " ", "e", " ", 
         "addizionato", " ", "1", " ", "per", " ", "avere", " ", "sempre", " ",
          "un", " ", "indice", " ", "valido"}], ",", " ", 
        RowBox[{"ovvero", " ", ">=", "1"}]}], "*)"}], "\[IndentingNewLine]", 
      RowBox[{
       RowBox[{"indice", "=", 
        RowBox[{
         RowBox[{"Mod", "[", 
          RowBox[{"seed", ",", 
           RowBox[{"Length", "[", "animali", "]"}]}], "]"}], "+", "1"}]}], ";",
        "\[IndentingNewLine]", 
       RowBox[{"EntityValue", "[", 
        RowBox[{
         RowBox[{"animali", "[", 
          RowBox[{"[", "indice", "]"}], "]"}], ",", "\"\<Image\>\""}], 
        "]"}]}]}], "\[IndentingNewLine]", "]"}]}], "\[IndentingNewLine]", 
   "\[IndentingNewLine]", 
   RowBox[{"(*", 
    RowBox[{
     RowBox[{
     "Funzione", " ", "che", " ", "ritorna", " ", "TRUE", " ", "se", " ", 
      "le", " ", "due", " ", "immagini", " ", "messe", " ", "a", " ", 
      "confronto", " ", "sono", " ", "uguali"}], ",", " ", 
     RowBox[{"FALSE", " ", "altrimenti"}]}], "*)"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"imagesEqual", "[", 
     RowBox[{"img1_Image", ",", "img2_Image"}], "]"}], ":=", 
    RowBox[{"Module", "[", 
     RowBox[{
      RowBox[{"{", 
       RowBox[{"data1", ",", "data2"}], "}"}], ",", "\[IndentingNewLine]", 
      RowBox[{"(*", 
       RowBox[{
       "Verifica", " ", "che", " ", "le", " ", "dimensioni", " ", "siano", " ",
         "uguali"}], "*)"}], 
      RowBox[{
       RowBox[{"If", "[", 
        RowBox[{
         RowBox[{
          RowBox[{"ImageDimensions", "[", "img1", "]"}], "=!=", 
          RowBox[{"ImageDimensions", "[", "img2", "]"}]}], ",", 
         RowBox[{"Return", "[", "False", "]"}]}], "]"}], ";", 
       "\[IndentingNewLine]", "\t", 
       RowBox[{"(*", 
        RowBox[{
        "Confronta", " ", "i", " ", "dati", " ", "pixel", " ", "per", " ", 
         "pixel", " ", "e", " ", "ritorna", " ", 
         RowBox[{"l", "'"}], "evaluation"}], "*)"}], "\[IndentingNewLine]", 
       "\t", 
       RowBox[{"data1", "=", 
        RowBox[{"ImageData", "[", "img1", "]"}]}], ";", "\[IndentingNewLine]",
        "\t", 
       RowBox[{"data2", "=", 
        RowBox[{"ImageData", "[", "img2", "]"}]}], ";", "\[IndentingNewLine]",
        "\t", 
       RowBox[{"data1", "===", "data2"}]}]}], "\[IndentingNewLine]", "]"}]}], 
   "\[IndentingNewLine]", "\[IndentingNewLine]", "\t", 
   RowBox[{
    RowBox[{"End", "[", "]"}], ";"}], "\[IndentingNewLine]", 
   RowBox[{
    RowBox[{"EndPackage", "[", "]"}], ";"}], 
   "\[IndentingNewLine]"}]}]], "Input",
 CellChangeTimes->{{3.98481206816646*^9, 3.9848120964769382`*^9}, {
   3.98481247823518*^9, 3.984812611768198*^9}, {3.9848127328362885`*^9, 
   3.9848127960229588`*^9}, {3.9848131988234577`*^9, 3.984813302480421*^9}, {
   3.9848135597958813`*^9, 3.9848135886680984`*^9}, {3.9848138071813087`*^9, 
   3.984813898658329*^9}, 3.984817755385786*^9, {3.984978428333962*^9, 
   3.984978545846283*^9}, {3.984978941461216*^9, 3.9849789865614967`*^9}, 
   3.98497956719174*^9, {3.984984488879463*^9, 3.9849847662820377`*^9}, {
   3.984984844424203*^9, 3.9849848455768957`*^9}, {3.984984882437913*^9, 
   3.984984906406342*^9}, {3.984984999495994*^9, 3.984985002013451*^9}, {
   3.9849850827446537`*^9, 
   3.9849851641524887`*^9}},ExpressionUUID->"83c80bd8-0237-de4f-8b6a-\
d9776d21b4fc"],

Cell[CellGroupData[{

Cell[BoxData[
 RowBox[{"Names", "[", "\"\<TrasformazioneImmagini`*\>\"", "]"}]], "Input",
 NumberMarks->False,
 CellLabel->"In[8]:=",ExpressionUUID->"0e34f1bf-b31d-4669-abe4-b92f868e4d9b"],

Cell[BoxData[
 RowBox[{"{", "\<\"x\"\>", "}"}]], "Output",
 CellChangeTimes->{3.984978601785268*^9},
 CellLabel->"Out[8]=",ExpressionUUID->"66462ef5-7282-4a03-803e-560d66b78db8"]
}, Open  ]]
},
WindowSize->{640, 689},
WindowMargins->{{-1, Automatic}, {Automatic, 0}},
FrontEndVersion->"14.3 for Mac OS X ARM (64-bit) (July 8, 2025)",
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
Cell[554, 20, 7888, 185, 1234, "Input",ExpressionUUID->"83c80bd8-0237-de4f-8b6a-d9776d21b4fc"],
Cell[CellGroupData[{
Cell[8467, 209, 188, 3, 29, "Input",ExpressionUUID->"0e34f1bf-b31d-4669-abe4-b92f868e4d9b"],
Cell[8658, 214, 178, 3, 33, "Output",ExpressionUUID->"66462ef5-7282-4a03-803e-560d66b78db8"]
}, Open  ]]
}
]
*)

