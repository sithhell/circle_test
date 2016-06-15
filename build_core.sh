#!/bin/bash

echo 0 > build_done${CIRCLE_NODE_INDEX}

if [ ${CIRCLE_NODE_INDEX} == 0 ]
then
  echo "foo" > build/bar
  for i in $(seq 1 $((CIRCLE_NODE_TOTAL))
  do
    ssh node${i} echo 1 > build_done${i}
  done
else
  DONE=$(cat build_done${CIRCLE_NODE_INDEX})
  while [[ $DONE != 1 ]]
  do
    inotifywait build_done${CIRCLE_NODE_INDEX}
    DONE=$(cat build_done${CIRCLE_NODE_INDEX})
  done
fi
