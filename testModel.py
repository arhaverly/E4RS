from keras.models import Sequential
from keras.layers import Dense
import numpy

from keras.models import model_from_json

json_file = open("classifier.json", "r")
classifier_json = json_file.read()
json_file.close()
classifier = model_from_json(classifier_json)
classifier.load_weights("classifier.h5")
print("Loaded classifier from disk")

dataset = numpy.loadtxt("data/data.txt", delimiter=",")

X = dataset[:,0:435]
Y = dataset[:,435]

classifier.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])

scores = classifier.evaluate(X, Y)
# print("\n%s: %.2f%%" % (classifier.metrics_names[1], scores[1]*100))
print("z%d" % (scores[1]*10000))
