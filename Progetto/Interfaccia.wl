(* ::Package:: *)

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
	aggiornaParametri[{blur2_, colore2_, rotazione2_, translaX2_, translaY2_}]:=Module[{},
		blur2=RandomChoice[Range[0, MAXBLUR, BLURSTEP]];
		colore2 = RandomChoice[COLORS];
		rotazione2 = RandomChoice[Range[0, 359, ROTATIONSTEP]];
		translaX2 = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
		translaY2 = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
	];
	
	SetAttributes[controlliImmagine, HoldAll]
	controlliImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_] = DynamicModule[{},
		(*Colonna verticale con tutti i controlli, ognuno sulla propria riga*)
		Column[{
			Row[{"Blur:       ", Slider[Dynamic[blur],{0,MAXBLUR,BLURSTEP},Appearance->"Labeled"]}],
			Row[{"Rotazione: ", Slider[Dynamic[rotazione],{0,359,ROTATIONSTEP},Appearance->"Labeled"]}],
			Row[{"Colore:     ", RadioButtonBar[Dynamic[colore],COLORS]}],
			Row[{"Transla X: ", Slider[Dynamic[translaX],{0,MAXTRANSLATIONSTEP-1,1},Appearance->"Labeled"]}],
			Row[{"Transla Y: ", Slider[Dynamic[translaY],{0,MAXTRANSLATIONSTEP-1,1},Appearance->"Labeled"]}]
		}, Alignment->Left]
	];
	
	SetAttributes[mostraImmagine, HoldFirst]
	mostraImmagine[img_]=DynamicModule[{},
		(*Cos\[IGrave] facendo \[EGrave] possibile avere una cella interattiva che mostra i cambiamenti
		applicati sull'immagine in tempo reale*)
		Dynamic[Show[img, ImageSize->Medium]]
	];
	
	SetAttributes[mostraImmagine, HoldAll]
	mostraImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_]=DynamicModule[{},
		Dynamic[
			Show[modifyImage[img, blur, rotazione, translaX, translaY, colore, MAXTRANSLATIONSTEP], ImageSize->Medium]
		]
	];
	
	verifica[{blur1_, colore1_, rotazione1_, translaX1_, translaY1_}, {blur2_, colore2_, rotazione2_, translaX2_, translaY2_}] :=Module[{},
		{blur1,colore1,rotazione1,translaX1,translaY1}==={blur2,colore2,rotazione2,translaX2,translaY2}
	];
	
	prossimaImmagine[]:=Module[{indice},
		indice = RandomInteger[{0,1000}];
		imageFromSeed[indice]
	];
	
	(*Formatta i valori di soluzione con nomenclatura leggibile*)
	formattaSoluzione[blur2_, colore2_, rotazione2_, translaX2_, translaY2_] :=
		Column[{
			Style["Valori di soluzione:", Bold, Underlined],
			Row[{"Blur:       ", blur2}],
			Row[{"Colore:     ", colore2}],
			Row[{"Rotazione:  ", rotazione2, "\[Degree]"}],
			Row[{"Transla X:  ", translaX2}],
			Row[{"Transla Y:  ", translaY2}]
		}, Alignment->Left];
	
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
		partite=1,
		blur2=0,
		colore2=None,
		rotazione2=0,
		translaX2=0,
		translaY2=0,
		immagineModificata="",
		aiuti=0,
		(*Variabile che controlla la visibilit\[AGrave] dei valori di soluzione*)
		mostraValori=False
		},
		SeedRandom[seed];
		img = prossimaImmagine[];
		aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
		immagineModificata = modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];
		(*Grazie a 'Panel' posso crearmi una UI grande quanto l'intero pannello del notebook*)
		Panel[
			Column[{
				(*--- RIGA 1: la tua immagine (aggiornata in tempo reale) e immagine modificata ---*)
				Row[{
					Column[{
						Style["La tua immagine", Bold],
						mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
					}, Alignment->Center],
					Spacer[30],
					Column[{
						Style["Immagine modificata", Bold],
						Dynamic[Show[immagineModificata, ImageSize->Medium]]
					}, Alignment->Center]
				}, Alignment->Center],
				
				Spacer[20],
				
				(*--- RIGA 2: controlli + punteggio + bottoni ---*)
				Row[{
					(*Controlli trasformazioni*)
					controlliImmagine[img, blur, rotazione, translaX, translaY, colore],
					
					Spacer[40],
					
					(*Pannello punteggio e bottoni*)
					Column[{
						Dynamic[Style["Partita n: "<>ToString[partite], Bold]],
						Dynamic[Style["Punteggio: "<>ToString[punteggio], Bold]],
						Dynamic[Style["Aiuti: "<>ToString[aiuti], Bold, Green]],
						
						Spacer[10],
						
						(*Bottone che mostra/nasconde i valori di soluzione*)
						Button[
							Dynamic[If[mostraValori, "Nascondi soluzione", "Vedi valori di soluzione"]],
							mostraValori = !mostraValori
						],
						
						(*Valori di soluzione formattati: visibili solo se mostraValori \[EGrave] True*)
						Dynamic[
							If[mostraValori,
								formattaSoluzione[blur2, colore2, rotazione2, translaX2, translaY2],
								""
							]
						],
						
						Spacer[10],
						
						(*Replica automaticamente tutte le trasformazioni dell'immagine modificata*)
						Button["Genera esercizio",
							blur      = blur2;
							rotazione = rotazione2;
							colore    = colore2;
							translaX  = translaX2;
							translaY  = translaY2;
						],
						
						Spacer[10],
						
						Button["Verifica",
							If[verifica[{blur, colore, rotazione, translaX, translaY}, {blur2, colore2, rotazione2, translaX2, translaY2}],
								punteggioLivello=Max[5-aiuti, 0];
								MessageDialog[StringTemplate["Corretto: punteggio `1`, aiuti utilizzati `2`"][punteggioLivello,aiuti]];
								punteggio=punteggio+punteggioLivello;
								aiuti=0;
								mostraValori=False;
								partite=partite+1;
								pulisci[blur, rotazione, translaX, translaY, colore];
								img=prossimaImmagine[];
								aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
								immagineModificata=modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];,
								MessageDialog["sbagliato"]
							]
						],
						
						Button["Next", 
							aiuti=0;
							mostraValori=False;
							partite=partite+1;
							pulisci[blur, rotazione, translaX, translaY, colore];
							img=prossimaImmagine[];
							aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
							immagineModificata=modifyImage[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];
						],
						
						Button["Aiuto",
							aiuti=Min[aiuti+1,5];
							If[aiuti>=1,blur=blur2];
							If[aiuti>=2,rotazione=rotazione2];
							If[aiuti>=3,colore=colore2];
							If[aiuti>=4,translaX=translaX2];
							If[aiuti>=5,translaY=translaY2];
						],
						
						Spacer[10],
						
						(*Pulisci sotto agli altri bottoni*)
						bottonePulisci[blur, rotazione, translaX, translaY, colore]
					
					}, Alignment->Center, ItemSize->20]
				}, Alignment->Center]
			}, Alignment->Center],
		ImageSize->Full]
	];


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
		Panel[
			Column[{
				(*--- RIGA 1: bottone caricamento e pulisci affiancati ---*)
				Row[{
					bottoneCaricamento[img],
					Spacer[10],
					bottonePulisci[blur, rotazione, translaX, translaY, colore]
				}, Alignment->Center],
				
				Spacer[20],
				
				(*--- RIGA 2: immagini affiancate della stessa dimensione ---*)
				Row[{
					Column[{
						Style["Originale", Bold],
						mostraImmagine[img]
					}, Alignment->Center],
					Spacer[30],
					Column[{
						Style["Modificata", Bold],
						mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
					}, Alignment->Center]
				}, Alignment->Center],
				
				Spacer[20],
				
				(*--- RIGA 3: controlli ---*)
				controlliImmagine[img, blur, rotazione, translaX, translaY, colore]
			}, Alignment->Center],
			ImageSize->Full
		]
	];
	
	Gioca[]:=DynamicModule[{seed=0, errorMsg="", visual=""},
		Panel[Column[{
				Row[{
					InputField[Dynamic[seed], Number], 
					Button["Nuova partita",
					If[IntegerQ[seed],
						errorMsg="";
						visual="";
						visual=GiocaPanel[seed],
						errorMsg="Errore: devi inserire un numero intero";
						visual="";
					]
				]}],
				
				Dynamic[Style[errorMsg, Red, Bold]],
				Dynamic[visual]
		}]]
	];
End[];
EndPackage[];
