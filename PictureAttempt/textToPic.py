import numpy as np
from scipy.misc import imsave

filepath = 'FFTRecordings/siren_15x29.txt'
fp = open(filepath)

dim0 = 29
dim1 = 15
dim2 = 3
x = np.zeros((dim0,dim1,dim2))
counter = 0

last = fp.tell()
while fp.readline():
    fp.seek(last)
    for i in range(0,dim0):
        for j in range(0,dim1):
            text = fp.readline()
            text = text.split(',')
            for k in range(0,dim2):
                x[i][j][k] = int(text[k])
    print(x)
    imsave("dataset/training_set/siren/" + str(counter) + ".png", x)
    counter += 1
    last = fp.tell()
