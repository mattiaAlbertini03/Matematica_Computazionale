(* ::Package:: *)

(*Nota: La paresenti graffa equivale al 'Need', per verificare se viene caricata la libreria esterna*)
BeginPackage["Interfaccia`", {"TrasformazioneImmagini`"}];
	Gioca::usage = "Gioca[] avvia l'interfaccia di gioco.";
	Studia::usage = "Studia[] avvia la parte didattica.";
	
	Begin["Private`"];
	MAXBLUR= 50;
	BLURSTEP= 10;
	ROTATIONSTEP= 30;
	MAXTRANSLATIONSTEP = 11;
	COLORS={None,Red,Green,Blue,Yellow,Cyan,Magenta,Orange};
		


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
		
		SetAttributes[pulisci, HoldAll]
		pulisci[blur_, rotazione_, translaX_, translaY_, colore_]:= DynamicModule[{},
			blur=0;
			rotazione=0;
			translaX=0;
			translaY=0;
			colore = None;			
		];
		
		SetAttributes[bottonePulisci, HoldAll]
		bottonePulisci[blur_, rotazione_, translaX_, translaY_, colore_] = DynamicModule[{},
			Button["Pulisci",
				pulisci[blur, rotazione, translaX, translaY, colore];
			]
		];

		SetAttributes[getWidth, HoldFirst]
		getWidth[img_] := DynamicModule[{},
			ImageDimensions[img][[1]]
		];
		
		SetAttributes[getHeight, HoldFirst]
		getHeight[img_] := DynamicModule[{},
			ImageDimensions[img][[2]]
		];
		
		SetAttributes[aggiornaParametri, HoldAll]
		aggiornaParametri[ {blur2_, colore2_, rotazione2_, translaX2_, translaY2_}]:=Module[{},
			blur2=RandomChoice[Range[0, MAXBLUR, BLURSTEP]];
			colore2 = RandomChoice[COLORS];
			rotazione2 = RandomChoice[Range[0, 359, ROTATIONSTEP]];
			translaX2 = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
			translaY2 = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
		];
		
		SetAttributes[controlliImmagine, HoldAll]
		controlliImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_] = DynamicModule[{},
			GraphicsColumn[{
							"Blur\n"->Slider[Dynamic[blur],{0,MAXBLUR, BLURSTEP},Appearance->"Labeled"],
							"Rotazione\n"->Slider[Dynamic[rotazione],{0,359, ROTATIONSTEP},Appearance->"Labeled"],
							"Scala Colore\n"->RadioButtonBar[Dynamic[colore],COLORS],
							"Transla X\n"->Slider[Dynamic[translaX],{0, MAXTRANSLATIONSTEP-1, 1},Appearance->"Labeled"],
							"Transla Y\n"->Slider[Dynamic[translaY],{0, MAXTRANSLATIONSTEP-1, 1},Appearance->"Labeled"],
							bottonePulisci[blur, rotazione, translaX, translaY, colore]}
			]
		];
		
		
		SetAttributes[mostraImmagine, HoldFirst]
		mostraImmagine[img_]=DynamicModule[{},
			(*Cos\[IGrave] facendo \[EGrave] possibile avere una cella interattiva che mostra i cambiamenti
			applicati sull'immagine in tempo reale*)
			Dynamic[Show[img]]
		];
		
		
		
		SetAttributes[mostraImmagine, HoldAll]
		mostraImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_]=DynamicModule[{},
			Dynamic[
				Show[modifyImage[img, blur, rotazione, translaX, translaY, colore, MAXTRANSLATIONSTEP]]
			]
		];
		
		verifica[{blur1_, colore1_, rotazione1_, translaX1_, translaY1_}, {blur2_, colore2_, rotazione2_, translaX2_, translaY2_}] :=Module[{},
			{blur1,colore1,rotazione1,translaX1,translaY1}==={blur2,colore2,rotazione2,translaX2,translaY2}
		];
		
		
		prossimaImmagine[]:=Module[{indice},
			indice = RandomInteger[{0,1000}];
			imageFromSeed[indice]
		];
		
		GiocaPanel[seed_]:=DynamicModule[{
			img=Import["https://c8.alamy.com/compit/j253d8/esempio-illustrativo-del-timbro-j253d8.jpg"],
			blur=0,
			colore=None,
			rotazione=0,
			translaX=0,
			translaY=0,
			dims={0,0},
			punteggio=0,
			punteggioLivello=0,
			partite = 1,
			
			blur2 =0,
			colore2=None,
			rotazione2=0,
			translaX2=0,
			translaY2=0,
			immagineModificata="",
			aiuti=0
			},
			SeedRandom[seed];
			img = prossimaImmagine[];
			aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
			immagineModificata = modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];
			(*Grazie a'Panel' posso crearmi una UI grande quanto l'intero pannello del notebook*)
			Panel[GraphicsRow[{
				Column[{
						StringTemplate["Seed attuale `1`"][seed],
						mostraImmagine[img,blur,rotazione,translaX,translaY,colore],
						Dynamic[Show[immagineModificata]]
				}],
				controlliImmagine[img,blur,rotazione,translaX,translaY,colore],
				Column[{
						Dynamic[Style["Partita n: "<>ToString[partite], Bold]],
						Dynamic[Style["Punteggio: "<>ToString[punteggio], Bold]],
						Dynamic[Style["Aiuti: "<>ToString[aiuti], Bold, Green]],
						
						Row[Dynamic[{blur2, colore2, rotazione2, translaX2, translaY2}]],
						
						Button["Verifica",
							If[verifica[{blur, colore, rotazione, translaX, translaY}, {blur2, colore2, rotazione2, translaX2, translaY2}],
								punteggioLivello=Max[ 5-aiuti, 0];
								MessageDialog[StringTemplate["Corretto: punteggio `1`, aiuti utilizzati `2`"][punteggioLivello,aiuti]];
								punteggio= punteggio +punteggioLivello;
								aiuti=0;
								partite= partite+1;
								pulisci[blur, rotazione, translaX, translaY, colore];
								img = prossimaImmagine[];
								aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
								immagineModificata = modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];,
								MessageDialog["sbagliato"]
							]
						],
						
						Button["Next", 
							aiuti=0;
							partite= partite+1;
							pulisci[blur, rotazione, translaX, translaY, colore];
							img = prossimaImmagine[];
							aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
							immagineModificata = modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];
						],
						
						Button["Aiuto",
							aiuti= Min[aiuti+1,5];
							If[aiuti>=1,blur=blur2];
							If[aiuti>=2,rotazione=rotazione2];
							If[aiuti>=3,colore=colore2];
							If[aiuti>=4,translaX=translaX2];
							If[aiuti>=5,translaY=translaY2];
						]
				
				}, Center,ItemSize->20]
			}],ImageSize->Full]];


		Studia[]= DynamicModule[{
				img=Import["https://c8.alamy.com/compit/j253d8/esempio-illustrativo-del-timbro-j253d8.jpg"],
				blur = 0,
				colore = None,
				rotazione = 0,
				translaX = 0,
				translaY = 0,
				dims = {0,0}
			},
			
			
			(*Grazie a 'Panel' posso crearmi una UI grande quanto l'intero pannello del notebook*)
			Panel[GraphicsRow[{
					GraphicsColumn[{
						bottoneCaricamento[img],
						mostraImmagine[img],
						mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
					}, 
						ImageSize->Medium
					],
					controlliImmagine[img, blur, rotazione, translaX, translaY, colore]		
				}], 
				ImageSize->Full
			]
		];
		
		Gioca[]:=DynamicModule[{seed=0, errorMsg="", visual=""},
			Panel[Column[{
					Row[{
						InputField[Dynamic[seed], Number], 
						Button["Nuova partita",
						If[IntegerQ[seed],
						errorMsg = "";
						visual = "";
						visual = GiocaPanel[seed],
						errorMsg="Errore: devi inserire un numero intero";
						visual = "";
						]
					]}],
					
					Dynamic[Style[errorMsg, Red, Bold]],
					Dynamic[visual]
			}]]
		];
	End[];
EndPackage[];
