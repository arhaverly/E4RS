TITLE=$(date +%Y_%m_%d_%H_%M_%S)
python3 cnn_fftarray.py
PERCENT=$(python3 testModel.py | grep "z" | cut -d'z' -f 2)
TITLE="${TITLE}_${PERCENT}"
echo "$TITLE"
python3 classifierToEq.py > arduino.cpp
cat blankArduino.txt >> arduino.cpp
mkdir SavedNets
mkdir SavedNets/${TITLE}
cp classifier.h5 SavedNets/${TITLE}/classifier.h5
cp classifier.json SavedNets/${TITLE}/classifier.json
rm classifier.h5 classifier.json
