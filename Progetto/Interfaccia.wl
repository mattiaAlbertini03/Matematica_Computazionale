(* ::Package:: *)

(*Qui il gioco*)
(*La graffa equivale al need*)
BeginPackage["Interfaccia`", {"TrasformazioneImmagini`"}];
	(*Controlla che sia caricata l'altra libreria*)
	Gioca::usage = "Gioca[] avvia l'interfaccia di gioco.";
	Studia::usage = "Studia[] avvia la parte didattica.";
	(*Funzioni che saranno esterne*)
	Begin["Private`"];
		Gioca[]:= DynamicModule[{seed = 0, targetImg}, targetImg = imageFromSeed[seed];
Column[{
Style["Indovina l'Immagine", "Title"],
InputField[Dynamic[seed], Number],
Dynamic[imageFromSeed[seed]]
}]];
		Studia[]:= Text["Parte didattica non ancora implementata."];
	(*Codice*)
	End[];
EndPackage[];
