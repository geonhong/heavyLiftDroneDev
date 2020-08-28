#!/usr/bin/env python3

from math import sqrt, cos, sin, asin, acos, atan, atan2, radians, degrees, pi
import os
import sys

def sqr(s):
	return s*s

def mag(s):
	return sqrt(sqr(s))

def bound(s, low, upp):
	return min( max(s, low), upp)

def func1(xl, yl, r, x):
	return (yl - sqrt(sqr(r)-sqr(x-xl)))/sqr(x)

def func2(xl, r, x):
	return (x-xl)/(2*x*sqrt(sqr(r)-sqr(x-xl)))

def makePtList(xl, yl, r, xte, yte, debug=False):
	ptList = {}

	#- inner lip part
	x = xl
	dx = 0.001

	xhist = []
	shist = []

	it = 1

	while True:
		s = func1(xl, yl, r, x) - func2(xl, r, x)
		shist.append(s)
		xhist.append(x)

		if it > 1:
			dsdx = (shist[-1]-shist[-2])/(xhist[-1]-xhist[-2])
			sect = shist[-1] - dsdx*xhist[-1]
			xnew = -sect/dsdx
			x = xnew
		else:
			x += dx

		it += 1

		if it>100 or mag(s)<1e-8:
			break

	a = func1(xl, yl, r, x)

	xsinn = x
	ysinn = a*sqr(x)

	if debug:
		print('inner intersection point: (', 0.35+ysinn, xsinn, ')')


	# lip inner part
	ptinn = []
	for i in range(1, 11):
		frac = float(i)/10.0

		x = frac*xsinn
		y = a*sqr(x)

		if x>=xsinn:
			break

		ptinn.append([x, y])

	ptList['inner'] = ptinn


	# find outer intersection point
	#   outer line: y = (ysect-yte)/(xsect-xte)*x + d   - linear line
	#				dy/dx = (ysect-yte)/(xsect-xte)
	#   lip circle: y = yl + sqrt( sqr(r) - sqr(x-xl) )
	#				dy/dx = - (x-xl)/(y-yl)

	dx = xl-xte
	dy = yl-yte
	tht0 = atan(dy/dx)
	tht1 = asin(r/sqrt(sqr(dx)+sqr(dy)))
	tht2 = 0.5*pi-tht1

	xsout = xl - r*cos(tht2-tht1)
	ysout = yl + r*sin(tht2-tht1)

	if debug:
		print('outer intersection point: (', 0.35+ysout, xsout, ')')

	# lip circle
	thts = atan((ysinn-yl)/(xsinn-xl)) 
	thte = atan2((ysout-yl),(xsout-xl))

	tht = -pi
	dtht = radians(10.0)

	ptcir = []
	ptcir.append([xsinn, ysinn])

	while tht < pi:
		if tht>=thts and tht<=thte:
			x = xl + r*cos(tht)
			y = yl + r*sin(tht)

			ptcir.append([x, y])
		
		tht += dtht

	ptcir.append([xsout, ysout])

	ptList['circle'] = ptcir

	# lip outer part
	ptout = []
	ptout.append([xsout, ysout])
	ptout.append([xte, yte])

	ptList['outer'] = ptout

	return ptList



#xl = 0.1
#yl = 0.02
#r  = 0.01
#xte = -0.1
#yte = 0.005

argv = sys.argv[1:]

if len(argv) == 0:
	print('no argument is given: please specify\n',
		  '    xle, yle, r, xte, yte\n',
		  '\nterminate program\n'
		 ) 
	
	exit(1)

xl = float(argv[0])
yl = float(argv[1])
r  = float(argv[2])
xte = float(argv[3])
yte = float(argv[4])

#- check validity
def isValidPar(xl, yl, r, xte, yte):
	#- leading edge
	if xl-r<=0.0 or yl-r<=0.0:
		return False
	
	#- trailing edge
	if xte>=0.0 or yte<=0.0:
		return False

	return True


if isValidPar(xl, yl, r, xte, yte):
	pts = makePtList(xl, yl, r, xte, yte, debug=True)
	pti = pts['inner']

	#- create a directory to store section data
	if not os.path.isdir('constant/section'):
		os.mkdir('constant/section')

	#- make lower z-plane profile
	fout = open('constant/section/section_profile.z0', 'w')

	for p in pti:
		fout.write('( ' + str(0.35+p[1]) + ' ' + str(p[0]) + ' -0.1 )\n')

	fout.close()

	#- make upper z-plane profile
	fout = open('constant/section/section_profile.z1', 'w')

	for p in pti:
		fout.write('( ' + str(0.35+p[1]) + ' ' + str(p[0]) + ' 0.1 )\n')

	fout.close()

	#- make parameters file
	fout = open('constant/section/parameters.m4', 'w')

	ptc = pts['circle']

	fout.write('define(xle, calc(R+' + str(yl) + ')) dnl\n')
	fout.write('define(yle, ' + str(xl) + ') dnl\n')
	fout.write('define(r, ' + str(r) + ') dnl\n')
	fout.write('define(xte, calc(R+' + str(yte) + ')) dnl\n')
	fout.write('define(yte, ' + str(xte) + ') dnl\n')
	fout.write('define(xinn, ' + str(0.35+ptc[0][1]) + ') dnl\n')
	fout.write('define(yinn, ' + str(ptc[0][0]) + ') dnl\n')
	fout.write('define(xout, ' + str(0.35+ptc[-1][1]) + ') dnl\n')
	fout.write('define(yout, ' + str(ptc[-1][0]) + ') dnl\n')

	fout.close()

else:
	print('Not available case:\n',
		  '  - xl: ', xl, '\n',
		  '  - yl: ', yl, '\n',
		  '  - r : ', r , '\n',
		  '  - xt: ', xte, '\n',
		  '  - yt: ', yte, '\n'
		 )
