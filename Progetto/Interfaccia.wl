(* ::Package:: *)

(* :Title:Interfaccia*)
(* :Context:Trasformazione Immagini*)
(* :Author:Gruppo 3 - Mattia Albertini, Giacomo Biribicchi, Orazio Capone, Erik Dervishi, Alex Rossi*)
(* :Summary:Pacchetto che contiene tutta la parte di codice che viene 
	utilizzata per l'interazione con l'utente*)
(* :Package Version:0.9*)
(* :Mathematica Version:14.3*)
(* :History:last modified 16/5/2026*)
(* :Keywords:interfaccia, immagini*)
(* :Limitations:this is a preliminary version,for educational purposes only.*)

(*La graffa all'interno di BeginPackage indica una dipendenza di "Interfaccia" nei confronti di "TrasformazioneImmagini"*)
BeginPackage["Interfaccia`", {"TrasformazioneImmagini`", "Classifica`"}];
	(*L'utilizzo di usage permette di rendere le funzioni visibili anche all'esterno del package
		la stringa che gli viene assegnata invece rappresenta le informazioni che vengono mostrate quando
		si utilizza il comando "Information" (?)*)
	Gioca::usage = "Gioca[] avvia l'interfaccia di gioco.";
	Studia::usage = "Studia[] avvia la parte didattica.";

	(*Qui iniziamo il contesto privato in cui definiamo variabili e funzioni a cui l'utente non potr\[AGrave] accedere*)
	Begin["Private`"];
		(*Definiamo dei parametri in cui ARBITRARIAMENTE scegliamo le opzioni di gioco e di visualizzazione*)
		
		(*Altezza in pixel nella schermata*)
		ALTEZZAIMMAGINE = 150; 
		(*Qui definiamo tutti i parametri grafici e di trasformazione, in modo da renderli coerenti in tutte le funzioni*)
		MAXBLUR= 40;
		BLURSTEP= 10;
		ROTATIONSTEP= 30;
		MAXTRANSLATIONSTEP = 11;
		COLORS={None,Red,Green,Blue,Yellow,Cyan,Magenta,Orange};
		
		(*Funzioni private*)
		(*Nota: Attraverso la HoldFirst, 'img' viene passata alla funzione passando 
			il simbolo cos\[IGrave] com'\[EGrave] e NON come valore*)
		SetAttributes[bottoneCaricamento, HoldFirst]
		(*Creiamo il bottone per caricare l'immagine dal file system*)
		bottoneCaricamento[img_] := DynamicModule[{},
			Button[
				Style["Carica Immagine", Bold, 12],
				(*Apre il selettore file ed importa l'immagine se l'utente non annulla*)
				With[{file = SystemDialogInput["FileOpen"]},
					If[file =!= $Canceled,
						(*Controlla che l'estensione sia png o jpg/jpeg \[LongDash] senza punto*)
						If[MemberQ[{"png", "jpg", "jpeg"}, ToLowerCase[FileExtension[file]]],
							img = Import[file],
							(*Estensione non valida: mostra popup di errore*)
							MessageDialog[
								Style["Errore: caricare un'immagine!\nSono supportati solo file .png e .jpeg",
									Red, Bold, 14]
							]
						]
					]
				],
				(*Nota: questa metodologia \[EGrave] importante per evitare 'timeout'
				(di bloccarsi) con file grandi*)
				Method -> "Queued",
				Appearance -> "Framed",
				ImageSize -> {150, 35}
			]
		];
		
		SetAttributes[pulisci, HoldAll]
		(*Pulisce i campi per effettuare modifiche dell'immagine*)
		pulisci[blur_, rotazione_, translaX_, translaY_, colore_]:= DynamicModule[{},
			blur=0;
			rotazione=0;
			translaX=0;
			translaY=0;
			colore = None;			
		];
		
		SetAttributes[bottonePulisci, HoldAll]
		(*Bottone che quando premuto pulisce i campi*)
		bottonePulisci[blur_, rotazione_, translaX_, translaY_, colore_] := DynamicModule[{},
			Button[Style["Pulisci immagine", Bold, 12],
				pulisci[blur, rotazione, translaX, translaY, colore];,
				Background -> RGBColor["#E0FFFF"],
				ImageSize -> {150, 35},
				Appearance -> "Framed"
			]
		];
		
		SetAttributes[larghezzaImg, HoldFirst]
		(*Funzione per ottenere la larghezza dell'immagine*)
		larghezzaImg[img_] := DynamicModule[{},
			ImageDimensions[img][[1]]
		];
		
		SetAttributes[altezzaImg, HoldFirst]
		(*Funzione per ottenere l'altezza dell'immagine*)
		altezzaImg[img_] := DynamicModule[{},
			ImageDimensions[img][[2]]
		];
		
		SetAttributes[aggiornaParametri, HoldAll]
		(*Cambia e imposta casualmente i valori passati come parametro*)
		aggiornaParametri[{blur_, colore_, rotazione_, translaX_, translaY_}]:=Module[{},
			blur=RandomChoice[Range[0, MAXBLUR, BLURSTEP]];
			colore = RandomChoice[COLORS];
			rotazione = RandomChoice[Range[0, 359, ROTATIONSTEP]];
			translaX = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
			translaY = RandomChoice[Range[0, MAXTRANSLATIONSTEP-1, 1]];
		];
		
		SetAttributes[controlliImmagine, HoldAll]
		(*Crea una colonna che contiene tutti i selettori dei parametri delle immagini*)
		controlliImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_] := DynamicModule[{},
			(*Colonna verticale con tutti i controlli, ognuno sulla propria riga*)
			Column[{
				Row[{"Blur:       ", Slider[Dynamic[blur],{0,MAXBLUR,BLURSTEP},Appearance->"Labeled"]}],
				Row[{"Rotazione: ", Slider[Dynamic[rotazione],{0,359,ROTATIONSTEP},Appearance->"Labeled"]}],
				Row[{"Colore:     ", RadioButtonBar[Dynamic[colore],COLORS]}],
				Spacer[1],
				Row[{"Transla X: ", Slider[Dynamic[translaX],{0,MAXTRANSLATIONSTEP-1,1},Appearance->"Labeled"]}],
				Row[{"Transla Y: ", Slider[Dynamic[translaY],{0,MAXTRANSLATIONSTEP-1,1},Appearance->"Labeled"]}]
			}, Alignment->Left]
		];
		
		SetAttributes[mostraImmagine, HoldAll]
		(*La funzione serve per mostrare l'immagine che si aggiorna in modo dinamico*)
		mostraImmagine[img_]:=DynamicModule[{},
			(*Cos\[IGrave] facendo \[EGrave] possibile avere una cella interattiva che mostra i cambiamenti
			applicati sull'immagine in tempo reale*)
			Dynamic[Show[img, ImageSize->{Automatic, ALTEZZAIMMAGINE}]]
		];
		(*Utilizziamo l'overloading: definiamo la stessa funzione che viene chiamata in base ai parametri passati.
			Questa \[EGrave] la funzione chiamata se vogliamo mostrare l'immagine modificata*)
		mostraImmagine[img_, blur_, rotazione_, translaX_, translaY_, colore_]:=DynamicModule[{},
			Dynamic[
				Show[modificaImmagine[img, blur, rotazione, translaX, translaY, colore, MAXTRANSLATIONSTEP], ImageSize->{Automatic, ALTEZZAIMMAGINE}]
			]
		];
		
		(*La funzione controlla se l'immagine attuale \[EGrave] uguale all'immagine che vogliamo ottenere*)
		verifica[{blur1_, colore1_, rotazione1_, translaX1_, translaY1_}, {blur2_, colore2_, rotazione2_, translaX2_, translaY2_}] :=Module[{},
			{blur1,colore1,rotazione1,translaX1,translaY1}==={blur2,colore2,rotazione2,translaX2,translaY2}
		];
		
		(*La funzione aggiorna l'immagine su cui stiamo lavorando*)
		prossimaImmagine[]:=Module[{indice},
			indice = RandomInteger[{0,1000}];
			immagineDaSeed[indice]
		];
		
		(*Mostra tutti i valori in modo ordinato*)
		formattaSoluzione[blur2_, colore2_, rotazione2_, translaX2_, translaY2_] :=
			Column[{
				Style["Valori di soluzione:", Bold, Underlined],
				Row[{"Blur:       ", blur2}],
				Row[{"Colore:     ", colore2}],
				Row[{"Rotazione:  ", rotazione2, "\[Degree]"}],
				Row[{"Transla X:  ", translaX2}],
				Row[{"Transla Y:  ", translaY2}]
			}, Alignment->Left];
			
		(*Funzione di supporto per creare un blocco del podio nella classifica*)
		creaBloccoClassifica[top3_, pos_Integer, colore_, h_] := Module[{},
			Column[{
				(*Nome del giocatore sopra il blocco*)
				Style[If[pos<=Length[top3], top3[[pos,"Nome"]], "-"], 14, Bold],
				(*Blocco colorato con nome e punteggio*)
				Framed[
					Column[{
						Style[If[pos<=Length[top3], top3[[pos,"Nome"]], "-"], 12, White],
						Style[If[pos<=Length[top3], top3[[pos,"Punteggio"]], 0], 22, White, Bold]
					}, Alignment->Center],
					Background->colore,
					FrameStyle->None,
					ImageSize->{100, h},
					Alignment->Center
				],
				(*Posizione in fondo al blocco*)
				Style[ToString[pos]<>"\.ba", 18, Gray]
			}, Alignment->Center]
		];
		
		(*Crea un pannello che mostra la classifica con podio e lista*)
		ClassificaPanel[] := Module[{dati, top3, altri},
			dati = caricaClassifica[];
			(*Prendiamo i primi 3 e i restanti*)
			top3 = Take[dati, UpTo[3]];
			altri = If[Length[dati]>3, Drop[dati,3], {}];
			
			Panel[Column[{
				Style["LEADERBOARD", 24, Bold, Darker[Blue]],
				Spacer[10],
				
				(*Sezione Podio: ordine visivo 2-1-3*)
				Row[{
					creaBloccoClassifica[top3, 2, GrayLevel[0.7], 80],
					creaBloccoClassifica[top3, 1, RGBColor[1,0.84,0], 120],
					creaBloccoClassifica[top3, 3, RGBColor[0.8,0.5,0.2], 60]
				}, Alignment->Bottom],
				
				Spacer[20],
				
				(*Sezione Lista dal 4\[Degree] posto in poi \[LongDash] mostra posizione, nome e punteggio*)
				Column[
					Table[
						Grid[{
							{
								Style[ToString[i+3]<>"\.ba", 16, Bold],
								Column[{
									Style[altri[[i,"Nome"]], 16, Bold],
									Style[ToString[altri[[i,"Punteggio"]]]<>" pt", 13, Italic, Gray]
								}]
							}
						}, ItemSize->{{3, 12}}, Alignment->Left],
						{i, Length[altri]}
					],
					Spacings->1
				]
			}, Alignment->Center], Background->White]
		];
		
		SetAttributes[GiocaPanel, HoldFirst]
		(*Crea il pannello per la parte Gioca*)
		GiocaPanel[punteggio_, seed_, giocatore_]:=DynamicModule[{
			img=Import["https://c8.alamy.com/compit/j253d8/esempio-illustrativo-del-timbro-j253d8.jpg"],
			blur=0,
			colore=None,
			rotazione=0,
			translaX=0,
			translaY=0,
			dims={0,0},
			punteggioLivello=0,
			partite=1,
			blur2=0,
			colore2=None,
			rotazione2=0,
			translaX2=0,
			translaY2=0,
			immagineModificata="",
			aiuti=0,
			auitiUtilizzati = {0, 0, 0, 0, 0},
			(*Variabile che controlla la visibilit\[AGrave] dei valori di soluzione*)
			mostraValori=False,
			messaggioAiuto=""
			},
			(*Impostiamo il seed, che di default \[EGrave] 0*)
			SeedRandom[seed];
			(*Grazie al seed generato generiamo un immagine*)
			img = prossimaImmagine[];
			(*Generiamo casualmente i parametri con cui l'immagine viene modificata*)
			aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
			(*Ci creiamo l'immagine modificata per poterla mostrare*)
			immagineModificata = modificaImmagine[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];
			(*Grazie a 'Panel' posso crearmi una UI grande quanto l'intero pannello del notebook*)
			Panel[
				Column[{
					(*Messaggio di benvenuto con nome giocatore*)
					Style["Benvenuto "<>giocatore, Bold, DarkGreen, 20],
					
					(*Pannello che mostra le due immagini: quella modificata e quella non modificata*)
					Pane[Row[{
						Column[{
							Style["Immagine modificata", Bold],
							Dynamic[Show[immagineModificata, ImageSize->{Automatic, ALTEZZAIMMAGINE}]]
						}, Alignment->Top],
						Spacer[30],
						Column[{
							Style["La tua immagine", Bold],
							mostraImmagine[img, blur, rotazione, translaX, translaY, colore]
						}, Alignment->Top]
					}, Alignment->Center], {Full, ALTEZZAIMMAGINE+10}],
					
					Spacer[10];
					(*Riga che contiene i controlli per modificare l'immagine e i punteggi attuali*)
					Row[{
						(*Controlli trasformazioni*)
						controlliImmagine[img, blur, rotazione, translaX, translaY, colore],
						(*Colonna degli aiuti*)
						Column[{
							Button["Aiuto", 
									auitiUtilizzati[[1]] = 1;
									aiuti = Total[auitiUtilizzati];
									blur=blur2;
									MessageDialog[
										Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. (Blur)", Orange, Bold, 14]
									],
									Background -> RGBColor["#e67e22"]],
							Button["Aiuto", 
									auitiUtilizzati[[2]] = 1;
									aiuti = Total[auitiUtilizzati];
									rotazione=rotazione2;
									MessageDialog[
										Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. (Rotazione)", Orange, Bold, 14]
									],
									Background -> RGBColor["#e67e22"]],
							Button["Aiuto", 
									auitiUtilizzati[[3]] = 1;
									colore=colore2;
									aiuti = Total[auitiUtilizzati];
									MessageDialog[
										Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. (Colore)", Orange, Bold, 14]
									],
									Background -> RGBColor["#e67e22"]],
							Button["Aiuto", 
									auitiUtilizzati[[4]] = 1;
									aiuti = Total[auitiUtilizzati];
									translaX=translaX2;
									MessageDialog[
										Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. (Transla X)", Orange, Bold, 14]
									],
									Background -> RGBColor["#e67e22"]],
							Button["Aiuto", 
									auitiUtilizzati[[5]] = 1;
									aiuti = Total[auitiUtilizzati];
									translaY=translaY2;
									MessageDialog[
										Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. (Transla Y)", Orange, Bold, 14]
									],
									Background -> RGBColor["#e67e22"]]
						}],
						
						Spacer[100],
						
						(*Pannello punteggio e bottoni*)
						Column[{
							Dynamic[Style["Partita n: "<>ToString[partite], Bold]],
							Dynamic[Style["Punteggio: "<>ToString[punteggio], Bold, RGBColor["#2ecc71"]]],
							Dynamic[Style["Aiuti: "<>ToString[aiuti], Bold, Orange]],
							
							Spacer[10],
							
							(*Replica automaticamente tutte le trasformazioni dell'immagine modificata*)
							Button["Risolvi esercizio",
								blur      = blur2;
								rotazione = rotazione2;
								colore    = colore2;
								translaX  = translaX2;
								translaY  = translaY2;
								aiuti = 5;,
								ImageSize -> {Scaled[0.15], 35}
							],
							
							(*Bottone che mostra/nasconde i valori di soluzione*)
							Button[
								Dynamic[If[mostraValori, "Nascondi soluzione", "Mostra soluzione"]],
								aiuti = 5;
								mostraValori = !mostraValori,
								ImageSize -> {Scaled[0.15], 35}
							],
							
							(*Valori di soluzione formattati: visibili solo se mostraValori \[EGrave] True*)
							Dynamic[
								If[mostraValori,
									formattaSoluzione[blur2, colore2, rotazione2, translaX2, translaY2],
									""
								]
							],
							
							Spacer[10],
							
							(*Bottone per verificare se l'immagine ottenuta \[EGrave] quella che vogliamo ottenere*)
							Button[
								Style["Verifica", White, Bold],
								If[verifica[{blur, colore, rotazione, translaX, translaY}, {blur2, colore2, rotazione2, translaX2, translaY2}],
									(*Calcoliamo il punteggio massimo e gli togliamo gli aiuti che abbiamo utilizzato*)
									punteggioLivello=Max[5-aiuti, 0];
									MessageDialog[StringTemplate["Corretto: punteggio `1`, aiuti utilizzati `2`"][punteggioLivello,aiuti]];
									(*Aggiorniamo il punteggio*)
									punteggio=punteggio+punteggioLivello;
									(*Resettiamo gli aiuti*)
									aiuti=0;
									auitiUtilizzati = {0, 0, 0, 0, 0};
									(*Nascondiamo i valori se erano mostrati*)
									mostraValori=False;
									(*Incrementiamo il contatore che indica i turni*)
									partite=partite+1;
									(*Puliamo tutti i campi che abbiamo utilizzato per arrivare alla soluzione*)
									pulisci[blur, rotazione, translaX, translaY, colore];
									(*Passiamo all'immagine successiva*)
									img=prossimaImmagine[];
									(*Ci calcoliamo nuovi parametri*)
									aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
									(*Infine ci calcoliamo la nuova immagine che vogliamo ottenere*)
									immagineModificata=modificaImmagine[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];,
									MessageDialog["sbagliato"]
								],
								Background -> RGBColor["#16a085"],
								ImageSize -> {Scaled[0.15], 35}
							],
							
							Button[
								Style["Prossimo Esercizio", White, Bold],
								(*Resetto gli aiuti*)
								aiuti=0;
								auitiUtilizzati = {0, 0, 0, 0, 0};
								(*Nascondo le soluzioni*)
								mostraValori=False;
								(*Incremento il contatore dei turni*)
								partite=partite+1;
								(*Pulisco i selettori*)
								pulisci[blur, rotazione, translaX, translaY, colore];
								(*Genero una nuova immagine*)
								img=prossimaImmagine[];
								aggiornaParametri[{blur2, colore2, rotazione2, translaX2, translaY2}];
								immagineModificata=modificaImmagine[img, blur2, rotazione2, translaX2, translaY2, colore2, MAXTRANSLATIONSTEP];,
								Background -> RGBColor["#2980b9"],
								ImageSize -> {Scaled[0.15], 35},
								Appearance -> "Framed"
							],
							(* Vecchio bottne di aiuto (sostituito con gli aiuti singoli)
							Button[
								Style["Aiuto", White, Bold, 12],
								aiuti=Min[aiuti+1,5];
								If[aiuti>=1,blur=blur2; messaggioAiuto="(Blur)"];
								If[aiuti>=2,rotazione=rotazione2; messaggioAiuto="(Rotazione)"];
								If[aiuti>=3,colore=colore2; messaggioAiuto="(Colore)"];
								If[aiuti>=4,translaX=translaX2; messaggioAiuto="(Transla X)"];
								If[aiuti>=5,translaY=translaY2; messaggioAiuto="(Transla Y)"];
								MessageDialog[
									Style["E' stato dato il "<>ToString[aiuti]<>"\[Degree] aiuto. "<>messaggioAiuto,
										Orange, Bold, 14]
								],
								Background -> RGBColor["#e67e22"],
								ImageSize -> {Scaled[0.15], 35},
								Appearance -> "Framed"
							],*)
							
							Spacer[10],
							
							(*Pulisci sotto agli altri bottoni*)
							bottonePulisci[blur, rotazione, translaX, translaY, colore]
						
						}, Alignment->Center]
					}, Alignment->Center],
					
					(*Classifica mostrata in fondo al pannello di gioco*)
					ClassificaPanel[]
					
				}, Alignment->Center],
			ImageSize->Full]
		];
		
		(*Funzioni pubbliche*)
		(*Funzione che genera l'ambiente per esercitarsi*)
		Studia[]= DynamicModule[{
				img=Import["https://c8.alamy.com/compit/j253d8/esempio-illustrativo-del-timbro-j253d8.jpg"],
				blur = 0,
				colore = None,
				rotazione = 0,
				translaX = 0,
				translaY = 0,
				dims = {0,0}
			},
			
			Panel[
				Column[{
					(*Nella prima riga bottone caricamento e pulisci affiancati*)
					Row[{
						bottoneCaricamento[img],
						Spacer[10],
						bottonePulisci[blur, rotazione, translaX, translaY, colore]
					}, Alignment->Center],
					
					Spacer[20],
					
					(*Nella seconda riga immagini affiancate della stessa dimensione*)
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
					
					(*Nella terza riga inseriamo il pannello con i controlli*)
					controlliImmagine[img, blur, rotazione, translaX, translaY, colore]
				}, Alignment->Center],
				ImageSize->Full
			]
		];
		
		(*Funzione che crea l'ambiente per giocare*)
		Gioca[]:=DynamicModule[{
				seed=0,
				errorMsg="",
				visual="",
				inputnome="",
				giocatore="",
				punteggio=0,
				(*Sorgente immagini: "Web" o "Locale" \[LongDash] default Web*)
				sorgente="Web",
				partitaIniziata = False,
				statusMsg=""
			},
			Panel[Column[{
				
				(*--- Selezione sorgente immagini ---*)
				Row[{
					Style["Sorgente immagini: ", Bold],
					PopupMenu[Dynamic[sorgente], {"Web"->"Web (EntityList)", "Locale"->"Locale (cartella img)"}],
					Spacer[10],
					Button[
						" Carica Database",
						statusMsg = "Caricamento in corso...";
						If[sorgente === "Web",
							(*Carica immagini dal web tramite EntityList*)
							cacheImmagini = creaDBWeb[];
							lengthImageDb = Length[cacheImmagini];
							statusMsg = "Database Web caricato!",
							(*Carica immagini dalla cartella locale 'img'*)
							cacheImmagini = creaDBCartella[];
							lengthImageDb = Length[cacheImmagini];
							statusMsg = "Database Locale caricato!";
						],
						Background -> LightBlue,
						BaseStyle -> {FontFamily -> "Verdana", Bold},
						Appearance -> "Palette",
						Method -> "Queued"
					],
					Spacer[10],
					Dynamic[Style[statusMsg, Italic, Gray]]
				}],
				
				Spacer[10],
				
				(*--- Nome giocatore, seed e avvio partita ---*)
				Row[{
					Column[{
						Style["Inserisci Seed:", 10, Bold],
						InputField[Dynamic[seed], Number, FieldHint -> "Esempio: 123"]
					}, Alignment->Left, Spacings->0.5],
					Spacer[15],
					Column[{
						Style["Nome Giocatore:", 10, Bold],
						InputField[Dynamic[inputnome], String, FieldHint -> "Tuo nome...", ImageSize -> 200]
					}, Alignment->Left, Spacings->0.5],
					Spacer[15],
					Button[
						Style["Nuova partita", White, Bold, 14],
						If[lengthImageDb == 0,
							errorMsg = "Errore: carica prima il database immagini!";
							visual = "";,
							If[IntegerQ[seed],
								If[inputnome == "",
									errorMsg = "Errore: devi inserire un nome";
									visual = "";,
									errorMsg = "";
									visual = "";
									giocatore = inputnome;
									punteggio = 0;
									partitaIniziata = True;
									visual = GiocaPanel[punteggio, seed, giocatore]
								],
								errorMsg = "Errore: devi inserire un numero intero come Seed";
								visual = "";
							]
						],
						Appearance -> "Framed",
						Background -> RGBColor["#2ecc71"],
						FrameMargins -> {{20, 20}, {5, 5}},
						ImageSize -> {200, 45},
						Enabled -> Dynamic[Not[partitaIniziata]]
					],
					Spacer[10],
					(*Bottone Termina Partita \[LongDash] grande e ben visibile*)
					Button[
						Style["\[FilledSquare]  Termina Partita", FontSize->14, FontWeight->Bold, FontColor->White],
						visual = "";
						If[partitaIniziata, aggiungiPunteggio[giocatore, punteggio];];
						partitaIniziata = False;
						visual = ClassificaPanel[];,
						Background -> RGBColor[0.8, 0.1, 0.1],
						FrameMargins -> 12,
						ImageSize -> {200, 45},
						Enabled -> Dynamic[partitaIniziata]
					]
				}],
				
				Dynamic[Style[errorMsg, Red, Bold]],
				Dynamic[visual]
			}, Alignment->Center]]
		];
		
	End[];
EndPackage[];
