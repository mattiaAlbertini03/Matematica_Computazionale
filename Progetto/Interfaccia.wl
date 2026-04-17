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


SetAttributes[bottoneCaricamento, HoldFirst]
bottoneCaricamento[img_] = DynamicModule[{},
	Button["Carica Immagine",
	(*Apre il selettore file e importa se l'utente non annulla*)
	With[{file=SystemDialogInput["FileOpen"]},
	If[file=!=$Canceled,img=Import[file]]
	],
	Method->"Queued" (*Importante per evitare timeout con file grandi*)
	]
];

SetAttributes[mostraImmagine, HoldFirst]
mostraImmagine[img_]=DynamicModule[{},
	Dynamic[Show[img]]
];

SetAttributes[mostraImmagine, HoldFirst]
mostraImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_]=DynamicModule[{},
	Dynamic[
	Show[modifyImage[img, blur, rotazione, translaX, translaY, colore]]
	]
];


		Studia[]= DynamicModule[{
			img=Import["https://c8.alamy.com/compit/j253d8/esempio-illustrativo-del-timbro-j253d8.jpg"],
			blur = 0,
			colore = None,
			rotazione = 0,
			translaX = 0,
			translaY = 0
			},
			
			Panel[GraphicsRow[{
				GraphicsColumn[{
				bottoneCaricamento[img],
				mostraImmagine[img],
				mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
				}, ImageSize->Medium]
				
				}], ImageSize->Full]
		];
	(*Codice*)
	End[];
EndPackage[];
