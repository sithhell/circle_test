#!/bin/bash

BUILD_DONE=build_done${CIRCLE_NODE_INDEX}
echo 0 > $BUILD_DONE

if [[ ${CIRCLE_NODE_INDEX} == 0 ]]
then
  echo "foo" > build/bar
  for i in $(seq 1 $((CIRCLE_NODE_TOTAL)))
  do
    ssh node${i} echo 1 > build_done${i}
  done
else
  DONE=$(cat $BUILD_DONE)
  while [ $DONE != 1 ]
  do
    inotifywait $BUILD_DONE
    DONE=$(cat $BUILD_DONE)
  done
fi
