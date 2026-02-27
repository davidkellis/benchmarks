import os

struct TreeNode {
mut:
	left  &TreeNode = unsafe { nil }
	right &TreeNode = unsafe { nil }
}

fn item_check(node &TreeNode) int {
	if node.left == unsafe { nil } {
		return 1
	}
	return 1 + item_check(node.left) + item_check(node.right)
}

fn bottom_up_tree(depth int) &TreeNode {
	if depth > 0 {
		return &TreeNode{
			left: bottom_up_tree(depth - 1)
			right: bottom_up_tree(depth - 1)
		}
	}
	return &TreeNode{}
}

fn main() {
	n := if os.args.len > 1 { os.args[1].int() } else { 21 }
	min_depth := 4
	max_depth := if min_depth + 2 > n { min_depth + 2 } else { n }
	stretch_depth := max_depth + 1

	check := item_check(bottom_up_tree(stretch_depth))
	println('stretch tree of depth ${stretch_depth}	 check: ${check}')

	long_lived_tree := bottom_up_tree(max_depth)

	mut depth := min_depth
	for depth <= max_depth {
		iterations := 1 << (max_depth - depth + min_depth)
		mut c := 0
		for _ in 0 .. iterations {
			c += item_check(bottom_up_tree(depth))
		}
		println('${iterations}	 trees of depth ${depth}	 check: ${c}')
		depth += 2
	}

	println('long lived tree of depth ${max_depth}	 check: ${item_check(long_lived_tree)}')
}
