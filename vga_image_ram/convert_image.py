#!/usr/bin/python
import sys

import matplotlib.pyplot
import numpy as np

filename = 'image.png'

if len(sys.argv) == 2:
	filename = sys.argv[1]

im = matplotlib.pyplot.imread(filename)

print('orig:', im.shape)


im = im[:, :, 0]
print('channel:', im.shape)


im = np.reshape(im, (-1, 16))
print('reshape:', im.shape)

print('max:', np.max(im))
im = im > 0.5

with open('ram.txt', 'w') as f:
	for row in range(im.shape[0]):
		word = 0
		for col in range(16):
			word |= (im[row, col] << col)

		f.write(f'{word:04x}\n')
