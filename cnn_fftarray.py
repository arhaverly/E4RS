# Create your first MLP in Keras
from keras.models import Sequential
from keras.layers import Dense
import numpy
# fix random seed for reproducibility
numpy.random.seed(17)
# load pima indians dataset
dataset = numpy.loadtxt("data/data.txt", delimiter=",")
# split into input (X) and output (Y) variables
X = dataset[:,0:435]
Y = dataset[:,435]
# create classifier
classifier = Sequential()
classifier.add(Dense(4, input_dim = 435, activation='relu')) #435, 435
classifier.add(Dense(25, activation='relu')) #50
classifier.add(Dense(1, activation='sigmoid'))
# Compile classifier
classifier.compile(loss='binary_crossentropy', optimizer='adam', metrics=['accuracy'])
# Fit the classifier
classifier.fit(X, Y, epochs=50, batch_size=10) #50
# evaluate the classifier
scores = classifier.evaluate(X, Y)
print("\n%s: %.2f%%" % (classifier.metrics_names[1], scores[1]*100))

#save the classifier
classifier_json = classifier.to_json()
with open("classifier.json", "w") as json_file:
    json_file.write(classifier_json)

classifier.save_weights("classifier.h5")
print("Saved classifier to disk")
