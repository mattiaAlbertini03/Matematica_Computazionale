(* ::Package:: *)

(*Nota: La paresenti graffa equivale al 'Need', per verificare se viene caricata la libreria esterna*)
BeginPackage["Interfaccia`", {"TrasformazioneImmagini`"}];
	Gioca::usage = "Gioca[] avvia l'interfaccia di gioco.";
	Studia::usage = "Studia[] avvia la parte didattica.";
	
	Begin["Private`"];
		Gioca[]:= DynamicModule[{seed = 0, targetImg}, targetImg = imageFromSeed[seed];
		Column[{
			Style["Indovina l'Immagine", "Title"],
			InputField[Dynamic[seed], Number],
			Dynamic[imageFromSeed[seed]]
		}]];


		(*Nota: Attraverso la HoldFirst, 'img' viene passata alla funzione passando 
			il simbolo cos\[IGrave] com'\[EGrave] e NON come valore*)
		SetAttributes[bottoneCaricamento, HoldFirst]
		(*Nota: DinamicModule viene costruito una sola volta e memorizzato, NON 
		  ricalcolato ogni volta che viene richiamata la funzione (a tal proposito
		  uso il simbolo '=' e NON ':=')*)
		bottoneCaricamento[img_] = DynamicModule[{},
			Button["Carica Immagine",
			(*Apre il selettore file ed importa l'immagine se l'utente non annulla*)
				With[{file=SystemDialogInput["FileOpen"]},
					If[file=!=$Canceled,img=Import[file]]
				],
				(*Nota: questa metodologia \[EGrave] importante per evitare 'timeout'
				(di bloccarsi) con file grandi*)
				Method->"Queued" 
			]
		];
		
		SetAttributes[mostraImmagine, HoldFirst]
		mostraImmagine[img_]=DynamicModule[{},
			(*Cos\[IGrave] facendo \[EGrave] possibile avere una cella interattiva che mostra i cambiamenti
			applicati sull'immagine in tempo reale*)
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
			(*Grazie a 'Panel' posso crearmi una UI grande quanto l'intero pannello del notebook*)
			Panel[GraphicsRow[{
					GraphicsColumn[{
						bottoneCaricamento[img],
						mostraImmagine[img],
						mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
					}, 
						ImageSize->Medium
					]
				}], 
				ImageSize->Full
			]
		];
	End[];
EndPackage[];
