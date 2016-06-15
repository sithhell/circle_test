#!/bin/bash

BUILD_DONE=build_done${CIRCLE_NODE_INDEX}
echo 0 > $BUILD_DONE

ls -lah build/

if [[ ${CIRCLE_NODE_INDEX} == 0 ]]
then
  echo "foo" > build/bar
  for i in $(seq 1 $((CIRCLE_NODE_TOTAL - 1)))
  do
    ssh node${i} echo 1 > build_done${i}
  done
  echo "node 0 done."
else
  DONE=$(cat $BUILD_DONE)
  while [ $DONE != 1 ]
  do
    inotifywait -t 10 $BUILD_DONE
    DONE=$(cat $BUILD_DONE)
  done
  echo "node ${CIRCLE_NODE_INDEX} done"
fi
