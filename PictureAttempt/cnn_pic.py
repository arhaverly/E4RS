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

# Initialising the CNN
classifier = Sequential()

# Step 1 - Convolution
# classifier.add(Conv2D(32, (3, 3), input_shape = (29, 15, 3), activation = 'relu'))

# Step 2 - Pooling
# classifier.add(MaxPooling2D(pool_size = (2, 2)))

# Adding a second convolutional layer
# classifier.add(Conv2D(16, (3, 3), activation = 'relu'))
# classifier.add(MaxPooling2D(pool_size = (2, 2)))

# Step 3 - Flattening
classifier.add(Flatten(input_shape = (29, 15, 3)))

# Step 4 - Full connection
# classifier.add(Dense(input_shape = (29,15,3), units = 1305, activation = 'relu'))
classifier.add(Dense(units = 128, activation = 'relu'))
classifier.add(Dense(units = 1, activation = 'sigmoid'))

# Compiling the CNN
classifier.compile(optimizer = 'adam', loss = 'binary_crossentropy', metrics = ['accuracy'])

# Part 2 - Fitting the CNN to the images
from keras.preprocessing.image import ImageDataGenerator
train_datagen = ImageDataGenerator(rescale = 1./255,
shear_range = 0.2,
zoom_range = 0.2,
horizontal_flip = True)
test_datagen = ImageDataGenerator(rescale = 1./255)
training_set = train_datagen.flow_from_directory('dataset/training_set',
target_size = (29, 15),
batch_size = 32,
class_mode = 'binary')
test_set = test_datagen.flow_from_directory('dataset/test_set',
target_size = (29, 15),
batch_size = 32,
class_mode = 'binary')
classifier.fit_generator(training_set,
steps_per_epoch = 100,
epochs = 50,
validation_data = test_set,
validation_steps = 100)

#save the classifier
classifier_json = classifier.to_json()
with open("classifier.json", "w") as json_file:
    json_file.write(classifier_json)

classifier.save_weights("classifier.h5")
print("Saved classifier to disk")

#load the classifier
json_file = open("classifier.json", "r")
loaded_classifier_json = json_file.read()
json_file.close()
loaded_classifier = model_from_json(loaded_classifier_json)
loaded_classifier.load_weights("classifier.h5")
print("Loaded classifier from disk")


# Part 3 - Making new predictions
# import numpy as np
from keras.preprocessing import image

# test_image = image.load_img('dataset/single_prediction/cat_or_dog_1.jpg', target_size = (64, 64))
# test_image = image.img_to_array(test_image)
# test_image = np.expand_dims(test_image, axis = 0)
# result = classifier.predict(test_image)
# training_set.class_indices
# if result[0][0] == 1:
#     prediction = 'dog'
# else:
#     prediction = 'cat'

# correct = 0
# total = 0
# prediction = "face"
#
# loadedCorrect = 0
# loadedTotal = 0
# loadedPrediction = "face"
# #test all
#     #test face
# for i in range(0, 454):
#     if(os.path.isfile("dataset_tongue/test_set/cropped_face/face." + str(i) + ".jpg")):
#         test_image = image.load_img("dataset_tongue/test_set/cropped_face/face." + str(i) + ".jpg", target_size = (64, 64))
#         test_image = image.img_to_array(test_image)
#         test_image = np.expand_dims(test_image, axis = 0)
#         result = classifier.predict(test_image)
#         loadedResult = loaded_classifier.predict(test_image)
#         training_set.class_indices
#         if result[0][0] == 1:
#             prediction = 'face'
#             correct += 1
#         else:
#             prediction = 'tongue'
#         if loadedResult[0][0] == 1:
#             loadedPprediction = 'face'
#             loadedCorrect += 1
#         else:
#             loadedPrediction = 'tongue'
#         total += 1
#         loadedTotal += 1
#
#     #test tongue
# for i in range(0, 281):
#     if(os.path.isfile("dataset_tongue/test_set/cropped_tongue/tongue." + str(i) + ".jpg")):
#         test_image = image.load_img("dataset_tongue/test_set/cropped_tongue/tongue." + str(i) + ".jpg", target_size = (64, 64))
#         test_image = image.img_to_array(test_image)
#         test_image = np.expand_dims(test_image, axis = 0)
#         result = classifier.predict(test_image)
#         loadedResult = loaded_classifier.predict(test_image)
#         training_set.class_indices
#         if result[0][0] == 1:
#             prediction = 'face'
#         else:
#             correct += 1
#             prediction = 'tongue'
#         if loadedResult[0][0] == 1:
#             loadedPrediction = 'face'
#         else:
#             loadedPrediction = 'tongue'
#             loadedCorrect += 1
#         total += 1
#         loadedTotal += 1
#
#
# print(correct*1.0 / total)
# print(loadedCorrect*1.0 / loadedTotal)
