(* ::Package:: *)

BeginPackage["Classifica`"];

 aggiungiPunteggio::Usage = "";
 caricaClassifica::Usage = "";

 Begin["Private`"];
 (*Definiamo il nome del file*)
 NOMEFILE="classifica.mx";
 percorsoClassifica[] := FileNameJoin[{NotebookDirectory[], NOMEFILE}];
 (*Carica i dati:se il file non esiste,crea una lista vuota*)
 caricaClassifica[] := If[FileExistsQ[percorsoClassifica[]], Import[percorsoClassifica[]], {}];
 
 (*Salva i dati sul disco*)
 salvaClassifica[dati_]:= Export[percorsoClassifica[], dati];
 
 (*Aggiunge un giocatore,ordina e salva*)
 aggiungiPunteggio[nome_String, punti_Integer] := Module[{dati},
	dati = caricaClassifica[];
	dati = Append[dati, <|"Nome"->nome, "Punteggio"->punti|>];
	
	(*Ordina dal pi\[UGrave] alto al pi\[UGrave] basso*)
	dati = ReverseSortBy[dati, #Punteggio&];
	(*Tieni solo i primi 10*)
	dati = Take[dati, UpTo[10]];
	salvaClassifica[dati];
	];

 End[];
EndPackage[];
