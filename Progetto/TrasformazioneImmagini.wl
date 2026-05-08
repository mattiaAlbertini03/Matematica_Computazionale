(* ::Package:: *)

(*Qui solo funzioni per modificare immagini*)
(* :Title:Trasformazioni Immagini*)
(* :Context:MappaCartesiana`???*)
(* :Author:GS*)
(* :Summary:a preliminary version of the ComplexMap package*)
(* :Copyright:GS 2026*)
(* :Package Version:0*)
(* :Mathematica Version:14.3*)
(* :History:last modified 10/4/2026*)
(* :Keywords:immagini, trasposizioni*)
(* :Sources:biblio*)
(* :Limitations:this is a preliminary version,for educational purposes only.*)
(* :Discussion:*)
(* :Requirements:*)
BeginPackage["TrasformazioneImmagini`"];
	(*Funzioni che saranno esterne*)
	imagesEqual::usage="imagesEqual[img1, img2] ritorna TRUE se le immagini sono uguali, FALSE altrimenti";
	translateImageWrap::usage="translateImageWrap";
	colorizeImage::usage="colorizeImage";
	modifyImage::usage="modifyImage";
	imageFromSeed::usage="imageFromSeed";
	buildDatabaseFromFolder::usage="buildDatabaseFromFolder[] carica le immagini dalla cartella 'img' nella directory corrente";
	buildDatabaseFromWeb::usage="buildDatabaseFromWeb[] carica le immagini dal web tramite EntityList";
	imageDatabase::usage="imageDatabase contiene la lista delle entit\[AGrave]/immagini caricate";
    lengthImageDb::usage="lengthImageDb contiene il numero di immagini nel database";
	
	Begin["Private`"];

	(*Funzione che serve a filtrare solo istanze in cui vi \[EGrave] associata la corrispettiva immagine*)
	filterWithImages[entityList_] := Select[
	    entityList,
	    (*Si controlla se si ritorna effettivamente un'immagine valida e con 'Quiet'
	    si evitano di mostrare messaggi di errore per tutte quelle entit\[AGrave] cui immagine NON
	    \[EGrave] stata trovata*)
	    ImageQ[Quiet[EntityValue[#, "Image"]]] &
	]

	(*Funzione che carica le immagini dalla cartella 'img' nella directory corrente*)
	buildDatabaseFromFolder[] := Module[{imgPath, files, images},
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
		If[Length[files]==0,
			MessageDialog["Nessuna immagine trovata nella cartella 'img'"];
			Return[{}]
		];
		(*Importa e converte ogni immagine in formato RGB standard*)
		images = Table[
			Quiet[Image[ColorConvert[RemoveAlphaChannel[Import[f]], "RGB"], "Real"]],
			{f, files}
		];
		(*Filtra eventuali immagini non caricate correttamente*)
		Select[images, ImageQ]
	];

	(*Funzione che carica le immagini dal web tramite EntityList*)
	buildDatabaseFromWeb[] := Module[{animalList, mineralList, elementList, aircraftList, movieList},
		(*Creazione della Batch di immagini variegate: prima si ricavano diverse liste 
		di immagini di diversa categoria (Nota: in ogni lista sono presenti 50 entit\[AGrave] delle quali per\[OGrave] si 
		prenderanno solo quelle cui immagine \[EGrave] presente) e successivamente si fa il Join in un'unica*)
		animalList   = filterWithImages[EntityList[SampledEntityClass[EntityClass["Species", "MammalSpecies"], 50]]];
		(*elementList  = filterWithImages[EntityList["Element"][[1;;50]]];*)
		aircraftList = filterWithImages[EntityList[SampledEntityClass["Aircraft", 50]]];
		movieList    = filterWithImages[EntityList[SampledEntityClass["Movie",    50]]];
		Join[animalList, aircraftList, movieList]
	];

	(*Database e lunghezza: inizializzati vuoti, vengono popolati dalla funzione scelta dall'utente*)
	imageDatabase = {};
	lengthImageDb = 0;

	(*Funzione che ritorna un'immagine specifica in base al seed numerico dato in input*)
	imageFromSeed[seed_Integer] := Module[{indice, e},
	    (*Si ricava l'indice tramite operazione MODULO e 
	    addizionato 1 per avere sempre un indice valido, ovvero >=1*)
	    indice = Mod[seed, lengthImageDb] + 1;
	    e = imageDatabase[[indice]];
	    (*Se l'elemento \[EGrave] gi\[AGrave] un'immagine (caso cartella locale) la ritorna direttamente,
	    altrimenti la recupera tramite EntityValue (caso web)*)
	    If[ImageQ[e],
	    	e,
	    	Image[ColorConvert[RemoveAlphaChannel[EntityValue[e, "Image"]], "RGB"], "Real"]
	    ]
	]
	
	(*Funzione che ritorna TRUE se le due immagini messe a confronto sono uguali, FALSE altrimenti*)
	imagesEqual[img1_Image, img2_Image] := Module[{data1, data2},
		(*Verifica che le dimensioni siano uguali*)
		If[ImageDimensions[img1]=!=ImageDimensions[img2], Return[False]];
		(*Confronta i dati pixel per pixel e ritorna l'evaluation*)
		data1 = ImageData[img1];
		data2 = ImageData[img2];
		(*Confronto dei dati in forma data[[riga, colonna, canale]]*)
		data1===data2
	]
	
	(*Funzione che trasla l'immagine secondo gli indici di traslazione dati in input 
	delle coordinate x e y*)
	translateImageWrap[image_, tx_, ty_, maxSteps_] := Module[{data, dims, w, h, shiftedData, stepX, stepY},
		(*L'immagine viene convertita in un'immagine 3d: data[[riga, colonna, canale]]*)
		data = ImageData[image];
		dims = Dimensions[data];
		(*Si ottengono numero di righe - altezza*)
		h = dims[[1]];
		(*Si ottengono numero di colonne - larghezza*)
		w = dims[[2]];
		stepX = w/maxSteps;
		stepY = h/maxSteps;
		(*Viene applicato uno shift con wrap-around permettendo la traslazione di un'immagine 
		'rientrando' dal lato opposto*)
		shiftedData = RotateRight[data, {
			(*Con Mod si normalizza lo spostamento per evitare di andare fuori dal range*)
			Mod[Round[ty*stepY], h],
			Mod[Round[tx*stepX], w],
			(*Canale RGB rimangono intoccati*)
			0}];
		(*Riconversione in formato immagine*)
		Image[shiftedData]
	]
	
	(*Funzione che data un'immagine ed una tonalit\[AGrave] di colore, tinge l'immagine stessa e la restituisce*)
	colorizeImage[image_, color_] := Module[{hsvColor},
		(*Controllo se la tonalit\[AGrave] esiste: se 'No' allora restituisco l'immagine stessa,
		 altrimenti tingo l'immagine stessa*)
		If[color===None,
			image,
			(*Conversione del colore in forma 'Hue, Saturation, Value' con 
			ogni valore compreso tra 0 e 1*)
			hsvColor = ColorConvert[color, Hue];
			(*L'immagine viene trasformata in una scala di grigi e poi applicata una funzione colore
			pixel per pixel; nello specifico qui si mantiene il valore di luminosit\[AGrave] originale ma si 
			va a modificare sia la Hue che la Saturation*)
			Colorize[image, ColorFunction->(Hue[hsvColor[[1]], hsvColor[[2]], #]&)]
		]
	]
	
	(*Funzione che dato in input Immagine, indice di blurring, indice di rotazione, 
	indici di traslazione (lungo gli assi x e y) e colore, si ritorna l'immagine con applicate le trasformazioni*)
	modifyImage[image_, blur_, rotation_, tx_, ty_, color_, maxStepTraslazione_] := Module[{converted, blurredImg, rotatedImg, translatedImg},
		converted = Image[ColorConvert[RemoveAlphaChannel[image], "RGB"], "Real"];
		blurredImg = Blur[converted, blur];
		rotatedImg = ImageRotate[blurredImg, -rotation*Degree];
		translatedImg = translateImageWrap[rotatedImg, tx, ty, maxStepTraslazione];
		colorizeImage[translatedImg, color]
	]
	
	End[];
EndPackage[];
