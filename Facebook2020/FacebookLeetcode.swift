import Foundation

class RandomizedSet {
    var map: [Int: Int] = [:]
    var array: [Int] = []
    /** Initialize your data structure here. */
    init() {
        print("init")
    }
    
    /** Inserts a value to the set. Returns true if the set did not already contain the specified element. */
    func insert(_ val: Int) -> Bool {
        if map[val] != nil {
            return false
        }
        array.append(val)
        map[val] = array.count-1
        return true
    }
    
    /** Removes a value from the set. Returns true if the set contained the specified element. */
    func remove(_ val: Int) -> Bool {
        if map[val] == nil {
            return false
        }
        if let index = map[val] {
            if index != array.count-1 {
                let tailVal = array[array.count-1]
                map[tailVal] = index
                array[index] = tailVal
            }
            array.removeLast()
            map.removeValue(forKey: val)
        }
        return true
    }
    
    /** Get a random element from the set. */
    func getRandom() -> Int {
        let index = Int.random(in: 0..<array.count)
        return array[index]
    }
}

extension String {
    public subscript(x: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: x)
        return self[index]
    }

    public subscript(x: ClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: x.lowerBound)
        let end = self.index(self.startIndex, offsetBy: x.upperBound)
        return String(self[start...end])
    }

    public subscript(x: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: x.lowerBound)
        let end = self.index(self.startIndex, offsetBy: x.upperBound)
        return String(self[start..<end])
    }

    mutating public func replace(_ x: ClosedRange<Int>, with newString: String) {
        let start = self.index(self.startIndex, offsetBy: x.lowerBound)
        let end = self.index(self.startIndex, offsetBy: x.upperBound)
        replaceSubrange(start...end, with: newString)
    }

    var asciiValue: Int {
        return Int(Character(self).asciiValue ?? 0)
    }
}

extension Int {
    static var min32: Int {
        return -2147483648
    }
}

extension Array where Element == Int {
    mutating func move(_ direction: Solution.Direction) {
        switch direction {
            case .up:
                self[0] -= 1
            case .down:
                self[0] += 1
            case .left:
                self[1] -= 1
            case .right:
                self[1] += 1
        }
    }

    func moveTo(_ direction: Solution.Direction) -> [Int] {
        var copy = self
        copy.move(direction)
        return copy
    }
}

extension Dictionary {
    var description: String {
        let result = self.reduce("[\n"){$0 + " [\"\($1.key)\"]: \($1.value),\n"}
        return result + "]"
    }
}

infix operator += : AssignmentPrecedence
public func +=(left: inout Character, right: Int) {
    if let value = left.asciiValue {
        left = Character(UnicodeScalar(value + UInt8(right)))
    }
}

class TreeNode: Hashable {
    static func == (lhs: TreeNode, rhs: TreeNode) -> Bool {
        let a = lhs.val == rhs.val
        let b = lhs.left == nil && rhs.left == nil || lhs.left == rhs.left
        let c = lhs.right == nil && rhs.right == nil || lhs.right == rhs.right
        return a && b && c
    }

    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        if left != nil {
            hasher.combine(left!)
        }
        if right != nil {
            hasher.combine(right)
        }
    }

}

class BSTIterator {

    var queue: [Int] = []

    init(_ root: TreeNode?) {
        traverse(root)
    }

    private func traverse(_ root: TreeNode?) {
        guard let root = root else {
            return
        }
        traverse(root.left)

        queue.append(root.val)

        traverse(root.right)
    }

    /** @return the next smallest number */
    func next() -> Int {
        return queue.removeFirst()
    }

    /** @return whether we have a next smallest number */
    func hasNext() -> Bool {
        return queue.count > 0
    }
}

class Node: Hashable {
    public var val: Int
    public var next: Node?
    public var random: Node?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
        self.random = nil
    }

    static func == (lhs: Node, rhs: Node) -> Bool {
        let a = lhs.val == rhs.val
        let b = lhs.next == nil && rhs.next == nil || lhs.next == rhs.next
        let c = lhs.random == nil && rhs.random == nil || lhs.random == rhs.random
        return a && b && c
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(val)
        if next != nil {
            hasher.combine(next!)
        }
        if random != nil {
            hasher.combine(random!)
        }
    }
}

//class Codec {
//    // Encodes a tree to a single string.
//    func serialize(_ root: TreeNode?) -> String {
//
//    }
//
//    // Decodes your encoded data to tree.
//    func deserialize(_ data: String) -> TreeNode? {
//
//    }
//}

// This is the interface that allows for creating nested lists.
// You should not implement it, or speculate about its implementation
protocol NestedInteger {
    // Return true if this NestedInteger holds a single integer, rather than a nested list.
    func isInteger() -> Bool

    // Return the single integer that this NestedInteger holds, if it holds a single integer
    // The result is undefined if this NestedInteger holds a nested list
    func getInteger() -> Int

    // Set this NestedInteger to hold a single integer.
    func setInteger(value: Int)

    // Set this NestedInteger to hold a nested list and adds a nested integer to it.
    func add(elem: NestedInteger)

    // Return the nested list that this NestedInteger holds, if it holds a nested list
    // The result is undefined if this NestedInteger holds a single integer
    func getList() -> [NestedInteger]
}

class Solution {

    func leastInterval(_ tasks: [Character], _ n: Int) -> Int {
        let taskDict = tasks.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        var taskArray = taskDict.map { ($0.value) }

        var time = 0
        while taskArray.count > 0 {
            taskArray = taskArray.sorted().reversed()
            print("tasks: \(taskArray)")
            var i = 0
            while i <= n {
                time += 1
                if i < taskArray.count {
                    taskArray[i] -= 1
                    if taskArray[0] == 0 {
                        break
                    }
                }
                i += 1
            }
            taskArray = taskArray.filter { $0 != 0 }
        }
        return time
    }

    func merge(_ intervals: [[Int]]) -> [[Int]] {
        if intervals.count <= 1 { return intervals }
        let sortedIntervals = intervals.sorted { $0[0] < $1[0] }
        var mergedIntervals = [sortedIntervals[0]]
        for i in 1..<sortedIntervals.count {
            var last = mergedIntervals[mergedIntervals.count - 1]
            let toMerge = sortedIntervals[i]
            if last[1] >= toMerge[0] {
                last[1] = max(last[1], toMerge[1])
                mergedIntervals[mergedIntervals.count - 1] = last
            } else {
                mergedIntervals.append(toMerge)
            }
        }
        return mergedIntervals
    }

    func intersect(_ nums1: [Int], _ nums2: [Int]) -> [Int] {
        let sortedNums1 = nums1.sorted()
        let sortedNums2 = nums2.sorted()
        var (index1, index2) = (0, 0)
        var result = [Int]()
        while index1 < sortedNums1.count && index2 < sortedNums2.count {
            if sortedNums1[index1] == sortedNums2[index2] {
                result.append(sortedNums1[index1])
                index1 += 1
                index2 += 1
            } else if sortedNums1[index1] < sortedNums2[index2] {
                index1 += 1
            } else {
                index2 += 1
            }
        }
        return result
    }

    func threeSum(_ nums: [Int]) -> [[Int]] {
        if nums.count < 3 { return [] }
        let sorted = nums.sorted()
        var result = [[Int]]()
        for i in 0..<sorted.count - 2 {
            if i > 0 && sorted[i] == sorted[i - 1] {
                continue
            }
            let twoSumResult = twoSum(sorted[i + 1..<sorted.count], -sorted[i])
            result.append(contentsOf: twoSumResult.map { [sorted[i], $0[0], $0[1]] })
        }
        return result
    }

    private func twoSum(_ nums: ArraySlice<Int>, _ target: Int) -> [[Int]] {
        let sorted = nums.sorted()
        var result = [[Int]]()
        var (left, right) = (0, sorted.count - 1)
        while left < right {
            let (leftN, rightN) = (sorted[left], sorted[right])
            let sum = leftN + rightN
            if sum == target {
                result.append([leftN, rightN])
                repeat {
                    left += 1
                } while left < right && sorted[left] == sorted[left - 1]
                repeat {
                    right -= 1
                } while left < right && sorted[right] == sorted[right + 1]
            } else if sum > target {
                right -= 1
            } else {
                left += 1
            }
        }
        return result
    }

    func isMatch(_ s: String, _ p: String) -> Bool {
        print("s:\(s), p:\(p)")
        if s.isEmpty {
            return p.isEmpty
                || (p.count > 1 && p[1] == "*"
                    && isMatch(s, String(p[p.index(p.startIndex, offsetBy: 2)...])))
        }

        if p.isEmpty {
            return false
        }

        let (a, b) = (s[0], p[0])
        let sSub = String(s[s.index(s.startIndex, offsetBy: 1)...])
        let pSub = String(p[p.index(p.startIndex, offsetBy: 1)...])
        let isMatched = a == b || b == "."

        if pSub.count > 0 && pSub[0] == "*" {
            return
                (p.count > 1 && isMatch(s, String(p[p.index(p.startIndex, offsetBy: 2)...]))
                || isMatched && isMatch(sSub, p))
        } else {
            return isMatched && isMatch(sSub, pSub)
        }
    }

    func findLengthOfLCIS(_ nums: [Int]) -> Int {
        guard nums.count > 1 else {
            return nums.count
        }
        var (maxSeq, seq) = (0, 1)
        for i in 1..<nums.count {
            if nums[i] > nums[i - 1] {
                seq += 1
            } else {
                maxSeq = max(maxSeq, seq)
                seq = 1
            }
        }
        maxSeq = max(maxSeq, seq)

        return maxSeq
    }

    func maxProfit(_ prices: [Int]) -> Int {
        guard prices.count > 1 else {
            return 0
        }
        var (profit, minPrice) = (0, prices[0])
        for i in 1..<prices.count {
            minPrice = min(prices[i], minPrice)
            profit = max(profit, prices[i] - minPrice)
        }

        return profit
    }

    func verticalOrder(_ root: TreeNode?) -> [[Int]] {
        guard let root = root else {
            return []
        }

        var queue = [(node: root, index: 0)]
        var (rangeLeft, rangeRight) = (0, 0)
        var dict = [0: [root.val]]

        while queue.count > 0 {
            let column = queue.removeFirst()
            let node = column.node
            let index = column.index
            if let left = node.left {
                if dict[index - 1] == nil {
                    rangeLeft -= 1
                    dict[index - 1] = [left.val]
                } else {
                    dict[index - 1]?.append(left.val)
                }
                queue.append((node: left, index: index - 1))
            }

            if let right = node.right {
                if dict[index + 1] == nil {
                    rangeRight += 1
                    dict[index + 1] = [right.val]
                } else {
                    dict[index + 1]?.append(right.val)
                }
                queue.append((node: right, index: index + 1))
            }
        }

        return (rangeLeft...rangeRight).map { dict[$0]! }

    }

    func binaryTreePaths(_ root: TreeNode?) -> [String] {
        guard let root = root else {
            return []
        }

        var result = [String]()
        binaryTreePathsHelper(root, &result, "")
        return result

    }

    func binaryTreePathsHelper(_ root: TreeNode, _ result: inout [String], _ temp: String) {
        if root.left == nil && root.right == nil {
            if temp.isEmpty {
                result.append("\(root.val)")
            } else {
                result.append("\(temp)->\(root.val)")
            }

            return
        }

        let cur = temp.isEmpty ? "\(root.val)" : "->\(root.val)"

        if let left = root.left {
            binaryTreePathsHelper(left, &result, temp + cur)
        }
        if let right = root.right {
            binaryTreePathsHelper(right, &result, temp + cur)
        }
    }

    func trap(_ height: [Int]) -> Int {
        if height.count < 3 {
            return 0
        }

        var leftIter = Array(repeating: 0, count: height.count)
        var rightIter = Array(repeating: 0, count: height.count)

        var maxBar = height[0]
        for i in 1..<height.count - 1 {
            leftIter[i] = max(maxBar, height[i - 1])
            maxBar = max(maxBar, height[i - 1])
        }
        maxBar = height[height.count - 1]
        for i in stride(from: height.count - 2, to: 0, by: -1) {
            rightIter[i] = max(maxBar, height[i + 1])
            maxBar = max(maxBar, height[i])
        }

        //        print(" left: \(leftIter)")
        //        print("right: \(rightIter)")
        var total = 0
        for i in 0..<height.count {
            if height[i] < min(leftIter[i], rightIter[i]) {
                total += min(leftIter[i], rightIter[i]) - height[i]
            }
        }
        return total
    }

    func reverseWords(_ s: String) -> String {
        let rs = String(s.trimmingCharacters(in: .whitespaces).reversed()).components(
            separatedBy: .whitespaces
        ).filter({ !$0.isEmpty })

        return rs.reduce(into: "") { result, st in
            print(st)
            result += (result.isEmpty ? "" : " ") + st.reversed()
        }
    }
    //
    //    func multiply(_ num1: String, _ num2: String) -> String {
    //        if num1 == "0" || num2 == "0" {
    //            return "0"
    //        }
    //
    //
    //
    //    }
    //
    //    func multiply(_ n: String, _ m: Character) -> String {
    //        if m == "0" {
    //            return "0"
    //        }
    //
    //        let multipler = Int(String(m))!
    //        var product = 0
    //        for i in 0..<n.count {
    //            let temp = Int(String(n[i]))! * multipler
    //            product = product*10 + temp
    //        }
    //        return product
    //    }

    //    func numberToWords(_ num: Int) -> String {
    //        let numDict = [0: "zero", 1: "One", 2: "Two", 3: "Three", 4: "Four", 5: "Five", 6: "Six", 7: "Seven", 8: "Eight", 9: "Nine", 10: "Ten", 11: "Eleven", 12: "Twelve", 13: "thirteen", 14: "fourteen", 15: "fifteen", 16: "sixteen", 17: "seventeen", 18: "eighteen", 19: "ninteen", 20: "twenty", 30: "thirty", 40: "forty", 50: "fifty", 60: "sixty", 70: "seventy", 80: "eighty", 90: "ninty", 100: "hundred", ]
    //        if num < 13 {
    //            return numDict[num]!
    //        } else if num < 20 {
    //            return numDict[num]! + "teen"
    //        } else if num < 100 {
    //            let suffix = num%10 == 0 ? "" : numDict[num%10]
    //            let prefix =
    //        }
    //
    //    }

    func numDecodings(_ s: String) -> Int {
        if s.isEmpty || s == "0" { return 0 }
        if s.count == 1 { return 1 }

        var dp = [1, 1]

        for i in 1..<s.count {
            let twoDigit = Int(s[i - 1...i])!
            if s[i] == "0" {
                dp.append(twoDigit <= 26 ? dp[i - 1] : 0)
            }
            dp.append(twoDigit <= 26 ? dp[i] + dp[i - 1] : dp[i])
        }

        return dp[dp.count - 1]
    }

    func copyRandomList(_ head: Node?) -> Node? {
        guard let head = head else { return nil }

        var dict: [Node: Node] = [:]
        var originalNext: Node? = head
        while originalNext != nil {
            dict[originalNext!] = Node(originalNext!.val)
            originalNext = originalNext!.next
        }

        dict.forEach { originalNode, newNode in
            if let next = originalNode.next {
                newNode.next = dict[next]
            }
            if let random = originalNode.random {
                newNode.random = dict[random]
            }
        }

        return dict[head]
    }

    func moveZeroes(_ nums: inout [Int]) {
        var cur = 0
        while cur < nums.count {
            if nums[cur] != 0 { continue }
            var findNonZeroCur = cur + 1
            while findNonZeroCur < nums.count && nums[findNonZeroCur] == 0 {
                findNonZeroCur += 1
            }
            if findNonZeroCur < nums.count {
                swap(&nums, cur, findNonZeroCur)
            }
            cur += 1
        }
    }

    private func swap(_ nums: inout [Int], _ a: Int, _ b: Int) {
        let temp = nums[a]
        nums[a] = nums[b]
        nums[b] = temp
    }

    func minMeetingRooms(_ intervals: [[Int]]) -> Int {
        guard intervals.count > 0 else {
            return 0
        }

        let starts = intervals.map { $0[0] }.sorted()
        let ends = intervals.map { $0[1] }.sorted()

        var (total, endCur) = (0, 0)
        for i in 0..<intervals.count {
            if starts[i] < ends[endCur] {
                total += 1
            } else {
                endCur += 1
            }
        }

        return total
    }

    private func swapAll(_ nums: inout [Int], _ a: Int, _ b: Int) {
        var (aa, bb) = (a, b)
        while aa < bb && aa >= 0 && bb < nums.count {
            defer {
                aa += 1
                bb -= 1
            }

            let temp = nums[aa]
            nums[aa] = nums[bb]
            nums[bb] = temp
        }
    }

    /*
     1 2 3 4 5
     1 2 3 5 4
     1 2 4 3 5
     1 2 4 5 3
     */
    /*
     1 2 3
     1 3 2
     2 1 3
     2 3 1
     3 1 2
     3 2 1
     */
    /*
     1 1 2
     1 2 1
     2 1 1
     1 1 2
     */

    func nextPermutation(_ nums: inout [Int]) {
        guard nums.count > 1 else {
            return
        }

        var pivotPoint = nums.count - 2
        while pivotPoint >= 0 {
            if nums[pivotPoint] < nums[pivotPoint + 1] {
                break
            }
            pivotPoint -= 1
        }

        if pivotPoint < 0 {
            swapAll(&nums, 0, nums.count - 1)
            return
        }

        var toSwapPoint = pivotPoint + 1
        while toSwapPoint < nums.count && nums[toSwapPoint] > nums[pivotPoint] {
            toSwapPoint += 1
        }
        toSwapPoint -= 1

        swap(&nums, pivotPoint, toSwapPoint)

        swapAll(&nums, pivotPoint + 1, nums.count - 1)
    }

    func groupAnagrams(_ strs: [String]) -> [[String]] {

        //V1
        let sorted = strs.map { String($0.sorted()) }
        var map = [String: [String]]()
        for i in 0..<sorted.count {
            map[sorted[i], default: []].append(strs[i])
        }

        return map.map { $0.value }
    }

    func depthSum(_ nestedList: [NestedInteger]) -> Int {
        return depthSum(nestedList, depth: 0)
    }

    func depthSum(_ nestedList: [NestedInteger], depth: Int) -> Int {
        var sum = 0
        for nestedInt in nestedList {
            if nestedInt.isInteger() {
                sum += nestedInt.getInteger() * (depth + 1)
            } else {
                sum += depthSum(nestedInt.getList(), depth: depth + 1)
            }
        }
        return sum
    }

    func divide(_ dividend: Int, _ divisor: Int) -> Int {
        if dividend == -2_147_483_648 && divisor == -1 {
            return 2_147_483_647
        }
        var (vDividend, vDivisor) = (dividend, divisor)
        var neg = 0
        if dividend < 0 {
            neg += 1
            vDividend = -dividend
        }
        if divisor < 0 {
            neg += 1
            vDivisor = -divisor
        }

        if vDividend < vDivisor {
            return 0
        } else {
            var (power, value) = (0, divisor)
            while value + value < vDividend {
                power += 1
                value += value
            }
            return (neg == 1 ? -1 : 1)
                * (Int(truncating: NSDecimalNumber(decimal: pow(Decimal(2), power)))
                    + divide(vDividend - value, vDivisor))
        }
    }
    /*
     Input: "()())()"
     Output: ["()()()", "(())()"]
     s
     Input: "(a)())()"
     Output: ["(a)()()", "(a())()"]
     
     Input: ")("
     Output: [""]
     */
    func removeInvalidParentheses(_ s: String) -> [String] {
        if s.count < 2 {
            return []
        }

        var dp: [[[String]]] = Array(
            repeating: Array(repeating: [""], count: s.count), count: s.count)
        for i in 0..<s.count {
            for j in 1..<s.count {
                if i < j {
                    if s[j] == "(" {
                        dp[i][j] = dp[i][j - 1]
                    }

                    if i + 1 == j && s[i] == "(" {
                        dp[i][j].append("()")
                    }
                }
            }
        }

        return dp[0][s.count - 1]
    }

    /*
     For example, given the following tree:

         1
        / \
       2   5
      / \   \
     3   4   6
     The flattened tree should look like:

     1
      \
       2
        \
         3
          \
           4
            \
             5
              \
               6
     */

    func flatten(_ root: TreeNode?) {
        _ = flattenHelper(root)
    }

    func flattenHelper(_ root: TreeNode?) -> TreeNode? {
        guard let root = root else { return nil }

        let tempRight = root.right
        if let flattenedLeft = flattenHelper(root.left) {
            var tail: TreeNode = flattenedLeft
            while tail.right != nil { tail = tail.right! }
            root.right = flattenedLeft
            root.left = nil
            tail.right = tempRight
        }

        _ = flattenHelper(tempRight)

        return root
    }

    func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
        if nums.count < 2 { return [] }
        let map = nums.enumerated().reduce(into: [Int: [Int]]()) {
            $0[$1.1, default: []].append($1.0)
        }
        print(map)
        for (k, v) in map {
            guard v.count > 0 else { continue }
            if k + k == target {
                if v.count >= 2 {
                    return [Int](v[0..<2])
                }
            } else if map[target - k] != nil && map[target - k]!.count > 0 {
                return [v[0], map[target - k]![0]]
            }
        }
        return []
    }

    func isValidBST(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        return isValidBSTHelper(root).0
    }

    func isValidBSTHelper(_ root: TreeNode) -> (balenced: Bool, min: Int?, max: Int?) {
        var result: (balenced: Bool, min: Int?, max: Int?) = (true, nil, nil)
        if let left = root.left {
            let leftResult = isValidBSTHelper(left)
            guard leftResult.0,
                let min = leftResult.1,
                let max = leftResult.2,
                root.val > max
            else { return (false, nil, nil) }
            result.1 = min
        } else {
            result.1 = root.val
        }

        if let right = root.right {
            let rightResult = isValidBSTHelper(right)
            guard rightResult.0,
                let max = rightResult.2,
                let min = rightResult.1,
                root.val < min
            else { return (false, nil, nil) }
            result.2 = max
        } else {
            result.2 = root.val
        }

        return result
    }

    func longestSubstring(_ s: String, _ k: Int) -> Int {
        let countMap: [Character: Int] = s.reduce(into: [Character: Int]()) {
            $0[$1, default: 0] += 1
        }
        print(countMap)
        var movingMap: [Character: Int] = [:]
        var (maxCount, start) = (0, 0)
        for i in 0..<s.count {
            let char = s[i]
            if let count = countMap[char], count >= k {
                movingMap[char, default: 0] += 1

                if movingMap[char]! >= k {

                    var movingMapCopy = movingMap  //Copy
                    var tempStart = start
                    for j in start...i {
                        print("Moving map copy:\(movingMapCopy)")
                        let tempChar = s[j]
                        if movingMapCopy[tempChar] == nil || movingMapCopy[tempChar]! < k {
                            for k in tempStart...j {
                                movingMapCopy[s[k], default: 0] -= 1
                            }
                            tempStart = j + 1
                        }
                        print("start: \(tempStart)")
                    }
                    if movingMapCopy[char, default: 0] < k {
                        continue
                    }

                    maxCount = max(maxCount, i - tempStart + 1)
                }
            } else {
                print("clear")
                start = i + 1
                movingMap.removeAll()
            }
        }
        return maxCount
    }

    func getPermutation(_ n: Int, _ k: Int) -> String {
        var list = (1...n).map { String($0) }
        var kk = k - 1
        var result = ""
        for i in stride(from: n - 1, through: 1, by: -1) {
            let index = kk / getFactory(i)
            print(index)
            result += list[index]
            list.remove(at: index)
            kk = kk % getFactory(i)

        }
        result += list.removeFirst()
        return result
    }

    func getFactory(_ n: Int) -> Int {
        return (1...n).reduce(1) { $0 * $1 }
    }

    func isAnagram(_ s: String, _ t: String) -> Bool {
        if s.count != t.count { return false }
        let sMap = s.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        let tMap = t.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        for (k, v) in sMap {
            if tMap[k] == nil || tMap[k] != v {
                return false
            }
        }
        return true
    }

    /*
     Input: s = "leetcode", wordDict = ["leet", "code"]
     Output: true
     Explanation: Return true because "leetcode" can be segmented as "leet code".
     
     Input: s = "applepenapple", wordDict = ["apple", "pen"]
     Output: true
     Explanation: Return true because "applepenapple" can be segmented as "apple pen apple".
                  Note that you are allowed to reuse a dictionary word.
     
     Input: s = "catsandog", wordDict = ["cats", "dog", "sand", "and", "cat"]
     Output: false
     */
    func wordBreak(_ s: String, _ wordDict: [String]) -> Bool {
        guard s.count > 0 else { return true }
        let wordSet = Set(wordDict)
        var dp = Array(repeating: false, count: s.count + 1)
        dp[0] = true
        for i in 0..<s.count {
            for j in stride(from: i, through: 0, by: -1) {
                if wordSet.contains(s[j...i]), dp[j] {
                    dp[i + 1] = true
                }
            }
        }
        return dp[s.count]
    }

    /*
     Input:nums = [1,1,1], k = 2
     Output: 2
     
     Input:nums = [1,2,1,2,1], k = 3
     1, 1, 1, 2, 2
     Output: 4
     */

    func subarraySum(_ nums: [Int], _ k: Int) -> Int {
        if nums.count == 0 { return (k == 0 ? 1 : 0) }
        var total = 0
        for i in 0..<nums.count {
            var sum = 0
            for end in i..<nums.count {
                sum += nums[end]
                print("sum: \(sum)")
                if sum == k { total += 1 }
            }
        }

        return total
    }

    /*
     matrix = [
        [ 1,  5,  9, 10],
        [ 2,  7, 12，13],
        [ 6, 14, 15，16]，
        [13, 15, 16，17]
     ],
     k = 8,

     return 13.
     */

    //    func kthSmallest(_ matrix: [[Int]], _ k: Int) -> Int {
    //        guard matrix.count > 0, k < matrix[0] else { return 0 }
    //        guard matrix.count > 1 else { return matrix[0][k] }
    //        let (width, length) = (matrix[0].count, matrix.count)
    //        var (curRow, curCol) = (0, 0)
    //        var kk = k
    //        while k>1 {
    //            defer { k -= 1 }
    //            if curRow == length - 1 {
    //                return matrix[curRow][curCol + k - 1]
    //            }
    //
    //            if curCol == width - 1 {
    //                curRow += 1
    //                curCol = 0
    //            }
    //        }
    //
    //        return matrix[curRow][curCol]
    //    }

    /*
     1, 2, 4, 8, 9, 10, 15
     2, 3, 3, 5, 7, 16, 16, 19
     
     nums1 = [1, 3]
     nums2 = [2]

     The median is 2.0
     
     nums1 = [1, 2]
     nums2 = [3, 4]

     The median is (2 + 3)/2 = 2.5
     */

    func findMedianSortedArrays(_ nums1: [Int], _ nums2: [Int]) -> Double {
        let total = nums1.count + nums2.count

        if (total) % 2 == 0 {
            return
                (findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1) / 2)
                + findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1) / 2 + 1)) / 2.0
        } else {
            return findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1) / 2)
        }

    }

    func findKthInSortedArrays(_ nums1: [Int], _ s1: Int, _ nums2: [Int], _ s2: Int, _ n: Int)
        -> Double
    {
        if s1 >= nums1.count {
            return Double(nums2[s2 + n - 1])
        }
        if s2 >= nums2.count {
            return Double(nums1[s1 + n - 1])
        }

        if n == 1 { return Double(min(nums1[s1], nums2[s2])) }

        let m = n / 2
        if m > nums1.count {
            if nums1[nums1.count - 1] <= nums2[s2 + n - nums1.count - 1] {
                return Double(nums2[s2 + n - nums1.count - 1])
            } else {
                return findKthInSortedArrays(nums1, s1, nums2, s2 + n - nums1.count, nums1.count)
            }
        }
        if m > nums2.count {
            if nums2[nums2.count - 1] <= nums1[s1 + n - nums2.count - 1] {
                return Double(nums1[s1 + n - nums2.count - 1])
            } else {
                return findKthInSortedArrays(nums1, s1 + n - nums2.count, nums2, s2, nums2.count)
            }
        }

        if nums1[s1 + m - 1] <= nums2[s2 + m - 1] {
            return findKthInSortedArrays(nums1, s1 + m, nums2, s2, n - m)
        } else {
            return findKthInSortedArrays(nums1, s1, nums2, s2 + m, n - m)
        }
    }

    func letterCombinations(_ digits: String) -> [String] {
        let keypad: [Character: String] = [
            "2": "abc",
            "3": "def",
            "4": "ghi",
            "5": "jkl",
            "6": "mno",
            "7": "pqrs",
            "8": "tuv",
            "9": "wxyz",
        ]
        if digits.count == 0 { return [] }
        var result = keypad[digits[0]]?.map { String($0) } ?? []
        for i in 1..<digits.count {
            guard let letters = keypad[digits[i]] else { continue }
            let resultCopy = result
            result.removeAll()
            for l1 in resultCopy {
                for l2 in letters {
                    result.append("\(l1)\(l2)")
                }
            }
        }
        return result
    }

    /*
    Example 1:
        Input: s1 = "ab" s2 = "eidbaooo"
        Output: True
        Explanation: s2 contains one permutation of s1 ("ba").

    Example 2:
        Input:s1= "ab" s2 = "eidboaoo"
        Output: False
    */
    func checkInclusion(_ s: String, _ t: String) -> Bool {
        if s.count == 0 { return true }
        if t.count < s.count { return false }

        let sMap = s.reduce(into: [Character: Int]()) { $0[$1, default: 0] += 1 }
        var movingMap: [Character: Int] = [:]
        var unCheckedChar = Set(sMap.map { $0.key })
        var start = 0
        for i in 0..<t.count {
            let c = t[i]
            print("current: \(c)")
            if sMap[c] != nil {
                movingMap[c, default: 0] += 1
                if movingMap[c, default: 0] == sMap[c, default: 0] {
                    unCheckedChar.remove(c)
                }
                // } else if movingMap[c, default: 0] > sMap[c, default: 0] {
                //     while movingMap[c, default: 0] > sMap[c, default: 0] {
                //         let toRemove = t[start]
                //         movingMap[toRemove, default: 0] -= 1
                //         if movingMap[toRemove, default: 0] == 0 {
                //             unCheckedChar.insert(toRemove)
                //         }
                //         start += 1
                //     }
                // }
            }
            if i - start + 1 == s.count {
                print("checking")
                if unCheckedChar.count == 0 {
                    return true
                } else {
                    if movingMap[t[start]] != nil {
                        movingMap[t[start]]! -= 1
                        if movingMap[t[start]]! < sMap[t[start], default: 0] {
                            unCheckedChar.insert(t[start])
                        }
                    }
                    start += 1
                }
            }
            print("unCheckedChar:\(unCheckedChar)")
            print("movingMap:\(movingMap)")
            print("\n")
        }
        return false
    }

    /*
    Example 1:

        Input: "babad"
        Output: "bab"
        Note: "aba" is also a valid answer.
    
    Example 2:

        Input: "cbbd"
        Output: "bb"
    */

    func longestPalindrome(_ s: String) -> String {
        if s.count == 0 || s.count == 1 { return s }
        var result = String(s[0])
        var dp = Array(repeating: Array(repeating: false, count: s.count), count: s.count)
        (0..<s.count).forEach { dp[$0][$0] = true }
        for length in 2...s.count {
            for i in 0...s.count - length {
                let (sc, ec) = (s[i], s[i + length - 1])
                if sc == ec && (length == 2 || dp[i + 1][i + length - 2]) {
                    dp[i][i + length - 1] = true
                    result = s[i..<i + length]
                }
            }
        }

        return result
    }

    /*
    Input:
    n = 2
    logs = ["0:start:0","1:start:2","1:end:5","0:end:6"]
    Output: [3, 4]
    Explanation:
    Function 0 starts at the beginning of time 0, then it executes 2 units of time and reaches the end of time 1.
    Now function 1 starts at the beginning of time 2, executes 4 units of time and ends at time 5.
    Function 0 is running again at the beginning of time 6, and also ends at the end of time 6, thus executing for 1 unit of time. 
So  function 0 spends 2 + 1 = 3 units of total time executing, and function 1 spends 4 units of total time executing.   
    */
    func exclusiveTime(_ n: Int, _ logs: [String]) -> [Int] {
        //Atmpt 1
        // var map: [Int: (start: Int?, duration: Int)] = [:]
        // var lastId: Int?
        // var lastTimestamp = 0
        // var lastStatus: String?
        // for i in 0..<logs.count {
        //     let log = logs[i]
        //     let segs = log.components(separatedBy: ":")
        //     guard segs.count == 3 else { continue }
        //     let (id, status, timestamp) = (Int(segs[0])!, segs[1], Int(segs[2])!)
        //     if status == "start" {
        //         if let lastId = lastId {
        //         map[lastId, default: (nil, 0)].duration +=
        //             timestamp - (map[lastId]?.start ?? lastTimestamp)
        //         }
        //         map[id] = (timestamp, 0)
        //     } else {
        //         print("""
        //         lastTimestamp: \(lastTimestamp)
        //         """)
        //         map[id, default: (nil, 0)].duration += timestamp - lastTimestamp + (lastStatus == "end" ? 0 : 1)
        //     }
        //     lastId = id
        //     lastTimestamp = timestamp
        //     lastStatus = status
        //     print("""
        //         id: \(id)
        //         status: \(status)
        //         timestamp: \(timestamp)
        //         map: \(map)
        //         """)
        //     }
        //     return (map.map { $0.value.duration }).sorted()
        //Atmpt 2
        var funcQueue: [(id: Int, start: Int, duration: Int)] = []
        var result: [Int: Int] = [:]
        // var lastId: Int? = nil 
        var lastStatus: String? = nil 
        var lastTimestamp: Int = 0
        for i in 0..<logs.count {
            let log = logs[i]
            let segs = log.components(separatedBy: ":")
            guard segs.count == 3 else { continue }
            let (id, status, timestamp) = (Int(segs[0])!, segs[1], Int(segs[2])!)
            if status == "start" {
                if funcQueue.last != nil {
                    funcQueue[funcQueue.count - 1].duration += timestamp - lastTimestamp - (lastStatus == "end" ? 1 : 0)
                }
                funcQueue.append((id: id, start: timestamp, duration: 0))
            } else {
                if let lastFunc = funcQueue.popLast() {
                    if id == lastFunc.id {
                        result[id, default: 0] += timestamp - lastTimestamp + lastFunc.duration + (lastStatus == "end" ? 0 : 1)
                    }
                }
            }
            // lastId = id
            lastStatus = status
            lastTimestamp = timestamp
            // print("""
            // queue: \(funcQueue)
            // id: \(id)
            // status: \(status)
            // timestamp: \(timestamp)
            // result: \(result)

            // """)
        }
        return (Array(result).sorted{return $0.key < $1.key}).map{$0.value}
    }

    func romanToInt(_ s: String) -> Int {
        guard s.count > 0 else { return 0 }
        let dict: [Character: Int] = ["I": 1, "V": 5, "X": 10, "L": 50, "C": 100, "D": 500, "M": 1000]
        var num = dict[s[s.count - 1], default: 0]
        for i in stride(from: s.count - 2, through: 0, by: -1) {
            guard dict[s[i]] != nil && dict[s[i+1]] != nil else { continue }
            let (cur, latter) = (dict[s[i]]!, dict[s[i+1]]!)
            if cur < latter {
                num -= cur
            } else {
                num += cur
            }
        }
        return num
    }

    func intToRoman(_ num: Int) -> String {
        let mappingArray = [(1000, "M"), (900, "CM"), (500, "D"), (400, "CD"), (100, "C"), (90, "XC"), (50, "L"), (40, "XL"), (10, "X"), (9, "IX"), (5, "V"), (4, "IV"), (1, "I")]
        var (point, vNum) = (0, num)
        var roman = ""
        while vNum > 0 {
            while mappingArray[point].0 > vNum { point += 1}
            roman += mappingArray[point].1
            vNum -= mappingArray[point].0
        }
        return roman
    }

    func isMatchWildCard(_ s: String, _ p: String) -> Bool {
        // var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: p.count), count: s.count)

        return false
    }

    func isScramble(_ s1: String, _ s2: String) -> Bool {
        return isScrambleHelper(s1, s2)
    }

    func isScrambleHelper(_ s1: String, _ s2: String) -> Bool {
        print("s1: \(s1), s2: \(s2)")
        if s1.count != s2.count { return false }
        if s1 == s2 { return true }
        for i in 0..<s1.count-1 {
            print("i: \(i)")
            if String(s1[0...i].sorted()) == String(s2[0...i].sorted()) {
                print("left - left")
                let leftResult = isScrambleHelper(s1[0...i], s2[0...i])
                let rightResult = isScrambleHelper(s1[i+1..<s1.count], s2[i+1..<s2.count])
                if leftResult && rightResult { return true }
            }

            if String(s1[0...i].sorted()) == String(s2[s2.count-i-1...s2.count-1].sorted()) {
                print("left - right")
                let leftResult = isScrambleHelper(s1[0...i], s2[s2.count-i-1...s2.count-1])
                let rightResult = isScrambleHelper(s1[i+1..<s1.count], s2[0..<s1.count-1-i])
                if leftResult && rightResult { return true }
            }
        }
        return false
    }

    func validPalindrome(_ str: String) -> Bool {
        var (s, e) = (0, str.count-1)
        while s < e {
            // print("s: \(str[s]), e: \(str[e])")
            if str[s] != str[e] {
                return isPalindrome(str, s + 1, e) || isPalindrome(str, s, e - 1)
            }
            s += 1
            e -= 1
        }    
        return true
    }
    func isPalindrome(_ str: String, _ start: Int, _ end: Int) -> Bool {
        var (s, e) = (start, end)
        while s < e {
            if str[s] != str[e] {
                return false
            }
            s += 1
            e -= 1
        }
        return true
    }

    func lengthOfLongestSubstring(_ s: String) -> Int {
        guard s.count > 0 else { return 0 }
        var letterSet: Set<Character> = []
        var left = 0
        var maxLen = 0
        for (i, c) in s.enumerated() {
            if letterSet.contains(c) {
                while letterSet.contains(c) {
                    let toRemove = s[left]
                    letterSet.remove(toRemove)
                    left += 1
                }
            }
            letterSet.insert(c)
            maxLen = max(i - left + 1, maxLen)
        }

        return maxLen
    }

    func lengthOfLongestSubstringTwoDistinct(_ s: String) -> Int {
        guard s.count > 0 else { return 0 }
        var maxLen = 0
        var left = 0
        var map: [Character: Int] = [:]
        for (i,c) in s.enumerated() {
            if map.count == 2 && map[c] == nil {
                while map.count == 2 {
                    map[s[left]]! -= 1
                    if map[s[left]]! == 0 {
                        map.removeValue(forKey: s[left])
                    }
                    left += 1
                }
            }
            map[c, default: 0] += 1
            maxLen = max(maxLen, i - left + 1)
        }
        return maxLen
    }

    func lengthOfLongestSubstringKDistinct(_ s: String, _ k: Int) -> Int {
        guard s.count > 0, k > 0 else { return 0 }
        var maxLen = 0
        var left = 0
        var map: [Character: Int] = [:]
        for (i,c) in s.enumerated() {
            if map.count == k && map[c] == nil {
                while map.count == k {
                    map[s[left]]! -= 1
                    if map[s[left]]! == 0 {
                        map.removeValue(forKey: s[left])
                    }
                    left += 1
                }
            }
            map[c, default: 0] += 1
            maxLen = max(maxLen, i - left + 1)
        }
        return maxLen
    }

    /*
    Input:
    beginWord = "hit",
    endWord = "cog",
    wordList = ["hot","dot","dog","lot","log","cog"]

    Output: 5

    Explanation: As one shortest transformation is "hit" -> "hot" -> "dot" -> "dog" -> "cog",
    return its length 5.

    Input:
    beginWord = "hit"
    endWord = "cog"
    wordList = ["hot","dot","dog","lot","log"]
    */

    class WordNode: CustomStringConvertible {
        var word: String
        var nextWord: [WordNode] = []
        init(_ word: String) {
            self.word = word
        }
        
        var description: String {
            return descriptionArray.reduce(""){$0 + "\n\n" + $1}
        }

        var descriptionArray: [String] {
            if nextWord.count == 0 {
                return [word]
            }
            var result: [String] = []
            for node in nextWord {
                result.append(contentsOf: node.descriptionArray)
            }
            for (i, _) in result.enumerated() {
                if i == result.count/2 {
                    result[i] = word + " " + result[i]
                } else {
                    result[i] = String(repeating: " ", count: word.count + 1) + result[i]
                }
            }
            return result
        }

        var breadth: Int {
            if nextWord.count == 0 {
                return 1
            }
            var total = 0
            for node in nextWord {
                total += node.breadth + 1
            }
            return total
        }
    }

    func ladderLength(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> Int {
        let wordSet = Set(wordList)
        let letterSet = "abcdefghijklmnopqrstuvwxyz"
        let root = WordNode(beginWord)
        var set: Set<String> = [beginWord]
        var queue: [WordNode] = [root]
        while !queue.isEmpty {
            let wordNode = queue.removeFirst()
            print("word: \(wordNode.word)")
            for (i,_) in wordNode.word.enumerated() {
                for newCh in letterSet {
                    var temp = wordNode.word
                    temp.replace(i...i, with: String(newCh))
                    if wordSet.contains(temp) && (!set.contains(temp) || temp == endWord) {
                        print("temp: \(temp)")
                        let node = WordNode(temp)
                        wordNode.nextWord.append(node)
                        set.insert(temp)
                    }
                }
            }
            print("")
            queue.append(contentsOf: wordNode.nextWord.filter{$0.word != endWord})
        }

        return ladderShortestPath(root, endWord).0
    }

    func ladderShortestPath(_ rootNode: WordNode, _ endWord: String) -> (Int, Bool) {
        if rootNode.word == endWord { return (1, true) }
        var (shortest, validPath) = (Int.max, false)
        for node in rootNode.nextWord {
            let curPath = ladderShortestPath(node, endWord)
            if curPath.1 && curPath.0 < shortest {
                shortest = curPath.0
                validPath = true
            }
        }
        return ((validPath ? shortest + 1 : 0), validPath)
    }

    func findLadders(_ beginWord: String, _ endWord: String, _ wordList: [String]) -> [[String]] {
        let wordSet = Set(wordList)
        let letterSet = "abcdefghijklmnopqrstuvwxyz"
        let root = WordNode(beginWord)
        var set: Set<String> = [beginWord]
        var queue: [WordNode] = [root]
        while !queue.isEmpty {
            var tempSet: Set<String> = []
            let nodesCount = queue.count
            for _ in 0..<nodesCount {
                let wordNode = queue.removeFirst()
                for (i,_) in wordNode.word.enumerated() {
                    for newCh in letterSet {
                        var temp = wordNode.word
                        temp.replace(i...i, with: String(newCh))
                        if wordSet.contains(temp) && (!set.contains(temp) || temp == endWord) {
                            let node = WordNode(temp)
                            wordNode.nextWord.append(node)
                            tempSet.insert(temp)
                        }
                    }
                }
                queue.append(contentsOf: wordNode.nextWord.filter{$0.word != endWord})
            }
            tempSet.forEach{set.insert($0)}
        }
        print("root:\n\(root)")
        var result = [[String]]()
        ladderFindPaths(root, endWord, &result, [])
        let shortest = result.reduce(Int.max) {min($0, $1.count)}
        return result.filter{$0.count == shortest && $0[$0.count-1] == endWord}
    }

    func ladderFindPaths(_ rootNode: WordNode, _ endWord: String, _ result: inout [[String]], _ curPath: [String]) {
        if rootNode.word == endWord {
            result.append(curPath + [rootNode.word])
            return
        }

        for node in rootNode.nextWord {
            ladderFindPaths(node, endWord, &result, curPath + [rootNode.word])
        }
    }

    /*
    addWord("bad")
    addWord("dad")
    addWord("mad")
    search("pad") -> false
    search("bad") -> true
    search(".ad") -> true
    search("b..") -> true

    ["WordDictionary","addWord","addWord","search","search","search","search","search","search","search","search"]
    [              [],    ["a"],   ["ab"],   ["a"],  ["a."],  ["ab"],  [".a"],  [".b"], ["ab."],   ["."],  [".."]]
    [            null,    null,      null,   true,     true,    true,   false,    true,   false,    true,    true]]
    */

    class WordDictionary {
        class Node: CustomStringConvertible {
            var isWord: Bool = false
            var letter: Character
            var map: [Character: Node] = [:]
            init(_ l: Character) {
                self.letter = l
            }

            var description: String {
                return "[letter: \(letter), isWord: \(isWord)]"
            }
        }
        
        var root: Node
        /** Initialize your data structure here. */
        init() {
            self.root = Node(Character("*"))
        }
        
        /** Adds a word into the data structure. */
        func addWord(_ word: String) {
            guard word.count > 0 else { return }
            var node = root
            for (i,ch) in word.enumerated() {
                if node.map[ch] == nil {
                    node.map[ch] = Node(ch)
                }
                node = node.map[ch]!
                if i == word.count - 1 {
                    node.isWord = true
                }
            }
        }
        
        /** Returns if the word is in the data structure. A word could contain the dot character '.' to represent any one letter. */
        func search(_ word: String) -> Bool {
            guard word.count > 0 else { return true }
            for (_, value) in root.map {
                if search(word, value) {
                    return true
                }
            }
            return false
        }

        func search(_ word: String, _ root: Node?) -> Bool {
            guard let root = root else { return false } 
            let firstLetter = word[0]
            print(firstLetter)
            print(root.map)
            if firstLetter == root.letter || firstLetter == "." {
                if word.count == 1 {
                    return root.isWord
                }
                let secondLetter = word[1]
                if secondLetter == "." {
                    for (_, value) in root.map {
                        if search(word[1..<word.count], value) {
                            return true
                        }
                    }
                    return false
                } else {
                    return search(word[1..<word.count], root.map[word[1]])
                }
            } else {
                return false
            }
        }
    }

    enum SearchPosition {
        case start
        case end
    }

    func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
        return [searchRange(nums, target, .start),searchRange(nums, target, .end)]
    }

    func searchRange(_ nums: [Int], _ target: Int, _ searchPosition: SearchPosition) -> Int {
        if nums.isEmpty { return -1 }
        if nums.count == 1 { return (nums[0] == target ? 0 : -1) }
        var (start, end) = (0, nums.count-1)
        var find = -1
        while start <= end {
            let m = (start + end)/2
            if nums[m] == target {
                find = m
                if searchPosition == .start {
                    end = m-1
                } else {
                    start = m+1
                }
            } else if nums[m] < target {
                start = m+1
            } else {
                end = m-1
            }
        }
        return find
    }

    func minDepth(_ root: TreeNode?) -> Int {
        guard let root = root else { return Int.max }
        if root.left == nil && root.right == nil { return 1 }
        return  min(minDepth(root.left), minDepth(root.right)) + 1
    }

    class ListNode: CustomStringConvertible {
        var val: Int
        var next: ListNode?
        init() { self.val = 0; self.next = nil; }
        init(_ val: Int) { self.val = val; self.next = nil; }
        init(_ val: Int, _ next: ListNode?) { self.val = val; self.next = next; }
        init(_ valList: [Int]) {
            self.val = valList[0]
            if valList.count > 1 {
                self.next = ListNode(Array(valList[1..<valList.count]))
            }
        }

        var description: String {
            var result = String(val)
            if next != nil {
                result += "->" + (next?.description ?? "")
            }
            return result
        }
    }

    /*
    [[1,4,5],[1,3,4],[2,6]]
    */
    func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
        var listsCopy = lists
        let head = ListNode(0) //Dummy head
        var cur = head
        var hasElement = false
        repeat {
            hasElement = false
            var index = -1
            for i in 0..<listsCopy.count {
                if let temp = listsCopy[i] {
                    hasElement = true
                    if cur.next == nil || cur.next!.val > temp.val {
                        cur.next = temp 
                        index = i
                    }
                }
            }
            if cur.next != nil && index != -1 {
                listsCopy[index] = listsCopy[index]?.next
                cur = cur.next!
                cur.next = nil
            }
        } while hasElement
        return head.next
    }

    /*
    Example 1:
    Input: [10,2]
    Output: "210"

    Example 2:
    Input: [3,30,34,5,9]
    Output: "9534330"
    */

    func largestNumber(_ nums: [Int]) -> String {
        let sortedNums = nums.sorted { (a, b) -> Bool in
            let sum1 = String(a) + String(b)
            let sum2 = String(b) + String(a)
            return (Int(sum1) ?? Int.min) < (Int(sum2) ?? Int.min)
        }

        return sortedNums.reduce("") {String($0) + String($1)}
    }

    func groupStrings(_ strings: [String]) -> [[String]] {
        let map: [Int: [(String, String)]] = strings.reduce(into:[Int: [(String, String)]]()) {$0[$1.count, default: []].append(($1, encodeString($1)))}

        var result: [[String]] = []
        for (k, v) in map {
            if k == 0 || k == 1 {
                result.append(v.map{$0.0})
            } else {
                let cat = v.reduce(into:[String: [String]]()) {$0[$1.1, default: []].append($1.0)}
                result.append(contentsOf: cat.map{$0.value})
            }
        }
        return result
    }

    func encodeString(_ string: String) -> String {
        guard string.count > 1 else { return ""}
        var result = ""
        for i in 1..<string.count {
            if let pv = string[i-1].asciiValue,
                let cv = string[i].asciiValue {
                    let diff = Int(cv) - Int(pv) + (cv < pv ? 26 : 0)
                    result += String(diff)
                }
        }
        return result
    }

    /*
    Example 1:

    Input: [1,2,3]

        1
        / \
        2   3

    Output: 6
    Example 2:

    Input: [-10,9,20,null,null,15,7]

    -10
    / \
    9  20
        /  \
    15   7

    Output: 42
    */

    // func maxPathSum(_ root: TreeNode?) -> Int {
    //     guard let root = root else { return Int.min32 }
    //     if root.left == nil && root.right == nil { return root.val }
    //     let threeSum = maxPathSumHelper(root)
    //     return max(max(threeSum.left, threeSum.right), threeSum.root) 
    // }

    // func maxPathSumHelper(_ root: TreeNode) -> (left: Int, root: Int, right: Int) {
    //     if root.left == nil && root.right == nil { return (Int.min32, root.val, Int.min32) }
    //     let leftSum = root.left == nil ? nil : maxPathSumHelper(root.left!)
    //     let rightSum = root.right == nil ? nil : maxPathSumHelper(root.right!)
    //     return (
    //         left: max(max(leftSum?.left ?? Int.min32, leftSum?.right ?? Int.min32), leftSum?.root ?? Int.min32),
    //         root: root.val + (max(leftSum?.root ?? 0, rightSum?.root ?? 0) < 0 ? 0 : max(leftSum?.root ?? 0, rightSum?.root ?? 0)),
    //         right: max(max(rightSum?.left ?? Int.min32, rightSum?.right ?? Int.min32), rightSum?.root ?? Int.min32)
    //         )

    // }

    func diameterOfBinaryTree(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0}
        let lens = diameterOfBinaryTreeHelper(root)
        return lens.1 - 1
    }

    func diameterOfBinaryTreeHelper(_ node: TreeNode) -> (Int, Int) {
        var (leftLen, rightLen) = ((0, 0), (0, 0))
        if let left = node.left {
            leftLen = diameterOfBinaryTreeHelper(left)
        } 
        if let right = node.right {
            rightLen = diameterOfBinaryTreeHelper(right)
        }
        return (max(leftLen.0, rightLen.0) + 1, max(max(leftLen.0 + rightLen.0 + 1, leftLen.1), rightLen.1))
    }


    func generateParenthesis(_ n: Int) -> [String] {
        var dp = [[""],["()"]]
        guard n > 1 else { return dp[n] }
        for i in 2...n {
            var temp: [String] = []
            for j in 0..<i {
                for left in dp[j] {
                    for right in dp[i-1-j] {
                        temp.append("(\(left))\(right)")
                    }
                }
            }
            dp.append(temp)
        }
        return dp[n]
    }

    class ShuffleArray {

        var nums: [Int]

        init(_ nums: [Int]) {
            self.nums = nums
        }
        
        /** Resets the array to its original configuration and return it. */
        func reset() -> [Int] {
            return self.nums
        }
        
        /** Returns a random shuffling of the array. */
        func shuffle() -> [Int] {
            var numsCopy = nums
            var result: [Int] = []
            for i in 0..<numsCopy.count {
                let index = Int.random(in: 0...numsCopy.count-i-1)
                result.append(numsCopy[index])
                numsCopy[index] = numsCopy[numsCopy.count-1-i]
            }
            return result
        }
    }

    func generatePickDrop(_ n: Int) -> [String] {
        let avail = (1...n).map{"P\($0)"}
        var result = [String]()
        generatePickDrop(avail, &result, "")
        return result
    }

    func generatePickDrop(_ avail: [String], _ result: inout [String], _ current: String) {
        if avail.isEmpty {
            result.append(current)
            return
        }

        for (_,action) in avail.enumerated() {
            let num = Int(String(action[1]))!
            let newAvail = avail.filter{$0 != action}
            let newCurrent = "\(current)\(current.isEmpty ? "" : ", ")\(action)"
            if action.first == "P" {
                generatePickDrop(newAvail + ["D\(num)"], &result, newCurrent)
            } else if action.first == "D" {
                generatePickDrop(newAvail, &result, newCurrent)
            }
        }
    }

    enum IPType: String {
        case ipv4 = "IPv4"
        case ipv6 = "IPv6"
        case neither = "Neither"
    }

    func validIPAddress(_ IP: String) -> String {
        var type: IPType = (IP.contains(":") && !IP.contains(".")) ? .ipv6 : ((IP.contains(".") && !IP.contains(":")) ? .ipv4 : .neither)

        guard type != .neither else {
            return type.rawValue
        }

        print(0)
        var temp = ""
        var segCount = 0
        for i in 0...IP.count {
            let ch = (i == IP.count ? (type == .ipv4 ? "." : ":") : IP.lowercased()[i])
            if ch.isLetter {
                 if ch.isHexDigit && type == .ipv6 {
                     temp.append(ch)
                 } else {
                     print(1)
                     type = .neither
                     break
                 }
            } else if ch.isNumber {
                temp.append(ch)
            } else if ch == "." {
                if temp.isEmpty || temp.count > 3 || (temp.first! == "0" && temp.count != 1) {
                    print(3)
                    type = .neither
                    break
                } else {
                    if let value = Int(temp), value >= 0, value < 256 {
                        segCount += 1
                        if segCount > 4 {
                            print(4)
                            type = .neither
                            break    
                        }
                        temp = ""
                    } else {
                        print(5)
                        type = .neither
                        break
                    }
                }
            } else if ch == ":" {
                if temp.isEmpty || temp.count > 4 {
                    print(6)
                    type = .neither
                    break
                } else {
                    segCount += 1
                        if segCount > 8 {
                            print(7)
                            type = .neither
                            break    
                        }
                        temp = ""
                }
            } else {
                return IPType.neither.rawValue
            }
        }
    
        

        if (segCount == 4 && type == .ipv4) || (segCount == 8 && type == .ipv6) {
            return type.rawValue
        } else {
            return IPType.neither.rawValue
        }

    }

    func reverseList(_ head: ListNode?) -> ListNode? {
        guard let headCopy = head, let next = headCopy.next else { 
            return head 
        }
        headCopy.next = nil
        if let nextReverseList = reverseList(next) {
            var tail = nextReverseList
            while tail.next != nil { tail = tail.next! }
            tail.next = head
            return nextReverseList
        }
        return nil
    }


    func findAnagrams(_ s: String, _ p: String) -> [Int] {
        guard s.count >= p.count else { return [] }
        var result = [Int]()
        let pMap = p.reduce(into: [Character: Int]()){$0[$1, default: 0] += 1}
        var movingMap = pMap
        for i in 0..<s.count {
            let ch = s[i]
            movingMap[ch]? -= 1
            if movingMap[ch] != nil && movingMap[ch]! == 0 {
                movingMap.removeValue(forKey: ch)
            }
            print(movingMap)
            if i >= p.count-1 {
                if movingMap.count == 0 {
                    result.append(i-p.count+1)
                }
                if pMap[s[i-p.count+1]] != nil {
                    movingMap[s[i-p.count+1], default:0] += 1
                    print(movingMap)
                }
            }
        }
        return result
    }

    func minSubArrayLen(_ s: Int, _ nums: [Int]) -> Int {
        guard nums.count > 0 else { return 0 }
        var sum = nums[0]
        var minLen = sum >= s ? 1 : nums.count
        var left = 0
        for i in 1..<nums.count {
            sum += nums[i]
            while sum >= s {
                minLen = min(minLen, i - left + 1)
                sum -= nums[left]
                left += 1
            }
        
        }
        return minLen
    }

    func reorderList(_ head: ListNode?) {
        guard let head = head, head.next != nil else { return }
        let firstTail = findFirstTail(head)
        let (left, right) = (head, firstTail.next!)
        firstTail.next = nil
        mergeTwoLinkedList(left, reverseList(right)!)
    }

    func mergeTwoLinkedList(_ left: ListNode, _ right: ListNode) {
        var leftCur: ListNode? = left
        var rightCur: ListNode? = right
        while leftCur != nil && rightCur != nil {
            let leftNext = leftCur?.next
            let rightNext = rightCur?.next
            leftCur?.next = rightCur
            rightCur?.next = leftNext
            leftCur = leftNext
            rightCur = rightNext
        }
    }

    func findFirstTail(_ head: ListNode) -> ListNode {
        var len = 1
        var cur = head
        while cur.next != nil {
            len += 1
            cur = cur.next!
        }
        let count = (len - 1)/2
        cur = head
        for _ in 0..<count {
            cur = cur.next!
        }

        return cur
    }

    func firstMissingPositive(_ nums: [Int]) -> Int {
        var numsCopy = nums
        var i = 0
        while i < numsCopy.count {
            defer { i += 1 }
            let num = numsCopy[i]
            if num <= numsCopy.count 
            && num > 0 
            && num != i + 1
            && numsCopy[num-1] != num {
                swap(&numsCopy, i, num-1)
                i -= 1
            }
        }

        for (i, n) in numsCopy.enumerated() {
            if i+1 != n {
                return i+1
            }
        }
        return numsCopy.count + 1
    }

    func missingNumber(_ nums: [Int]) -> Int {
        let expectedSum = (1...nums.count).reduce(0) {$0 + $1}
        let actualSum = nums.reduce(0) {$0 + $1}
        return expectedSum - actualSum
    }

    func isPalindrome(_ s: String) -> Bool {
        let processed = s.lowercased().filter{$0.isLetter || $0.isNumber}
        return processed.enumerated().reduce(true){$0 && $1.element == processed[processed.count - $1.offset - 1]}
    }

    func canPermutePalindrome(_ s: String) -> Bool {
        // let map = s.reduce(into: [Character: Int]()) {$0[$1, default: 0] += 1}
        // let count = map.reduce((0)) {$0 + ($1.value%2 == 1 ? 1 : 0)}
        // return count <= 1

        let set = s.reduce(into: Set([Character]())) {
            if $0.contains($1) {
                $0.remove($1)
            } else {
                $0.insert($1)
            }
        }
        return set.count <= 1
    }

    func sortColors(_ nums: inout [Int]) {
        var start = 0
        while start < nums.count  && nums[start] == 0 { start += 1 }
        var end = nums.count - 1
        while end >= start && nums[end] == 2 { end -= 1 }
        var i = start
        while i <= end && start <= end {
            print("i: \(i)")
            // Thread.sleep(forTimeInterval: 1.0)
            if nums[i] == 0 {
                swap(&nums, start, i)
                print("num = 0 \(nums)")
            } else if nums[i] == 2 {
                swap(&nums, end, i)
                print("num = 2 \(nums)")
            } else {
                i += 1
            }

            while start < end  && nums[start] == 0 { 
                start += 1
                i = start
            }
            while end >= start && nums[end] == 2 { end -= 1 }
        }
    }

    func maxArea(_ height: [Int]) -> Int {
        var left  = 0
        var right = height.count - 1
        var maxWater = 0
        while left < right {
            print("left: \(left), right: \(right)")
            maxWater = max(maxWater, min(height[left], height[right]) * (right - left) )
            if height[left] < height[right] {
                left += 1
            } else {
                right -= 1
            }
        }
        return maxWater
    }

    func longestConsecutive(_ nums: [Int]) -> Int {
        var numSet = Set(nums)
        var maxSeq = 1
        for num in nums {
            guard !numSet.isEmpty else { break }
            var numSeq = 1
            numSet.remove(num)
            var nextNum = num + 1
            while numSet.contains(nextNum) { 
                numSeq += 1
                numSet.remove(nextNum)
                nextNum += 1
            }

            var prevNum = num - 1
            while numSet.contains(prevNum) {
                numSeq += 1
                numSet.remove(prevNum)
                prevNum -= 1
            }
            maxSeq = max(maxSeq, numSeq)
        }   

        return maxSeq     
    }

    func calculate(_ s: String) -> Int {
        guard !s.isEmpty else { return 0 }
        var stack: [Int] = []
        var temp = 0
        var op: Character = "+"
        for i in 0...s.count {
            let ch = i == s.count ? "+" : s[i]
            if ch.isNumber {
                temp = temp * 10 + Int(ch.asciiValue! - Character("0").asciiValue!)
            } else if "+-*/".contains(ch) {
                if "+" == op {
                    stack.append(temp)
                } else if "-" == op {
                    stack.append(-temp)
                } else if "*" == op {
                    stack.append(stack.popLast()! * temp)
                } else if "/" == op {
                    stack.append(stack.popLast()! / temp)
                }
                op = ch
                temp = 0
            }
        }
        
        return stack.reduce(0){$0 + $1}
    }

    func isBipartite(_ graph: [[Int]]) -> Bool {
        guard graph.count >= 1 else { return false }
        var (setA, setB) = (Set<Int>(), Set<Int>())
        var queue: [Int] = []
        for i in 0..<graph.count {
            if !setA.contains(i) && !setB.contains(i) {
                setA.insert(0)        
                queue.append(i)
            }
            while !queue.isEmpty {
                print(queue)
                print("setA: \(setA), setB: \(setB)")
                Thread.sleep(forTimeInterval: 1.0)
                let node = queue.removeFirst()
                let currentSet = setA.contains(node) ? setA : setB
                var theOtherSet = setA.contains(node) ? setB : setA
                for adjNode in graph[node] {
                    if currentSet.contains(adjNode) {
                        return false
                    }
                    if !theOtherSet.contains(adjNode) {
                        queue.append(adjNode)
                        theOtherSet.insert(adjNode)
                    }
                }
                if setA.contains(node) {
                    setB = theOtherSet
                } else {
                    setA = theOtherSet
                }
            }
        }

        return !setA.isEmpty && !setB.isEmpty
    }

    func myPow(_ x: Double, _ n: Int) -> Double {
        if n == 0 { return 1.0 }
        var dp: [Double?] = Array(repeating: nil, count: n+1)
        dp[0] = 1.0
        dp[1] = x
        if n > 0 {
            return myPowAbs(x, n, &dp)
        } else {
            return 1.0/myPowAbs(x, -n, &dp)
        }
    }

    func myPowAbs(_ x: Double, _ n: Int, _ dp: inout [Double?]) -> Double {
        if dp[n] != nil {
            return dp[n]!
        }
        let res = myPowAbs(x, n/2, &dp) * myPowAbs(x, n/2, &dp) * (n%2 == 1 ? x : 1.0)
        dp[n] = res
        return res
    }

    func maxSubArray(_ nums: [Int]) -> Int {
        guard nums.count > 0 else { return 0 }
        var dp = nums
        for i in 1..<nums.count {
            dp[i] = max(nums[i], dp[i-1] + nums[i])
        }
        return dp.reduce(Int.min) {max($0, $1)}
    }


    class RandomizedCollection {

        var nums: [Int] = []
        var numMap:[Int: [Int]] = [:]

        /** Initialize your data structure here. */
        init() {
            
        }
        
        /** Inserts a value to the collection. Returns true if the collection did not already contain the specified element. */
        func insert(_ val: Int) -> Bool {
            let result = (numMap[val] == nil)
            nums.append(val)
            numMap[val, default: []].append(nums.count - 1)
            print("after insert\nnums: \(nums), map: \(numMap)")
            return result
        }
        
        /** Removes a value from the collection. Returns true if the collection contained the specified element. */
        func remove(_ val: Int) -> Bool {
            if numMap[val] != nil {
                let index = numMap[val]!.last!
                let lastNum = nums[nums.count - 1]
                numMap[lastNum]?.removeLast()
                numMap[lastNum]?.append(index)
                nums[index] = lastNum
                nums.removeLast()
                numMap[val]?.removeLast() //Array
                if (numMap[val]?.count ?? -1) == 0 {
                    numMap.removeValue(forKey: val)
                }
                print("after remove\nnums: \(nums), map: \(numMap)")
                return true
            }
            return false
        }
        
        /** Get a random element from the collection. */
        func getRandom() -> Int {
            guard nums.count > 0 else { return 0 }
            return nums[Int.random(in: 0...nums.count-1)]
        }
    }


    func findTargetSumWays(_ nums: [Int], _ S: Int) -> Int {
        guard nums.count > 0 else { return 0}    

        var sumMap: [Int: Int] = [nums[0]:1]
        sumMap[-nums[0], default: 0] += 1

        for i in 1..<nums.count {
            let num = nums[i]
            var tempMap: [Int: Int] = [:]
            for (sum, count) in sumMap {
                tempMap[sum + num, default: 0] += count
                tempMap[sum - num, default: 0] += count
            }
            sumMap = tempMap
        }

        print(sumMap)
        return sumMap[S, default: 0]
    }

    
    func maxSlidingWindow(_ nums: [Int], _ k: Int) -> [Int] {
        guard k > 0 else { return [] }
        guard nums.count >= k else { return [] }
        guard k > 1 else { return nums }
        
        var maxSeq = [nums[0]]
        var queue: [Int] = []
        for i in 0..<k {
            while !queue.isEmpty && nums[queue.last!] < nums[i] {
                _ = queue.popLast()
            }
            queue.append(i)
            
            maxSeq[0] = max(maxSeq[0], nums[i])
            
        }

        for i in k..<nums.count {
            // print("before -- maxSeq: \(maxSeq), queue: \(queue)")
            if !queue.isEmpty && (queue.first!) < i - k + 1 {
                queue.removeFirst()
            }
            
            while !queue.isEmpty && nums[queue.last!] < nums[i] {
                _ = queue.popLast()
            }
            
            queue.append(i)
            maxSeq.append(max(nums[queue.first!], nums[i]))
            // print("after -- maxSeq: \(maxSeq), queue: \(queue)")
        }

        return maxSeq
    }

    func findPeakElement(_ nums: [Int]) -> Int {
        let numsCopy = [Int.min] + nums + [Int.min]
        var (start, end) = (1, nums.count)
        while start <= end {
            let mIndex = (start+end)/2
            print("start: \(start), mid: \(mIndex), end: \(end)")
            let (l, m, r) = (numsCopy[mIndex - 1], numsCopy[mIndex], numsCopy[mIndex+1])
            if m > l && m > r {
                return mIndex - 1
            } else if l < m && m < r {
                start = mIndex + 1
            } else {
                end = mIndex - 1
            }
        }

        return -1
    }

    func sumNumbers(_ root: TreeNode?) -> Int {
        guard let root = root else { return 0 }
        let numArray = sumNumbersHelper(root)
        return numArray.map{($0.reduce(0){$0 * 10 + $1})}.reduce(0) {$0 + $1}
    }

    func sumNumbersHelper(_ root: TreeNode) -> [[Int]] {
        if root.left == nil && root.right == nil {
            return [[root.val]]
        }

        var result: [[Int]] = [[]]
        if let left = root.left {
            let leftResult = sumNumbersHelper(left)
            result.append(contentsOf: leftResult.map{[root.val] + $0})
        }

        if let right = root.right {
            let rightResult = sumNumbersHelper(right)
            result.append(contentsOf: rightResult.map{[root.val] + $0})
        }
        
        return result
    }

    func permute(_ nums: [Int]) -> [[Int]] {
        guard nums.count > 1 else { return [nums] }
        var result: [[Int]] = []
        permuteHelper(nums, Array(repeating: false, count: nums.count), [], &result)
        return result
    }

    func permuteHelper(_ nums: [Int], _ added: [Bool], _ curSeq: [Int], _ result: inout [[Int]]) {
        if (added.filter{!$0}).isEmpty {
            print("curSeq: \(curSeq)")
            result.append(curSeq)
        }

        for i in 0..<nums.count {
            if !added[i] {
                print("i: \(i)")
                var addedCopy = added
                addedCopy[i] = true
                var curSeqCopy = curSeq
                curSeqCopy.append(nums[i])
                permuteHelper(nums, addedCopy, curSeqCopy, &result)
            }
        }
    }

    func isStrobogrammatic(_ num: String) -> Bool {
        var i = 0
        let end = num.count-1
        while i <= num.count/2 {
            defer {
                i += 1
            }
            if num[i] == "1" {
                if num[end - i] != "1" {
                    return false
                }
            } else if num[i] == "6" {
                if num[end - i] != "9" {
                    return false
                }
            } else if num[i] == "8" {
                if num[end - i] != "8" {
                    return false
                }
            } else if num[i] == "9" {
                if num[end - i] != "6" {
                    return false
                }
            } else if num[i] == "0" {
                if num[end - i] != "0" {
                    return false
                }
            } else {
                return false
            }
        }    
        return true
    }

    func accountsMerge(_ accounts: [[String]]) -> [[String]] {

        let emailNameMap = accounts.reduce(into: [String: String]()) { (map, array) in
            guard array.count > 1 else { return }
            let name = array[0]
            print("name: \(name)")
            for i in 1..<array.count {
                print("email: \(array[i])")
                if map[array[i]] == nil {
                    map[array[i]] = name
                }
            }
        }

        let nameEmailsMap = emailNameMap.reduce(into: [String: [String]]()) {$0[$1.value, default: []].append($1.key)}
        return nameEmailsMap.map{[$0.key] + $0.value}
    }

    func strStr(_ haystack: String, _ needle: String) -> Int {
        if needle.isEmpty { return 0 }
        if needle.count > haystack.count { return -1 }
        let needleHash = getHash(needle)
        var hash = getHash(haystack[0..<needle.count])
        for i in 0...haystack.count - needle.count {
            if i != 0 {
                let letterValue = Int(haystack[i + needle.count - 1].asciiValue ?? 0) - "a".asciiValue
                let prevletterValue = Int(haystack[i - 1].asciiValue ?? 0) - "a".asciiValue
                let power = Int(pow(Double(26), Double(needle.count - 1))) % (1 << 31)
                hash = (hash - power * prevletterValue) * 26 + letterValue
            }

            if hash == needleHash {
                return i
            }
        }

        return -1
    }

    func getHash(_ str: String) -> Int {
        return (str.reduce(0) {$0 * 26 + Int(($1.asciiValue ?? 0)) - "a".asciiValue}) % (1 << 31)
    }


    enum Direction: CaseIterable {
        case up, down, left, right
    }

    func wallsAndGates(_ rooms: inout [[Int]]) {
        let EMPTY = 2147483647
        let GATE = 0

        let l = rooms.count
        guard l > 0 else { return }
        let w = rooms[0].count
        var queue: [[Int]] = []
        rooms.enumerated().forEach {
            let row = $0.offset
            $0.element.enumerated().forEach {
                let col = $0.offset
                if $0.element == GATE {
                    queue.append([row, col])
                }
            }
        }

        while !queue.isEmpty {
            let cur = queue.removeFirst()
            let curRow = cur[0]
            let curCol = cur[1]
            for d in Direction.allCases {
                let moved = cur.moveTo(d)
                let movedRow = moved[0]
                let movedCol = moved[1]
                if movedRow < 0 || movedRow >= l || movedCol < 0 || movedCol >= w || rooms[movedRow][movedCol] != EMPTY {
                    continue
                }
            
                rooms[movedRow][movedCol] = rooms[curRow][curCol] + 1
                queue.append(moved)
            }
        }
    }

    func subsets(_ nums: [Int]) -> [[Int]] {
        var result: [[Int]] = [[]]
        subsetsHelper(nums, [], 0, &result)
        return result
    }

    func subsetsHelper(_ nums:[Int], _ curSeq: [Int], _ start: Int, _ result: inout [[Int]]) {
        for i in start..<nums.count {
            let newSeq = curSeq + [nums[i]]
            result.append(newSeq)
            subsetsHelper(nums, newSeq, i + 1, &result)
        }
    }

    func exist(_ board: [[Character]], _ word: String) -> Bool {
        for i in 0..<board.count {
            for j in 0..<board[0].count {
                if existHelper(board, word, i, j, Array(repeating: Array(repeating: false, count: board[0].count), count: board.count)) {
                    return true
                }
            }
        }
        return false
    }

    func existHelper(_ board: [[Character]], _ word: String, _ row: Int, _ col: Int, _ visited: [[Bool]]) -> Bool {
        if word.count == 0 { return true }
        let curPos = [row, col]
        let c = word[0]
        guard board[row][col] == c else { return false }
        if word.count == 1 { return true }
        var newVisited = visited
        newVisited[row][col] = true
        for d in Direction.allCases {
            let newPos = curPos.moveTo(d)
            let newRow = newPos[0]
            let newCol = newPos[1]
            guard newRow >= 0 
                && newRow < board.count 
                && newCol >= 0 
                && newCol < board[0].count 
                && !visited[newRow][newCol] else {
                continue
            }
            if existHelper(board, word[1..<word.count], newRow, newCol, newVisited) {
                return true
            }        
        }

        return false
    }
    /*
        Input:
        [
        "wrt",
        "wrf",
        "er",
        "ett",
        "rftt"
        ]
        w: r, t, f
        r: t, f
        e: r, t
        f: t

        wrft
    */

    func alienOrder(_ words: [String]) -> String {
        var invalidInput = false
        var wordGraph = words.enumerated().reduce(into: [Character: Set<Character>]()) { (map, iter) in
            let curWord = iter.element
            let index = iter.offset

            var findDiff = false
            for (i, ch) in curWord.enumerated() {
                if map[ch] == nil {
                    map[ch] = []
                }

                guard index > 0 else {
                    continue
                }

                guard !findDiff else {
                    continue
                }

                let lastWord = words[index - 1]

                guard i < lastWord.count else { continue }

                if curWord[i] != lastWord[i] {
                    if !isValid(map, curWord[i], lastWord[i]) {
                        invalidInput = true
                        return
                    }

                    findDiff = true
                    map[curWord[i], default: []].insert(lastWord[i])
                }

                if i == curWord.count - 1 && !findDiff && lastWord.count > curWord.count {
                    invalidInput = true
                    return
                }
            }
        }    

        print("word graph: \(wordGraph.description)")

        if invalidInput {
            return ""
        }

        var result = ""
        while !wordGraph.isEmpty {
            let graphCopy = wordGraph
            for (k,v) in graphCopy {
                if v.count == 0 {
                    result.append(k)
                    wordGraph.removeValue(forKey: k)
                    for (kk, _) in wordGraph {
                        if kk != k {
                            wordGraph[kk]?.remove(k)
                        }
                    }
                }
            }
        }

        return result
    }

    func isValid(_ graph: [Character: Set<Character>], _ curCh: Character, _ priorCh: Character) -> Bool {
        var priors: Set<Character> = [priorCh]
        while !priors.isEmpty {
            if priors.contains(curCh) {
                return false
            }

            if let p = priors.popFirst(), let allPriors = graph[p] {
                allPriors.forEach {priors.insert($0)}
            }
        }
        
        return true
    }

    func lengthOfLIS(_ nums: [Int]) -> Int {
        var len = 0
        var dp = Array(repeating: 0, count: nums.count)
        for (_, num) in nums.enumerated() {
            var i = binarySearch(dp, 0, len, num)
            if i < 0 {
                i = -(i + 1)
            }

            dp[i] = num

            if i == len {
                len += 1
            }
            print(dp)
        }

        return len
    }

    func binarySearch(_ nums: [Int], _ start: Int, _ len: Int, _ t: Int) -> Int {
        let end = start + len - 1
        guard start <= end else {
            return start == 0 ? -1 : -(start+1)
        }
        let med = (start + end)/2

        if nums[med] == t {
            return med
        } else if nums[med] > t {
            return binarySearch(nums, start, med - start, t)
        } else {
            return binarySearch(nums, med + 1, end - med , t)
        }
        
    }

    func canCross(_ stones: [Int]) -> Bool {
        var map = stones.reduce(into: [Int: Set<Int>]()) {$0[$1] = []}

        map[stones[0]] = [0]
        for i in 0..<stones.count {
            // Thread.sleep(forTimeInterval: 0.5)
            // print("i:\(i)")
            if let steps = map[stones[i]] {
                // print("steps: \(steps)")
                for step in steps {
                    for nextStepDiff in -1...1 {
                        let nextStep = nextStepDiff + step
                        if nextStep > 0 && map[nextStep + stones[i]] != nil {
                            map[nextStep + stones[i]]?.insert(nextStep)
                        }
                    } 
                }
            }
        }



        return map[stones.last!]!.count > 0

    }


    func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
        guard let head = head else { return nil }
        let (len, hasRemoved) = removeNthFromEndHelper(head, n)
        if len == n && !hasRemoved {
            return head.next
        }
        return head
    }

    func removeNthFromEndHelper(_ head: ListNode, _ n: Int) -> (Int, Bool) {
        guard let next = head.next else {
            return (1, false)
        } 
        let (len, hasRemoved) = removeNthFromEndHelper(head.next!, n)
        if len == n && !hasRemoved {
            let nextNext = next.next
            head.next = nextNext
            return (len, true)
        }

        return (1 + len, hasRemoved)
        
    }


    func kthSmallest(_ root: TreeNode?, _ k: Int) -> Int {
        guard let root = root else { return Int.min}

        let result = kthSmallestHelper(root, k)
        return result.0!
    }
    
    func kthSmallestHelper(_ root: TreeNode, _ k: Int) -> (Int?, Int) {
        var kCopy = k
        var leftResult: (Int?, Int) = (nil, 0)
        var rightResult: (Int?, Int) = (nil, 0)
        if let left = root.left {
            leftResult = kthSmallestHelper(left, kCopy)
        }

        if leftResult.0 != nil {
            return leftResult
        }
        
        let leftTotal = leftResult.1
        kCopy -= leftTotal + 1

        if kCopy == 0 {
            return (root.val, leftResult.1 + 1)
        }

        if let right = root.right {
            rightResult = kthSmallestHelper(right, kCopy)
        }

        if rightResult.0 != nil {
            return rightResult
        }
        
        let rightTotal = rightResult.1

        return (nil, leftTotal + 1 + rightTotal)
    }


    // func shortestDistance(_ grid: [[Int]]) -> Int {
        
    // }

    // func shortestDistance(_ grid: [[Int]], _ x: Int, _ y: Int) -> [[Int]] {
    //     var result: [[Int]] = grid

    // }

    func setZeroes(_ m: inout [[Int]]) {
        for i in 0..<m.count {
            for j in 0..<m[i].count {
                if m[i][j] == 0 {
                    setTwoes(&m, i, j)
                }
            }
        }

        for i in 0..<m.count {
            for j in 0..<m[i].count {
                if m[i][j] == Int.min {
                    m[i][j] = 0
                }
            }
        }
    }

    func setTwoes(_ m: inout[[Int]], _ x: Int, _ y: Int) {
        guard m.count > 0 && m[0].count > 0 else { return }
        let l = m.count
        let w = m[0].count

        for i in 0..<l {
            if m[i][x] != 0 {
                m[i][x] = Int.min
            }
        }

        for i in 0..<w {
            if m[y][i] != 0 {
                m[y][i] = Int.min
            }
        }
    }


    func customSortString(_ s: String, _ t: String) -> String {
        var orders: [Character: Set<Character>] = [:]
        for i in 0..<s.count {
            if i == s.count - 1 {
                orders[s[i]] = []
            } else {
                for j in i+1..<s.count {
                    orders[s[i], default: []].insert(s[j])
                }
            }
        }

        let noOrderStr = t.filter{orders[$0] == nil}

        return noOrderStr + String((t.filter{orders[$0] != nil}).sorted { (left, right) -> Bool in
            return orders[left]?.contains(right) ?? false
        })
    }


    func isSymmetric(_ root: TreeNode?) -> Bool {
        guard let root = root else  { return true }
        var result = true
        isSymmetric(root.left, root.right, &result)
        return result
    }

    func isSymmetric(_ left: TreeNode?, _ right: TreeNode?, _ result: inout Bool) {
        if result == false {
            return
        }

        if ((left == nil) || (right == nil)) && left != right {
            result = false
            return 
        }

        if left!.val != right!.val {
            result = false
            return
        }

        isSymmetric(left?.left, right?.right, &result)
        isSymmetric(left?.right, right?.left, &result)
    }


}


let s = Solution()
let result = s.customSortString("exv", "xwvee")
print("Result: \(result)")

/* 
[[0,1,2,0],
 [3,4,5,2],
 [1,3,1,5]]


 [[0,0,0,0],
 [0,4,5,0],
 [0,3,1,0]]
 */


