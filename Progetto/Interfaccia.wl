(* ::Package:: *)

(*Qui il gioco*)
(*La graffa equivale al need*)
BeginPackage["Interfaccia`", {"TrasformazioneImmagini`"}];
	(*Controlla che sia caricata l'altra libreria*)
	Gioca::usage = "Esegue il gioco";
	Studia::usage = "Esegue la parte didattica";
	(*Funzioni che saranno esterne*)
	Begin["Private`"];
		Gioca[]:= DynamicModule[{}, None];
		Studia[]:= DynamicModule[{}, None];
	(*Codice*)
	End[];
EndPackage[];
