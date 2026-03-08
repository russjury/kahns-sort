#!/bin/bash
#
# Topological Sorting using BFS/Kahn's Algorithm in BASH
#
# adopted from https://www.geeksforgeeks.org/dsa/topological-sorting-indegree-based-solution/

function sort() {

  adj=("$@")

  n=${#adj[@]}
  indegree=()
    i=0
    while [ $i -lt $n ]; do
      # create indegree array (same size as adj) and set all elements to "0"
      indegree+=(0)
      i=$((i+1))
    done
  queue=()
  res=()
  
  # compute degrees of each
  i=0
  while [ $i -lt $n ]; do
    # create a temp array of current element values
    tmp=(${adj[$i]})
    j=0  
    while [ $j -lt ${#tmp[@]} ]; do
      indegree[${tmp[$j]}]=$(( ${indegree[${tmp[$j]}]} + 1 ))
      j=$((j+1))
    done
    i=$((i+1))
  done
  
  # add all nodes with indegree 0 into the queue
  i=0
  while [ $i -lt $n ]; do
    if [ ${indegree[$i]} == 0 ]; then
      queue+=($i)
    fi
    i=$((i+1))
  done

  # Kahn's Algorithm/BFS
  while [ ${#queue[@]} -gt 0 ]; do
    top=${queue[0]}         # get 'top' of stack/queue (element 0)
    unset 'queue[0]'        # 'pop' top value
    queue=("${queue[@]}")   # reindex array after pop
    res+=($top)             # add index to result array
    i=0
    while [ $i -lt ${#adj[$top]} ]; do                # for next_node in adj[top]
      tmp=(${adj[$top]})
      indegree[${tmp[$i]}]=$(( ${indegree[${tmp[$i]}]} - 1 ))
      if [ ${indegree[${tmp[$i]}]} == 0 ]; then
        queue+=(${tmp[$i]})
      fi
      i=$((i+1))
    done
  done

  # detect cycle and throw error
  if [ ${#res[@]} != ${#adj[@]} ]; then
    return 1
  else
    echo "res: ${res[@]}"
  fi
  return 0
}


# The "adj" array represents a graph of nodes where each element is a node, and values in each element are what node(s) they point to (if any)
#   for example:
#   
#   0 -> 1 -> 2 -> 3
#        ^    ^
#        |   /
#   4 ->  5
# 
# would be written as: (node 0 points to node 1, node 1 points to node 2, node 2 points to node 3, node 3 points to nothing, node 4 points to node 5, node 5 points to nodes 1 and 2)
#adj=("1" "2" "3" "" "5" "1 2")

# other test cases
#adj=("1" "2" "3 5" "" "5" "1")    # cyclical
#adj=("1" "0" )                    # cyclical
#adj=("0" )                        # cyclical
#adj=("1" "2" "" "4" "")           # ok, but disjointed
#adj=("1" "2" "" "1 4" "2")         # good
adj=("" "" "0" "0" "0 1")

sort "${adj[@]}"
ERR=$?
[[ $ERR -eq 0 ]] || echo "cyclical graph detected"
