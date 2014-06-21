from matplotlib import pyplot
import pylab
from mpl_toolkits.mplot3d import Axes3D

def main():

	fig = pylab.figure()
	ax = Axes3D(fig)

	x_vals = []
	y_vals = []
	z_vals = []

	fil = open('pc01.txt', 'r')
	lines = fil.readlines()
	print len(lines)

	for l in lines:
		#print l
		vals = l.split(' ')
		x_vals = x_vals + [float(vals[0])]
		y_vals = y_vals + [float(vals[1])]
		z_vals = z_vals + [float(vals[2])]

	ax.scatter(x_vals, y_vals, z_vals)
	pyplot.show()

if __name__ == '__main__':
	main()
