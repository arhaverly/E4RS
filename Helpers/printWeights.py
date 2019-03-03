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

json_file = open("classifier.json", "r")
loaded_classifier_json = json_file.read()
json_file.close()
loaded_classifier = model_from_json(loaded_classifier_json)
loaded_classifier.load_weights("classifier.h5")
print("Loaded classifier from disk")

print("------------------- g -------------------")
counter = 0
for layer in loaded_classifier.layers:
    print(counter)
    print("**********************************************************")
    g=layer.get_config()
    # print (g)
    h=layer.get_weights()[0]
    print(h)
    print("|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||")
    k = layer.get_weights()[1]
    print(k)
    counter += 1

# print("Weights:")
# h=layer.get_weights()
# for i in range(0,3):
#     print("Layer " + str(i))
#     print(h[i])
