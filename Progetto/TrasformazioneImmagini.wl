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
	x::usage ="Test";
	imagesEqual::usage="imagesEqual[img1, img2] ritorna TRUE se le immagini sono uguali, FALSE altrimenti";
	translateImageWrap::usage="translateImageWrap";
	colorizeImage::usage="colorizeImage";
	modifyImage::usage="modifyImage";
	Begin["Private`"];
		(*
		NOTA: variabile global di prova, da togliere!
		*)
		x =3;


	(*Creazione della Batch di 100 immagini variegate: prima si ricavano 5 liste 
	di immagini di diversa categoria (Nota: in ogni lista sono presenti 20 img), successivamente si 
	crea un'unica lista, ovvero il batch finale, data dalla Join delle 5 ricavate precedentemente*)
	animalList = EntityList[SampledEntityClass[EntityClass["Species", "MammalSpecies"], 20]];
	mineralList = EntityList[SampledEntityClass["Mineral", 20]];
	elementList = EntityList["Element"][[1;;20]];
	aircraftList = EntityList[SampledEntityClass["Aircraft", 20]];
	movieList = EntityList[SampledEntityClass["Movie", 20]];
	
	imageDatabase = Join[animalList, mineralList, elementList, aircraftList, movieList];
	lengthImageDb = Length[imageDatabase];
	
	(*Funzione che ritorna un'immagine specifica in base al seed numerico dato in input*)
	imageFromSeed[seed_Integer] := Module[{indice},
	    (*Si ricava l'indice tramite operazione MODULO e 
	    addizionato 1 per avere sempre un indice valido, ovvero >=1*)
	    indice = Mod[seed, lengthImageDb] + 1;
	    EntityValue[imageDatabase[[indice]], "Image"]
	]
	
	(*Funzione che ritorna TRUE se le due immagini messe a confronto sono uguali, FALSE altrimenti*)
	imagesEqual[img1_Image,img2_Image]:=Module[{data1,data2},
		(*Verifica che le dimensioni siano uguali*)
		If[ImageDimensions[img1]=!=ImageDimensions[img2],Return[False]];
		(*Confronta i dati pixel per pixel e ritorna l'evaluation*)
		data1=ImageData[img1];
		data2=ImageData[img2];
		(*Confronto dei dati in forma data[[[riga, colonna, canale]]*)
		data1===data2
	]
	
	(*Funzione che trasla l'immagine secondo gli indici di traslazione dati in input 
	delle coordinate x e y*)
	translateImageWrap[image_,tx_,ty_]:=Module[{data,dims,w,h,shiftedData},
		(*L'immagine viene convertita in un'immagine 3d: data[[[riga, colonna, canale]]]*)
		data=ImageData[image];
		dims=Dimensions[data];
		(*Si ottengno numero di righe - altezza*)
		h=dims[[1]];
		(*Si ottengno numero di colonne - larghezza*)
		w=dims[[2]];
		(*Viene applicato uno shift con wrap-around permetendo la traslazione di un'immagine 
		'rientrando' dal lato opposto*)
		shiftedData=RotateRight[data,{
				(*Con Mod si normalizza lo spostamento per evitare di andare fuori dal range*)
				Mod[Round[ty],h],
				Mod[Round[tx],w],
				(*Canale RGB rimancono intoccati*)
				0}];
		(*Riconversione in formato immagine*)
		Image[shiftedData]
	]
	
	(*Funzione che data un'immagine ed una tonalit\[AGrave] di colore, tinge l'immagine stessa e la restituisce*)
	colorizeImage[image_,color_]:=Module[{hsvColor},
		(*Controllo se la tonalit\[AGrave] esiste: se 'No' allora restituisco l'immagine stessa,
		 altrimenti tingo l'immagine stessa*)
		If[color===None,
			image,
			(*Conversione del colore in forma 'Hue, Saturation, Value' con 
			ogni valore compreso tra 0 e 1*)
			hsvColor=ColorConvert[color,Hue];
			(*L'immagine viene trasformata in una scala di grigi e poi applicata una funzione colore
			pixel per pixel; nello specifico qui si mantiene il valore di luminosit\[AGrave] originale ma si 
			va a modificare sia la Hue che la Saturation*)
			Colorize[image,ColorFunction->(Hue[hsvColor[[1]],hsvColor[[2]],#]&)]]
	]
	
	(*modifiedImg=DynamicModule[{},
	Dynamic[
	blurredImg = Blur[img, blur];
	rotatedImg = ImageRotate[blurredImg, -rotazione*Degree];
	translatedImg = translateImageWrap[rotatedImg, translaX, translaY];
	colorizedImg = colorizeImage[translatedImg,colore];
	Show[colorizedImg]
	]
	];*)
	
	(*Funzione che dato in input Immagine, indice di blurring, indice di rotazione, 
	indici di traslazione (lungo gli assi x e y) e colore, si ritorna l'immagine con applicata le transformazioni*)
	modifyImage[image_, blur_, rotation_, tx_, ty_, color_]:=Module[{},
		blurredImg = Blur[image, blur];
		rotatedImg = ImageRotate[blurredImg, -rotation*Degree];
		translatedImg = translateImageWrap[rotatedImg, tx, ty];
		colorizeImage[translatedImg, color]
	]
	
	End[];
EndPackage[];
