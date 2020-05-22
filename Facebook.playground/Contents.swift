import UIKit

extension String {
    public subscript(x: Int) -> Character {
        let index = self.index(self.startIndex, offsetBy: x)
        return self[index]
    }
    
    public subscript(x: ClosedRange<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: x.lowerBound)
        let end = self.index(self.startIndex, offsetBy: x.upperBound)
        return String(self[startIndex...end])
    }
    
    public subscript(x: Range<Int>) -> String {
        let start = self.index(self.startIndex, offsetBy: x.lowerBound)
        let end = self.index(self.startIndex, offsetBy: x.upperBound)
        return String(self[startIndex..<end])
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
        if s.isEmpty || s.count == 1 { return 1 }
        
        if let num = Int(s[0...1]) {
            return (num <= 26 ? 2 : 1) * numDecodings(s[1..<s.count])
        } else {
            return 0
        }
        
    }
}


let s = Solution()

let result = s.numDecodings("226")
print("Result: \(result)")
