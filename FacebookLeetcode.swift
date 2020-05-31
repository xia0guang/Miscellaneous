import Foundation

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
    public init() { self.val = 0; self.left = nil; self.right = nil; }
    public init(_ val: Int) { self.val = val; self.left = nil; self.right = nil; }
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
        let taskDict = tasks.reduce(into: [Character: Int]()) {$0[$1, default: 0] += 1}
        var taskArray = taskDict.map {($0.value)}
        
        var time = 0
        while taskArray.count > 0 {
            taskArray = taskArray.sorted().reversed()
            print("tasks: \(taskArray)")
            var i  = 0
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
            taskArray = taskArray.filter{$0 != 0}
        }
        return time
    }
    
    func merge(_ intervals: [[Int]]) -> [[Int]] {
        if intervals.count <= 1 {return intervals}
        let sortedIntervals = intervals.sorted {$0[0] < $1[0]}
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
        var (index1, index2) = (0,0)
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
            let twoSumResult = twoSum(sorted[i+1..<sorted.count], -sorted[i])
            result.append(contentsOf: twoSumResult.map{[sorted[i], $0[0], $0[1]]})
        }
        return result
    }
    
    private func twoSum(_ nums: ArraySlice<Int>, _ target: Int) -> [[Int]] {
        let sorted = nums.sorted()
        var result = [[Int]]()
        var (left, right) = (0, sorted.count-1)
        while left < right {
            let (leftN, rightN) = (sorted[left],sorted[right])
            let sum = leftN + rightN
            if sum == target {
                result.append([leftN, rightN])
                repeat {
                    left += 1
                } while left < right && sorted[left] == sorted[left - 1]
                repeat  {
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
            return p.isEmpty || (p.count > 1 && p[1] == "*" && isMatch(s,String(p[p.index(p.startIndex, offsetBy: 2)...])))
        }
        
        if p.isEmpty {
            return false
        }
        
        let (a, b) = (s[0], p[0])
        let sSub = String(s[s.index(s.startIndex, offsetBy: 1)...])
        let pSub = String(p[p.index(p.startIndex, offsetBy: 1)...])
        let isMatched = a == b || b == "."
        
        if pSub.count > 0 && pSub[0] == "*" {
            return (p.count > 1 && isMatch(s, String(p[p.index(p.startIndex, offsetBy: 2)...])) || isMatched && isMatch(sSub, p))
        } else {
            return isMatched && isMatch(sSub, pSub)
        }
    }
    
    func findLengthOfLCIS(_ nums: [Int]) -> Int {
        guard nums.count > 1 else {
            return nums.count
        }
        var (maxSeq, seq) = (0,1)
        for i in 1..<nums.count {
            if nums[i] > nums[i-1] {
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
        var (rangeLeft, rangeRight) = (0,0)
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
        
        return (rangeLeft...rangeRight).map{dict[$0]!}
        
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
            leftIter[i] = max(maxBar, height[i-1])
            maxBar = max(maxBar, height[i-1])
        }
        maxBar = height[height.count - 1]
        for i in stride(from: height.count - 2, to: 0, by: -1) {
            rightIter[i] = max(maxBar, height[i+1])
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
        let rs = String(s.trimmingCharacters(in: .whitespaces).reversed()).components(separatedBy: .whitespaces).filter({!$0.isEmpty})
        
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
        if s.count == 1 { return 1}
        
        var dp = [1, 1]
        
        for i in 1..<s.count {
            let twoDigit = Int(s[i-1...i])!
            if s[i] == "0" {
                dp.append(twoDigit <= 26 ? dp[i-1] : 0)
            }
            dp.append(twoDigit <= 26 ? dp[i] + dp[i-1] : dp[i])
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
        
        let starts = intervals.map{$0[0]}.sorted()
        let ends = intervals.map{$0[1]}.sorted()
        
        var (total, endCur) = (0,0)
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
        
        swapAll(&nums, pivotPoint+1, nums.count-1)
    }
    
    func groupAnagrams(_ strs: [String]) -> [[String]] {
        
        //V1
        let sorted = strs.map{String($0.sorted())}
        var map = [String: [String]]()
        for i in 0..<sorted.count {
            map[sorted[i], default: []].append(strs[i])
        }
        
        return map.map {$0.value}
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
        if (dividend == -2147483648 && divisor == -1) {
            return 2147483647;
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
            return (neg == 1 ? -1 : 1) * (Int(truncating: NSDecimalNumber(decimal: pow(Decimal(2), power))) + divide(vDividend - value, vDivisor))
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
        
        var dp: [[[String]]] = Array(repeating: Array(repeating: [""], count: s.count), count: s.count)
        for i in 0..<s.count {
            for j in 1..<s.count {
                if i < j {
                    if s[j] == "(" {
                        dp[i][j] = dp[i][j-1]
                    }
                    
                    if i + 1 ==  j && s[i] == "(" {
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
        let map = nums.enumerated().reduce(into: [Int: [Int]]()) { $0[$1.1, default: []].append($1.0)}
        print(map)
        for (k,v) in map {
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
                root.val > max else { return (false, nil, nil)}
            result.1 = min
        } else {
            result.1 = root.val
        }
        
        if let right = root.right {
            let rightResult = isValidBSTHelper(right)
            guard rightResult.0,
                let max = rightResult.2,
                let min = rightResult.1,
                root.val < min else { return (false, nil, nil)}
            result.2 = max
        } else {
            result.2 = root.val
        }
        
        return result
    }
    
    func longestSubstring(_ s: String, _ k: Int) -> Int {
        let countMap: [Character: Int] = s.reduce(into: [Character: Int]()){$0[$1, default: 0] += 1}
        print(countMap)
        var movingMap: [Character: Int] = [:]
        var (maxCount,start) = (0,0)
        for i in 0..<s.count {
            let char = s[i]
            if let count = countMap[char], count >= k {
                movingMap[char, default: 0] += 1
                
                
                if movingMap[char]! >= k {
                    
                    var movingMapCopy = movingMap //Copy
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
        var list = (1...n).map{String($0)}
        var kk = k - 1
        var result = ""
        for i in stride(from: n-1, through: 1, by: -1) {
            let index = kk/getFactory(i)
            print(index)
            result += list[index]
            list.remove(at: index)
            kk = kk%getFactory(i)
            
        }
        result += list.removeFirst()
        return result
    }
    
    func getFactory(_ n: Int) -> Int {
        return (1...n).reduce(1){$0 * $1}
    }
    
    func isAnagram(_ s: String, _ t: String) -> Bool {
        if s.count != t.count { return false }
        let sMap = s.reduce(into: [Character: Int]()) {$0[$1, default: 0] += 1}
        let tMap = t.reduce(into: [Character: Int]()) {$0[$1, default: 0] += 1}
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
                    dp[i+1] = true
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
        
        if (total)%2 == 0 {
            return (findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1)/2 ) + findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1)/2 + 1 )) / 2.0
        } else {
            return findKthInSortedArrays(nums1, 0, nums2, 0, (total + 1)/2)
        }
        
    }
    
    func findKthInSortedArrays(_ nums1: [Int], _ s1: Int, _ nums2: [Int], _ s2: Int, _ n: Int) -> Double {
        if s1 >= nums1.count {
            return Double(nums2[s2 + n - 1])
        }
        if s2 >= nums2.count {
            return Double(nums1[s1 + n - 1])
        }
        
        if n == 1 { return Double(min(nums1[s1], nums2[s2]))}
        
        let m = n/2
        if m > nums1.count {
            if nums1[nums1.count-1] <= nums2[s2+n-nums1.count-1] {
                return Double(nums2[s2+n-nums1.count-1])
            } else {
                return findKthInSortedArrays(nums1, s1, nums2, s2+n-nums1.count, nums1.count)
            }
        }
        if m > nums2.count {
            if nums2[nums2.count-1] <= nums1[s1+n-nums2.count-1] {
                return Double(nums1[s1+n-nums2.count-1])
            } else {
                return findKthInSortedArrays(nums1, s1+n-nums2.count, nums2, s2, nums2.count)
            }
        }
        
        if nums1[s1 + m - 1] <= nums2[s2 + m - 1] {
            return findKthInSortedArrays(nums1, s1 + m, nums2, s2, n - m)
        } else {
            return findKthInSortedArrays(nums1, s1, nums2, s2 + m, n - m)
        }
    }
    
    func letterCombinations(_ digits: String) -> [String] {
        let keypad: [Character: String] = ["2": "abc",
                                           "3": "def",
                                           "4": "ghi",
                                           "5": "jkl",
                                           "6": "mno",
                                           "7": "pqrs",
                                           "8": "tuv",
                                           "9": "wxyz"]
        if digits.count == 0 { return [] }
        var result = keypad[digits[0]]?.map{String($0)} ?? []
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
}

let s = Solution()

let result = s.letterCombinations("23")
print("Result: \(result)")
