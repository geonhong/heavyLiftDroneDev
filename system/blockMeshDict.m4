/*--------------------------------*- C++ -*----------------------------------*\
| =========                 |                                                 |
| \\      /  F ield         | OpenFOAM: The Open Source CFD Toolbox           |
|  \\    /   O peration     | Version:  v2006                                 |
|   \\  /    A nd           | Website:  www.openfoam.com                      |
|    \\/     M anipulation  |                                                 |
\*---------------------------------------------------------------------------*/
FoamFile
{
    version     2.0;
    format      ascii;
    class       dictionary;
    object      blockMeshDict;
}
// * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * //
dnl
changecom(//)changequote([,]) dnl
define(calc, [esyscmd(perl -e 'print ($1)')]) dnl
dnl
dnl ==============
dnl  <PARAMETERS>
dnl ==============
dnl - constants
define(pi, 3.14159265359) dnl
define(d2r, calc(pi/180)) dnl
define(cos45, calc(cos(45*d2r))) dnl
dnl
dnl - variables
define(R, 0.35)		dnl
define(doff, 0.1)	dnl
dnl define(xle, calc(R+0.02)) 	dnl	x-coord. of leading edge circle
dnl define(yle, 0.10) 	dnl	y-coord. of leading edge circle
dnl define(r, 0.01) 	dnl radius of the leading edge circle
dnl define(xte, calc(R+0.005)) 	dnl x-coord. of trailing edge
dnl define(yte, -0.1) 	dnl y-coord. of trailing edge
dnl define(xinn, 0.36019412)	dnl
dnl define(yinn, 0.10196080)	dnl
dnl define(xout, 0.37995027)	dnl
dnl define(yout, 0.09900404)	dnl
define(loadpars, include([parameters.m4])) dnl
loadpars dnl
dnl
dnl - resultant points
define(xibi, calc(xle-((doff+r)*cos45)))	dnl
define(xibo, calc(xle+((doff+r)*cos45)))	dnl
define(yib, calc(yle+((doff+r)*cos45)))	dnl
define(xlci, calc(xle-(r*cos45)))	dnl
define(xlco, calc(xle+(r*cos45)))	dnl
define(ylc, calc(yle+(r*cos45)))	dnl
dnl
define(ptno, 0) dnl
define(pts,
	(0 -3 $1)
	(0 yte $1)
	(0 0 $1)
	(0 yinn $1)
	(0 yib $1)
	(0 3 $1)

	(calc(R-doff) -3 $1)
	(calc(R-doff) yte $1)
	(calc(R-doff) 0 $1)
	(calc(xinn-doff) yinn $1)
	(xibi yib $1)
	(xibi 3 $1)

	(R -3 $1)
	(R yte $1)
	(R 0 $1)
	(xinn yinn $1)
	(xlci ylc $1)

	(xte -3 $1)
	(xte yte $1)
	(xout yout $1)
	(xlco ylc $1)

	(calc(xte+doff) -3 $1)
	(calc(xte+doff) yte $1)
	(calc(xout+doff) yout $1)
	(xibo yib $1)
	(xibo 3 $1)

	(3 -3 $1)
	(3 yte $1)
	(3 yout $1)
	(3 yib $1)
	(3 3 $1)) dnl
dnl
define(blockList,
	($1 $2 $3 $4 [eval($1+31)] [eval($2+31)] [eval(($3)+31)] [eval(($4)+31)])) dnl
dnl

// scale   0.001;

vertices
(
	// Vertices on z=-0.1 plane
	pts(-0.1)

	// Vertices on z=0.1 plane
	pts(0.1)
);

blocks
(
	hex 
	blockList(0, 6, 7, 1) (40 80 1)
	simpleGrading (1 0.05 1)

	hex 
	blockList(1, 7, 8, 2) (40 20 1)
	simpleGrading (1 1 1)

	hex 
	blockList(2, 8, 9, 3) (40 20 1)
	simpleGrading (1 1 1)

	hex 
	blockList(3, 9, 10, 4) (40 20 1)
	simpleGrading (1 1 1)

	hex 
	blockList(4, 10, 11, 5) (40 80 1)
	simpleGrading (1 20 1)

	hex 
	blockList(6, 12, 13, 7) (30 80 1)
	simpleGrading (0.1 0.05 1)

	hex 
	blockList(7, 13, 14, 8) (30 20 1)
	simpleGrading (0.1 1 1)

	hex 
	blockList(8, 14, 15, 9) (30 20 1)
	simpleGrading (0.1 1 1)

	hex 
	blockList(9, 15, 16, 10) (30 20 1)
	simpleGrading (0.1 1 1)

	hex 
	blockList(10, 16, 20, 24) (30 40 1)
	simpleGrading (0.1 1 1)

	hex 
	blockList(19, 23, 24, 20) (30 20 1)
	simpleGrading (10 1 1)

	hex 
	blockList(18, 22, 23, 19) (30 40 1)
	simpleGrading (10 1 1)

	hex 
	blockList(17, 21, 22, 18) (30 80 1)
	simpleGrading (10 0.05 1)

	hex 
	blockList(12, 17, 18, 13) (5 80 1)
	simpleGrading (1 0.05 1)

	hex 
	blockList(10, 24, 25, 11) (40 80 1)
	simpleGrading (1 20 1)

	hex 
	blockList(21, 26, 27, 22) (80 80 1)
	simpleGrading (20 0.05 1)

	hex 
	blockList(22, 27, 28, 23) (80 40 1)
	simpleGrading (20 1 1)

	hex 
	blockList(23, 28, 29, 24) (80 20 1)
	simpleGrading (20 1 1)
	
	hex 
	blockList(24, 29, 30, 25) (80 80 1)
	simpleGrading (20 20 1)
);

dnl
define(sin50, calc(sin(50*d2r))) dnl
define(cos50, calc(cos(50*d2r))) dnl
dnl

edges
(
	arc 15 16 (calc(xle-r*cos50) calc(yle+r*sin50) -0.1)
	arc 46 47 (calc(xle-r*cos50) calc(yle+r*sin50) 0.1)

	arc 16 20 (xle calc(yle+r) -0.1)
	arc 47 51 (xle calc(yle+r) 0.1)

	arc 19 20 (calc(xle+r*cos50) calc(yle+r*sin50) -0.1)
	arc 50 51 (calc(xle+r*cos50) calc(yle+r*sin50) 0.1)

	BSpline 14 15
	(
		include([section_profile.z0])
	)

	BSpline 45 46
	(
		include([section_profile.z1])
	)
);

dnl
define(fList,
	($1 $2 [eval($2+31)] [eval($1+31)])) dnl
dnl

boundary
(
    farfields
    {
        type patch;
        faces
        (
            fList(1, 0)
            fList(2, 1)
            fList(3, 2)
            fList(4, 3)
            fList(5, 4)
            fList(11, 5)
            fList(25, 11)
            fList(30, 25)
            fList(29, 30)
            fList(28, 29)
            fList(27, 28)
            fList(26, 27)
        );
    }

	lowerWall
	{
		type	patch;
		faces
		(
			fList(0, 6)
			fList(6, 12)
			fList(12, 17)
			fList(17, 21)
			fList(21, 26)
		);
	}

	duct
	{
		type	wall;
		faces
		(
			fList(13, 14)
			fList(14, 15)
			fList(15, 16)
			fList(16, 20)
			fList(20, 19)
			fList(19, 18)
			fList(18, 13)
		);
	}
);

// ************************************************************************* //
