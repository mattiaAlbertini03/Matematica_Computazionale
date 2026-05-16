(* ::Package:: *)

(* :Title:Classifica*)
(* :Context:Trasformazione immagini*)
(* :Author:Gruppo 3 - Mattia Albertini, Giacomo Biribicchi, Orazio Capone, Erik Dervishi, Alex Rossi*)
(* :Summary:Contiene funzioni per caricare e creare/salvare la classifica*)
(* :Package Version:0.9*)
(* :Mathematica Version:14.3*)
(* :History:last modified 10/5/2026*)
(* :Keywords:classifica, file*)
(* :Limitations:this is a preliminary version,for educational purposes only.*)

(*Crediamo il package per gestire la classifica*)
BeginPackage["Classifica`"];
	(*Dichiaro le variabili che diventano pubbliche ed utilizzabili fuori dal package*)
	aggiungiPunteggio::usage = "aggiungiPunteggio[nome, punteggio] aggiunge un nuovo record alla classifica locale, ordina i risultati in modo decrescente e mantiene solo i migliori 10, salvando il tutto su file.";
	caricaClassifica::usage = "caricaClassifica[] restituisce la lista dei punteggi salvati nel file locale. Se il file non esiste, restituisce una lista vuota {}.";
	(*Definisco la parte privata in cui le funzioni non sono disponibili all'esterno*)
	Begin["Private`"];
		(*Definiamo una variabile in cui ARBITRARIAMENTE scegliamo il nome del file su cui salveremo la classifica*)
		NOMEFILE="classifica.mx";
		
		(*Funzioni private*)
		(*Definiamo una funzione per ottenere il percorso del file su cui salvare la classifica*)
		percorsoClassifica[] := Module[{}, FileNameJoin[{NotebookDirectory[], NOMEFILE}]];
		(*Funzione che salva i dati su file*)
		salvaClassifica[dati_]:= Module[{}, Export[percorsoClassifica[], dati]];
		
		(*Funzioni pubbliche*)
		(*Definiamo una funzione che carica la classifica da file, se presente, altrimenti restituisce una lista vuota*)
		caricaClassifica[] := Module[{}, If[FileExistsQ[percorsoClassifica[]], Import[percorsoClassifica[]], {}]];
		(*La funzione aggiunge il giocatore con il suo punteggio alla classifica, aggiornandola, ordinandola e salvandola*)
		aggiungiPunteggio[nome_String, punti_Integer] := Module[{dati},
			(*Carico la classifica*)
			dati = caricaClassifica[];
			(*Aggiungo il nuovo punteggio*)
			dati = Append[dati, <|"Nome"->nome, "Punteggio"->punti|>];
			
			(*Ordina dal pi\[UGrave] alto al pi\[UGrave] basso*)
			dati = ReverseSortBy[dati, #Punteggio&];
			(*Tieni solo i primi 10*)
			dati = Take[dati, UpTo[10]];
			
			(*Salvo la classfica*)
			salvaClassifica[dati];
		];
		
	End[];
EndPackage[];
