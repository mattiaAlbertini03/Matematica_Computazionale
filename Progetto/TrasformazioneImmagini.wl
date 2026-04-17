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
		x =3;
	(*Codice*)


(*La varabile 'animali' funge da database/lista locale di foto per 50 specie di mammiferi differenti*)
animali=EntityList[EntityClass["Species","MammalSpecies"]][[1;;50]];

(*Funzione che ritorna un'immagine specifica in base al seed numerico dato in input*)
imageFromSeed[seed_Integer]:=Module[{indice},
(*Si ricava l'indice viene ricavato tramite operazione MODULO e addizionato 1 per avere sempre un indice valido, ovvero >=1*)
indice=Mod[seed,Length[animali]]+1;
EntityValue[animali[[indice]],"Image"]
]

(*Funzione che ritorna TRUE se le due immagini messe a confronto sono uguali, FALSE altrimenti*)
imagesEqual[img1_Image,img2_Image]:=Module[{data1,data2},
(*Verifica che le dimensioni siano uguali*)If[ImageDimensions[img1]=!=ImageDimensions[img2],Return[False]];
	(*Confronta i dati pixel per pixel e ritorna l'evaluation*)
	data1=ImageData[img1];
	data2=ImageData[img2];
	data1===data2
]

translateImageWrap[image_,tx_,ty_]:=Module[{data,dims,w,h,shiftedData},
data=ImageData[image];
dims=Dimensions[data];
h=dims[[1]];
w=dims[[2]];
(*Normalizza gli shift con Mod per il wrap-around*)
shiftedData=RotateRight[data,{Mod[Round[ty],h],Mod[Round[tx],w],0}];
Image[shiftedData]
]

colorizeImage[image_,color_]:=Module[{hsvColor},
If[color===None,
image,
hsvColor=ColorConvert[color,Hue];
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

modifyImage[image_, blur_, rotation_, tx_, ty_, color_]:=Module[{},
	blurredImg = Blur[image, blur];
	rotatedImg = ImageRotate[blurredImg, -rotation*Degree];
	translatedImg = translateImageWrap[rotatedImg, tx, ty];
	colorizeImage[translatedImg,color]
]

	End[];
EndPackage[];

