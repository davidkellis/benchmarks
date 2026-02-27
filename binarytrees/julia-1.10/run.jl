mutable struct TreeNode
    left::Union{TreeNode, Nothing}
    right::Union{TreeNode, Nothing}
end

function item_check(node::TreeNode)::Int
    if node.left === nothing
        return 1
    end
    return 1 + item_check(node.left) + item_check(node.right)
end

function bottom_up_tree(depth::Int)::TreeNode
    if depth > 0
        return TreeNode(bottom_up_tree(depth - 1), bottom_up_tree(depth - 1))
    end
    return TreeNode(nothing, nothing)
end

function main()
    n = length(ARGS) >= 1 ? parse(Int, ARGS[1]) : 21
    min_depth = 4
    max_depth = max(min_depth + 2, n)
    stretch_depth = max_depth + 1

    check = item_check(bottom_up_tree(stretch_depth))
    println("stretch tree of depth $stretch_depth\t check: $check")

    long_lived_tree = bottom_up_tree(max_depth)

    for depth in min_depth:2:max_depth
        iterations = 1 << (max_depth - depth + min_depth)
        check = 0
        for i in 1:iterations
            check += item_check(bottom_up_tree(depth))
        end
        println("$iterations\t trees of depth $depth\t check: $check")
    end

    println("long lived tree of depth $max_depth\t check: $(item_check(long_lived_tree))")
end

main()
