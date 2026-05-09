(* ::Package:: *)

(*Contiene tutte le funzione necessarie al notebook che non hanno a che fare con la rapprensenzatione
	la maggioranza di queste funzioni consiste nelle operazioni di trasformazioni delle immagini*)
(* :Title:Operazioni su immagini e DB*)
(* :Context:Trasformazione immagini*)
(* :Author:Gruppo 3*)
(* :Summary:Contine le funzioni per effettuare operazioni sulle immagini e per 
	la gestione dei DataBase*)
(* :Copyright:GS 2026*)
(* :Package Version:0.9*)
(* :Mathematica Version:14.3*)
(* :History:last modified 10/5/2026*)
(* :Keywords:immagini, DataBase*)
(* :Limitations:this is a preliminary version,for educational purposes only.*)

(*Crediamo il package per gestire le immagini e il DB*)
BeginPackage["TrasformazioneImmagini`"];
	(*Dichiaro le variabili che diventano pubbliche ed utilizzabili fuori dal package*)
	confrontoImmagini::usage = "confrontoImmagini[img1, img2] confronta due oggetti immagine e restituisce True se sono identici, False altrimenti.";
	traslaImmagine::usage = "traslaImmagine[img, {tx, ty}] trasla l'immagine img di tx pixel in orizzontale e ty in verticale, riposizionando i pixel che escono dai bordi sul lato opposto (effetto wrap).";
	coloraImmagine::usage = "coloraImmagine[img, colore] applica una tinta all'immagine img mantenendo la sua luminosit\[AGrave] originale. Se colore \[EGrave] None, restituisce l'immagine originale.";
	modificaImmagine::usage = "modificaImmagine[img, blur, rot, tx, ty, colore, maxStep] applica in sequenza all'immagine img: sfocatura (blur), rotazione (rot), traslazione (tx, ty) e ricolorazione (colore). maxStep definisce il passo massimo per il calcolo della traslazione.";
	immagineDaSeed::usage = "immagineDaSeed[seed] seleziona un'immagine dal database in modo deterministico utilizzando un numero intero (seed). Restituisce la prima immagine del database se il seed non \[EGrave] valido.";
	creaDBCartella::usage = "creadDBCartella[] scansiona la sottocartella 'img' della directory corrente, importa tutti i file di immagine validi e aggiorna il database e il conteggio delle immagini disponibili.";
	creaDBWeb::usage = "creaDBWeb[] scarica automaticamente una selezione di immagini dal web (utilizzando le entit\[AGrave] di Wolfram Language), le converte in oggetti immagine e popola il database locale.";
	
	cacheImmagini::usage = "cacheImmagini \[EGrave] una lista globale che memorizza le immagini caricate (come oggetti Image) provenienti dalla cartella locale o dal web. Viene utilizzata come sorgente per la selezione casuale tramite seed.";

	lengthImageDb::usage = "lengthImageDb \[EGrave] una variabile intera che memorizza il numero totale di immagini caricate correttamente nel database. Se \[EGrave] pari a 0, le funzioni di gioco restituiranno un errore.";
	
	(*Definisco la parte privata in cui le funzioni non sono disponibili all'esterno*)
	Begin["Private`"];
		(*Definisco la variabile che mi conterra la cache*)
		(*Database e lunghezza: inizializzati vuoti, vengono popolati dalla funzione scelta dall'utente*)
		cacheImmagini = {};
		lengthImageDb = 0;
	
		(*Funzioni private*)
		(*Funzione che le entit\[AGrave] passate siano associate ad immagini*)
		verificaImmagini[listaEntity_] := Module[{},
			Select[
			    listaEntity,
			    (*Si controlla se si ritorna effettivamente un'immagine valida e con 'Quiet'
			    si evitano di mostrare messaggi di errore per tutte quelle entit\[AGrave] cui immagine NON
			    \[EGrave] stata trovata*)
			    ImageQ[Quiet[EntityValue[#, "Image"]]] &
			]
		];
		
		(*Funzioni pubbliche*)
		(*Funzione che ritorna TRUE se le due immagini messe a confronto sono uguali, FALSE altrimenti*)
		confrontoImmagini[img1_Image, img2_Image] := Module[{data1, data2},
			(*Verifica che le dimensioni siano uguali*)
			If[ImageDimensions[img1]=!=ImageDimensions[img2], Return[False]];
			(*Confronta i dati pixel per pixel e ritorna l'evaluation*)
			data1 = ImageData[img1];
			data2 = ImageData[img2];
			(*Confronto dei dati in forma data[[riga, colonna, canale]]*)
			data1===data2
		];
		
		(*Funzione che trasla l'immagine secondo gli indici di traslazione dati 
			in input delle coordinate x e y*)
		traslaImmagine[img_, tx_, ty_, maxSteps_] := Module[{dati, dims, w, h, datiTraslati, stepX, stepY},
			(*L'immagine viene convertita in un'immagine 3d: data[[riga, colonna, canale]]*)
			dati = ImageData[img];
			dims = Dimensions[dati];
			(*Si ottengono numero di righe - altezza*)
			h = dims[[1]];
			(*Si ottengono numero di colonne - larghezza*)
			w = dims[[2]];
			stepX = w/maxSteps;
			stepY = h/maxSteps;
			(*Viene applicato uno shift con wrap-around permettendo la traslazione di un'immagine 
				'rientrando' dal lato opposto*)
			datiTraslati = RotateRight[dati, {
				(*Con Mod si normalizza lo spostamento per evitare di andare fuori dal range*)
				Mod[Round[ty*stepY], h],
				Mod[Round[tx*stepX], w],
				(*Canale RGB rimangono intoccati*)
				0}];
			(*Riconversione in formato immagine*)
			Image[datiTraslati]
		];
		
		(*Funzione che data un'immagine ed una tonalit\[AGrave] di colore, tinge l'immagine stessa e la restituisce*)
		coloraImmagine[img_, colore_] := Module[{hsvColor},
			(*Controllo se la tonalit\[AGrave] esiste: se 'No' allora restituisco l'immagine stessa,
			 altrimenti tingo l'immagine stessa*)
			If[colore===None,
				img,
				(*Conversione del colore in forma 'Hue, Saturation, Value' con 
				ogni valore compreso tra 0 e 1*)
				hsvColor = ColorConvert[colore, Hue];
				(*L'immagine viene trasformata in una scala di grigi e poi applicata una funzione colore
				pixel per pixel; nello specifico qui si mantiene il valore di luminosit\[AGrave] originale ma si 
				va a modificare sia la Hue che la Saturation*)
				Colorize[img, ColorFunction->(Hue[hsvColor[[1]], hsvColor[[2]], #]&)]
			]
		];
		
		(*Funzione che dato in input Immagine, indice di blurring, indice di rotazione, 
			indici di traslazione (lungo gli assi x e y) e colore, si ritorna l'immagine con applicate le trasformazioni*)
		modificaImmagine[img_, blur_, rotazione_, tx_, ty_, colore_, maxStepTraslazione_] := Module[{tmp, imgBlurrata, imgRuotata, imgTraslata},
			tmp = Image[ColorConvert[RemoveAlphaChannel[img], "RGB"], "Real"];
			imgBlurrata = Blur[tmp, blur];
			imgRuotata = ImageRotate[imgBlurrata, -rotazione*Degree];
			imgTraslata = traslaImmagine[imgRuotata, tx, ty, maxStepTraslazione];
			coloraImmagine[imgTraslata, colore]
		];
		
		(*Funzione che ritorna un'immagine specifica in base al seed numerico dato in input*)
		immagineDaSeed[seed_Integer] := Module[{indice, img},
		    (*Si ricava l'indice tramite operazione MODULO e 
		    addizionato 1 per avere sempre un indice valido, ovvero >=1*)
		    indice = Mod[seed, lengthImageDb] + 1;
		    img = cacheImmagini[[indice]];
		    (*Se l'elemento \[EGrave] gi\[AGrave] un'immagine (caso cartella locale) la ritorna direttamente,
		    altrimenti la recupera tramite EntityValue (caso web)*)
		    If[ImageQ[img],
		    	img,
		    	Image[ColorConvert[RemoveAlphaChannel[EntityValue[img, "Image"]], "RGB"], "Real"]
		    ]
		];
		
		(*Funzione che carica le immagini dalla cartella 'img' nella directory corrente e le salva nella cache*)
		(*TO DO sistemare messageDialog*)
		creaDBCartella[] := Module[{imgPath, files, immagini},
			(*Ricava il percorso della cartella img nella stessa directory del notebook*)
			imgPath = FileNameJoin[{NotebookDirectory[], "img"}];
			(*Verifica che la cartella esista*)
			If[!DirectoryQ[imgPath],
				MessageDialog["Cartella 'img' non trovata in: "<>imgPath];
				Return[{}]
			];
			(*Carica tutti i file immagine supportati dalla cartella*)
			files = Select[
				FileNames[{"*.jpg","*.jpeg","*.png","*.gif","*.bmp","*.tiff"}, imgPath],
				FileExistsQ
			];
			(*Controlla che ci sia almeno un file nella cartella*)
			If[Length[files]==0,
				MessageDialog["Nessuna immagine trovata nella cartella 'img'"];
				Return[{}]
			];
			(*Importa e converte ogni immagine in formato RGB standard*)
			immagini = Table[
				Quiet[Image[ColorConvert[RemoveAlphaChannel[Import[f]], "RGB"], "Real"]],
				{f, files}
			];
			(*Filtra eventuali immagini non caricate correttamente*)
			Select[immagini, ImageQ]
		];
		
		(*Funzione che carica le immagini dal web tramite EntityList*)
		creaDBWeb[] := Module[{listaAnimali, listaAerei, listaFilm},
			(*Creazione della Batch di immagini variegate: prima si ricavano diverse liste 
			di immagini di diversa categoria (Nota: in ogni lista sono presenti 50 entit\[AGrave] delle quali per\[OGrave] si 
			prenderanno solo quelle cui immagine \[EGrave] presente) e successivamente si fa il Join in un'unica*)
			listaAnimali   = verificaImmagini[EntityList[SampledEntityClass[EntityClass["Species", "MammalSpecies"], 50]]];
			listaAerei = verificaImmagini[EntityList[SampledEntityClass["Aircraft", 50]]];
			listaFilm    = verificaImmagini[EntityList[SampledEntityClass["Movie",    50]]];
			Join[listaAnimali, listaAerei, listaFilm]
		];
	
	End[];
EndPackage[];
