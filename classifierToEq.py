# Importing the Keras libraries and packages
from keras.models import Sequential
from keras.layers import Conv2D
from keras.layers import MaxPooling2D
from keras.layers import Flatten
from keras.layers import Dense

#saving
from keras.models import model_from_json
import numpy as np
import os
import math

json_file = open("classifier.json", "r")
loaded_classifier_json = json_file.read()
json_file.close()
loaded_classifier = model_from_json(loaded_classifier_json)
loaded_classifier.load_weights("classifier.h5")
# print("Loaded classifier from disk")


regW = [[],[],[]]
regB = [[],[],[]]
z = [[],[],[]]

input_dim = 435
dim0 = 4
dim1 = 25
dim2 = 1


counter = 0
for layer in loaded_classifier.layers:

    g=layer.get_config()

    h=layer.get_weights()[0]
    regW[counter] = h

    k = layer.get_weights()[1]
    regB[counter] = k

    counter += 1


w = np.array(regW)
b = np.array(regB)

bT0 = np.zeros([dim0,1])
bT1 = np.zeros([dim1,1])
bT2 = np.zeros([dim2,1])
bT = [bT0, bT1, bT2]

# print(example)




for i in range(0,dim0):
    bT[0][i][0] = regB[0][i]


for i in range(0,dim1):
    bT[1][i][0] = regB[1][i]


bT[2][0][0] = regB[2][0]



# ex = [[0],[1],[2],[3],[4],[5]]

wT = [[],[],[]]
wT[0] = w[0].T
wT[1] = w[1].T
wT[2] = w[2].T
def printToArduino():
    print("#include <stdio.h>")
    print("#define INPUT_DIM    " + str(input_dim))
    print("#define DIM0    " + str(dim0))
    print("#define DIM1    " + str(dim1))
    print("#define DIM2    " + str(dim2))
    print()
    print("double wT0[DIM0][INPUT_DIM] = {", end=""),
    for i in range(0, dim0):
        print("{", end=""),
        for j in range(0, input_dim):
            print(str(wT[0][i][j]), end=""),
            if(j < (input_dim-1)):
                print(",", end=""),
        if(i < (dim0-1)):
            print("},")
        else:
            print("}", end=""),
    print("};")

    print("double wT1[DIM1][DIM0] = {", end=""),
    for i in range(0, dim1):
        print("{", end=""),
        for j in range(0, dim0):
            print(str(wT[1][i][j]), end=""),
            if(j < (dim0-1)):
                print(",", end=""),
        if(i < (dim1-1)):
            print("},")
        else:
            print("}", end=""),
    print("};")

    print("double wT2[DIM2][DIM1] = {", end=""),
    for i in range(0, dim2):
        print("{", end=""),
        for j in range(0, dim1):
            print(str(wT[2][i][j]), end=""),
            if(j < (dim1-1)):
                print(",", end=""),
        if(i < (dim2-1)):
            print("},", end="")
        else:
            print("}", end=""),
    print("};")

    print("double b0[DIM0][1] = {", end=""),
    for i in range(0, dim0):
        if(i < dim0-1):
            print("{" + str(bT[0][i][0]) + "},", end=""),
        else:
            print("{" + str(bT[0][i][0]) + "}", end=""),
    print("};")

    print("double b1[DIM1][1] = {", end=""),
    for i in range(0, dim1):
        if(i < dim1-1):
            print("{" + str(bT[1][i][0]) + "},", end=""),
        else:
            print("{" + str(bT[1][i][0]) + "}", end=""),
    print("};")

    print("double b2[DIM2][1] = {", end=""),
    for i in range(0, dim2):
        if(i < dim2-1):
            print("{" + str(bT[2][i][0]) + "},", end=""),
        else:
            print("{" + str(bT[2][i][0]) + "}", end=""),
    print("};")

printToArduino()


# def mmult(x, y, xrow, xcol, yrow, ycol):
#     z = np.zeros([xrow, ycol])
#     for i in range(0, xrow):
#         for j in range(0, ycol):
#             for k in range(yrow):
#                 z[i][j] += x[i][k]*y[k][j]
#     return z


# def hypo(input):
#     z[0] = wT[0].dot(input) + bT[0]

#     # print(wT[0])
#     for i in range(0,dim0):
#         if(z[0][i][0] < 0):
#             z[0][i][0] = 0


#     z[1] = wT[1].dot(z[0]) + bT[1]

#     for i in range(0,dim1):
#         if(z[1][i][0] < 0):
#             z[1][i][0] = 0

#     z[2] = wT[2].dot(z[1]) + b[2]
#     if(z[2][0][0] > 0):
#         return 1
#     else:
#         return 0







# def testAll():
#     fp = open("data.txt")
#     test = np.zeros([input_dim,1])
#     numCorrect = 0
#     counter = 0
#     last = fp.tell()
#     while fp.readline():
#         fp.seek(last)
#         text = fp.readline()
#         text = text.split(',')
#         for i in range(0,input_dim):
#             test[i][0] = text[i]
#         x = hypo(test)
#         if(x == int(text[input_dim])):
#             numCorrect += 1
#         counter += 1
#         last = fp.tell()
#     return numCorrect*1.0/counter

# def testOne():
#     fp = open("data.txt")
#     test = np.zeros([input_dim,1])
#     text = fp.readline()
#     text = text.split(',')
#     for i in range(0,input_dim):
#         test[i][0] = text[i]
#     x = hypo(test)

# testOne()



# print(testAll())
