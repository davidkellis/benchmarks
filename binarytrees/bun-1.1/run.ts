// Taken from https://benchmarksgame-team.pages.debian.net/benchmarksgame/program/binarytrees-node-1.html

/* The Computer Language Benchmarks Game
   https://salsa.debian.org/benchmarksgame-team/benchmarksgame/
   contributed by Isaac Gouy
   *reset*
*/

class TreeNode {
  constructor(public left: TreeNode | null, public right: TreeNode | null) { }

  itemCheck(): number {
    if (this.left && this.right) {
      return 1 + this.left.itemCheck() + this.right.itemCheck();
    }
    return 1;
  }
}

function bottomUpTree(depth: number): TreeNode {
  if (depth > 0) {
    return new TreeNode(bottomUpTree(depth - 1), bottomUpTree(depth - 1));
  }

  return new TreeNode(null, null);
}

var minDepth = 4;
var n = +process.argv[2];
var maxDepth = Math.max(minDepth + 2, n);
var stretchDepth = maxDepth + 1;

var check = bottomUpTree(stretchDepth).itemCheck();
console.log("stretch tree of depth " + stretchDepth + "\t check: " + check);

var longLivedTree = bottomUpTree(maxDepth);
for (var depth = minDepth; depth <= maxDepth; depth += 2) {
  var iterations = 1 << (maxDepth - depth + minDepth);

  check = 0;
  for (var i = 1; i <= iterations; i++) {
    check += bottomUpTree(depth).itemCheck();
  }
  console.log(iterations + "\t trees of depth " + depth + "\t check: " + check);
}

console.log("long lived tree of depth " + maxDepth + "\t check: " + longLivedTree.itemCheck());
