#!/bin/bash

# Copyright (2019) Hassan Elseoudy
# Copyright (2020) Christoph Neumann

echo JAVA_HOME=$JAVA_HOME

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd $DIR

chmod a+x *.py

rm *.pyc
rm -rf $DIR/SZ?*
rm -f $DIR/Dataset_Centroids/centroids-iter-last.csv
rm -f $DIR/Dataset_Centroids/centroids-iter-current.csv
rm -f $DIR/Dataset_Centroids/centroids-result.csv
cp $DIR/Dataset_Centroids/centroids-init.csv $DIR/Dataset_Centroids/centroids-iter-last.csv

i=1
while :
do
	/root/hadoop/hadoop-3.3.0/bin/hadoop jar \
	/root/hadoop/hadoop-3.3.0/share/hadoop/tools/lib/hadoop-streaming-3.3.0.jar \
	-file $DIR/Dataset_Centroids/centroids-iter-last.csv \
	-file $DIR/mapper.py \
	-mapper $DIR/mapper.py \
	-file $DIR/reducer.py \
	-reducer $DIR/reducer.py \
	-input $DIR/Dataset_Centroids/iris-flower.csv \
	-output $DIR/SZ$i
	hadoop fs -copyToLocal $DIR/SZ$i/part-00000 $DIR/Dataset_Centroids/centroids-iter-current.csv
	# Compare centroids-iter-last with centroids-iter-current:
	seeiftrue=`python $DIR/reader.py`
	# Replace centroids-iter-last with centroids-iter-current
	mv $DIR/Dataset_Centroids/centroids-iter-current.csv $DIR/Dataset_Centroids/centroids-iter-last.csv
	if [ $seeiftrue = 1 ]
	then
		break
	fi
	i=$((i+1))
done

rm *.pyc
#rm -rf $DIR/SZ?*
rm -f $DIR/centroids-iter-last.csv # temporary file? Hadoop does create it as copy.
mv $DIR/Dataset_Centroids/centroids-iter-last.csv $DIR/Dataset_Centroids/centroids-result.csv

echo ""
echo "== Resulting Centroids from $DIR/Dataset_Centroids/centroids-result.csv =="
cat $DIR/Dataset_Centroids/centroids-result.csv
echo ""
