//: Playground - noun: a place where people can play
import Foundation
/*:
 ### Replace Words
 
 In English, we have a concept called root, which can be followed by some other words to form another longer word - let's call this word successor. For example, the root an, followed by other, which can form another word another.
 
 Now, given a dictionary consisting of many roots and a sentence. You need to replace all the successor in the sentence with the root forming it. If a successor has many roots can form it, replace it with the root with the shortest length.
 
 You need to output the sentence after the replacement.
 
 Example:
 ````
 Input: dict = ["cat", "bat", "rat"]
 sentence = "the cattle was rattled by the battery"
 Output: "the cat was rat by the bat"
 ````
 
 1. The input will only have lower-case letters.
 1. 1 <= dict words number <= 1000
 1. 1 <= sentence words number <= 1000
 1. 1 <= root length <= 100
 1. 1 <= sentence words length <= 1000
 */
func replaceWordsBasicBruteForce(_ dict: [String], _ sentence: String) -> String {
    let wordSet = Set(dict)
    var words = sentence.split(separator: " ")
    for i in 0..<words.count {
        let word = String(words[i])
        for j in 0 ..< word.count {
            let index = word.index(word.startIndex, offsetBy: j)
            let subString = word[...index]
            if wordSet.contains(String(subString)) {
                words[i] = subString
                break
            }
        }
    }
    var result = ""
    words.forEach({result.append(String("\($0) "))})
    result.removeLast()
    return result
}

class Node: Hashable, Equatable {
    static func == (lhs: Node, rhs: Node) -> Bool {
        return lhs.char == rhs.char
    }
    
    var char: Character?
    var nodes:Set<Node>
    var word: String?
    var hashValue: Int {
        get {
            return char?.hashValue ?? 0
        }
    }
    
    init(_ char: Character?) {
        self.char = char
        self.nodes = []
    }
    
    func contains(char: Character) -> Bool {
        return nodes.contains(Node(char))
    }
    
    func contains(word: String) -> Bool {
        if self.word == word {return true}
        for node in self.nodes {
            if node.contains(word: word) {
                return true
            }
        }
        
        return false
    }
    
    func append(_ element: Character) {
        self.nodes.insert(Node(element))
    }
    
    func childNode(_ element: Character) -> Node? {
        var returnNode: Node?
        nodes.forEach { node in
            if node.char == element {
                returnNode = node
            }
        }
        return returnNode
    }
    
    func replace(longWord: String) -> String? {
        for i in 0 ..< longWord.count {
            let prefix = String(longWord[...longWord.index(longWord.startIndex, offsetBy: i)])
            if contains(word: prefix) {
                return prefix
            }
        }
        return nil
    }
}

func trieTree(_ dict: [String]) -> Node {
    let root = Node(nil)
    dict.forEach { word in
        var point = root
        word.forEach { char in
            if !point.contains(char: char) {
                point.append(char)
            }
            point = point.childNode(char)!
        }
        point.word = word
    }
    return root
}

func replaceWords(_ dict: [String], _ sentence: String) -> String {
    let root = trieTree(dict)
    var subArr = sentence.split(separator: " ")
    for i in 0 ..< subArr.count {
        let word = String(subArr[i])
        if let replaced = root.replace(longWord: word){
            subArr[i] = Substring("\(replaced)")
        }
    }
    
    return String(subArr.joined(separator: " "))
}
//print(replaceWords(["a", "aa", "aaa", "aaaa"], "a aa a aaaa aaa aaa aaa aaaaaa bbb baba ababa"))


/*:
 ### Two Sum
 Given an array of integers, return indices of the two numbers such that they add up to a specific target.
 
 You may assume that each input would have exactly one solution, and you may not use the same element twice.
 
 Example:
 ````
 Given nums = [2, 7, 11, 15], target = 9,
 Because nums[0] + nums[1] = 2 + 7 = 9,
 return [0, 1].
 ````
 
 */
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var numDict: [Int: Int] = [:]
    for i in 0 ..< nums.count {
        if numDict[target - nums[i]] != nil {
            return [numDict[target - nums[i]]!, i]
        }
        numDict[nums[i]] = i
    }
    return []
}

/*:
 ### Longest Substring Without Repeating Characters
 Given a string, find the length of the longest substring without repeating characters.
 
 Examples:
 ````
 Given "abcabcbb", the answer is "abc", which the length is 3.
 Given "bbbbb", the answer is "b", with the length of 1.
 Given "pwwkew", the answer is "wke", with the length of 3. Note that the answer must be a substring, "pwke" is a subsequence and not a substring.
 ````
 
 */

func lengthOfLongestSubstring(_ s: String) -> Int {
    if s.count == 0 {return 0}
    var map: [Character: Int] = [s.first!: 0]
    var left = 0
    var maxLen = 1
    for i in 1 ..< s.count {
        let index = s.index(s.startIndex, offsetBy: i)
        let char = s[index]
        if map[char] != nil {
            maxLen = max(maxLen, i - left)
            print(maxLen)
            
            let leftIndex = s.index(s.startIndex, offsetBy: left)
            left = map[char]! + 1
            let newLeftIndex = s.index(s.startIndex, offsetBy: left)
            
            for existingChar in s[leftIndex..<newLeftIndex] {
                print("removing \(existingChar)")
                map.removeValue(forKey: existingChar)
            }
        }
        map[char] = i
    }
    return max(maxLen, s.count - left)
}
//print(lengthOfLongestSubstring("abcabcbb"))

/*:
 ### Longest Palindromic Substring
 Given a string s, find the longest palindromic substring in s. You may assume that the maximum length of s is 1000.
 
 Example 1:
 ````
 Input: "babad"
 Output: "bab"
 Note: "aba" is also a valid answer.
 ````
 Example 2:
 ````
 Input: "cbbd"
 Output: "bb"
 ````
 */
func longestPalindrome(_ s: String) -> String {
    if s.count == 0 {
        return ""
    }
    var longestLen = 1
    var longestPalindrome: Substring = s[...s.startIndex]
    var dp: [[Bool]] = Array(repeating: Array(repeating: false, count: s.count), count: s.count)
    
    for i in 0 ..< s.count {
        dp[i][i] = true
    }
    
    var len = 2
    while len <= s.count {
        for i in 0 ..< s.count-len+1 {
            let subStartIndex = s.index(s.startIndex, offsetBy: i)
            let subEndIndex = s.index(s.startIndex, offsetBy:  i + len - 1)
            
            if s[subStartIndex] == s[subEndIndex] {
                if  len <= 3 || dp[i+1][i + len - 2] {
                    dp[i][i + len - 1] = true
                    if longestLen < len {
                        longestLen = len
                        longestPalindrome = s[subStartIndex...subEndIndex]
                    }
                }
            }
        }
        len += 1
    }
    return String(longestPalindrome)
}
//print(longestPalindrome("a"))

/*:
 ### Reverse Integer
 
 Given a 32-bit signed integer, reverse digits of an integer.
 
 Example 1:
 ````
 Input: 123
 Output: 321
 ````
 Example 2:
 ````
 Input: -123
 Output: -321
 ````
 Example 3:
 ````
 Input: 120
 Output: 21
 ````
 - Note: Assume we are dealing with an environment which could only store integers within the 32-bit signed integer range: [−2^31,  2^31 − 1]. For the purpose of this problem, assume that your function returns 0 when the reversed integer overflows.
 
 */

func reverse(_ x: Int) -> Int {
    let neg = x < 0
    var xx = abs(x)
    var reversed = 0
    
    while xx > 0 {
        if reversed > 214748364 {
            return 0
        } else if reversed == 214748364, xx > 8 {
            return 0
        }
        print(reversed * 10 + xx % 10)
        reversed = reversed * 10 + xx % 10
        xx /= 10
    }
    
    return reversed * (neg ? -1 : 1)
}
//}

func knightProbability(_ N: Int, _ K: Int, _ r: Int, _ c: Int, dp: inout [[[Double]]]) -> Double {
    if r >= N || c >= N || r < 0 || c < 0 {
        return 0.0
    }
    
    if K == 0 {
        return 1.0
    }
    
    if dp[r][c][K] > 0 {
        return dp[r][c][K]
    }
    
    var result = 0.0
    
    result = 0.125 * knightProbability(N, K-1, r-2, c-1, dp: &dp) +
        0.125 * knightProbability(N, K-1, r-2, c+1, dp: &dp) +
        0.125 * knightProbability(N, K-1, r-1, c+2, dp: &dp) +
        0.125 * knightProbability(N, K-1, r+1, c+2, dp: &dp) +
        0.125 * knightProbability(N, K-1, r+2, c+1, dp: &dp) +
        0.125 * knightProbability(N, K-1, r+2, c-1, dp: &dp) +
        0.125 * knightProbability(N, K-1, r+1, c-2, dp: &dp) +
        0.125 * knightProbability(N, K-1, r-1, c-2, dp: &dp)
    
    dp[r][c][K] = result
    
    return result
}

func knightProbability(_ N: Int, _ K: Int, _ r: Int, _ c: Int) -> Double {
    var dp = Array(repeating: Array(repeating: Array(repeating: 0.0, count: K+1), count: N), count: N)
    var _ = knightProbability(N, K, r, c, dp: &dp)
    return dp[r][c][K]
}

//print(knightProbability(8, 30, 0, 0))

class Interval: CustomStringConvertible {
    var start: Int
    var end: Int
    init(_ start: Int, _ end: Int) {
        self.start = start
        self.end = end
    }
    
    var description: String {
        return "[\(start), \(end)]"
    }
}

func merge(_ intervals: [Interval]) -> [Interval] {
    if intervals.count == 0 {
        return []
    }
    let sortedIntervals = intervals.sorted{$0.start < $1.start}
    var result: [Interval] = [sortedIntervals.first!]
    var i = 1
    while i < sortedIntervals.count {
        let current = result.last!
        let next = sortedIntervals[i]
        if current.end >= next.start {
            current.end = max(current.end, next.end)
        } else {
            result.append(next)
        }
        i += 1
    }
    return result
}
//[[1,3],[2,6],[8,10],[15,18]]
//print(merge([Interval(2,6),Interval(1,3),Interval(8,10),Interval(15,18)]))

/*:
 ### Ugly Number
 
 Write a program to check whether a given number is an ugly number.
 
 Ugly numbers are positive numbers whose prime factors only include 2, 3, 5.
 
 Example 1:
 ````
 Input: 6
 Output: true
 Explanation: 6 = 2 × 3
 ````
 Example 2:
 ````
 Input: 8
 Output: true
 Explanation: 8 = 2 × 2 × 2
 ````
 Example 3:
 ```
 Input: 14
 Output: false
 Explanation: 14 is not ugly since it includes another prime factor 7.
 ````
 - Note:
 1 is typically treated as an ugly number.
 Input is within the 32-bit signed integer range: [−2^31,  2^31 − 1].
 */


func isUgly(_ num: Int) -> Bool {
    if num == 0 {
        return false
    }
    var nn = num
    while nn % 2 == 0 {
        nn /= 2
    }
    
    while nn % 3 == 0 {
        nn /= 3
    }
    
    while nn % 5 == 0 {
        nn /= 5
    }
    
    return nn == 1
}

/*:
 *** Ugly Number II
 
 Write a program to find the n-th ugly number.
 
 Ugly numbers are positive numbers whose prime factors only include 2, 3, 5.
 
 Example:
 ````
 Input: n = 10
 Output: 12
 Explanation: 1, 2, 3, 4, 5, 6, 8, 9, 10, 12 is the sequence of the first 10 ugly numbers.
 ````
 - Note:
 1 is typically treated as an ugly number.
 n does not exceed 1690.
 */

func nthUglyNumber(_ n: Int) -> [Int] {
    if n == 1 {return [1]}
    let baseNumList = [2,3,4,5]
    var uglyNumSet: Set<Int> = [1]
    var uglyNumList: [Int] = [1]
    var a = 0
    while uglyNumList.count < n {
        let baseIndex = a % 4
        let num = uglyNumList[a/4] * baseNumList[baseIndex]
        if !uglyNumSet.contains(num) {
            uglyNumList.append(num)
            uglyNumSet.insert(num)
        }
        a += 1
    }
    return uglyNumList
}

//

/*:
 
 ### Beautiful Arrangement
 
 Suppose you have N integers from 1 to N. We define a beautiful arrangement as an array that is constructed by these N numbers successfully if one of the following is true for the ith position (1 <= i <= N) in this array:
 
 The number at the ith position is divisible by i.
 i is divisible by the number at the ith position.
 Now given N, how many beautiful arrangements can you construct?
 
 Example:
 ````
 Input: 2
 Output: 2
 ````
 
 *Explanation*:
 
 The first beautiful arrangement is [1, 2]:
 
 Number at the 1st position (i=1) is 1, and 1 is divisible by i (i=1).
 
 Number at the 2nd position (i=2) is 2, and 2 is divisible by i (i=2).
 
 The second beautiful arrangement is [2, 1]:
 
 Number at the 1st position (i=1) is 2, and 2 is divisible by i (i=1).
 
 Number at the 2nd position (i=2) is 1, and i (i=2) is divisible by 1.
 - Note:
 N is a positive integer and will not exceed 15.
 
 */


func countArrangement(_ N: Int) -> Int {
    var result = 0
    var occupied = Array(repeating: false, count: N)
    countArrangement(N, &result, &occupied)
    return result
}

func countArrangement(_ n: Int, _ result: inout Int, _ occupied: inout [Bool]) {
    if n == 1 {
        result += 1
        return
    }
    
    occupied.enumerated().forEach { (index, e) in
        let natureIndex = index + 1
        if !e, (natureIndex%n == 0 || n%natureIndex == 0) {
            occupied[index] = true
            countArrangement(n-1, &result, &occupied)
            occupied[index] = false
        }
    }
}
//print(countArrangement(15))

/*:
 
 ### Beautiful Arrangement II
 
 Given two integers n and k, you need to construct a list which contains n different positive integers ranging from 1 to n and obeys the following requirement:
 Suppose this list is [a1, a2, a3, ... , an], then the list [|a1 - a2|, |a2 - a3|, |a3 - a4|, ... , |an-1 - an|] has exactly k distinct integers.
 
 If there are multiple answers, print any of them.
 
 ````
 Input: n = 3, k = 1
 Output: [1, 2, 3]
 ````
 *Explanation*: The [1, 2, 3] has three different positive integers ranging from 1 to 3, and the [1, 1] has exactly 1 distinct integer: 1.
 ````
 Input: n = 3, k = 2
 Output: [1, 3, 2]
 ````
 *Explanation*: The [1, 3, 2] has three different positive integers ranging from 1 to 3, and the [2, 1] has exactly 2 distinct integers: 1 and 2.
 - Note:
 The n and k are in the range 1 <= k < n <= 104.
 */

func constructArrayBacktracking(_ n: Int, _ k: Int) -> [Int] {
    var result:[Int]?
    var used = Set<Int>()
    var diffs = [Int: Int]()
    var arr = [Int]()
    constructArrayBacktracking(n, k, &used, &arr, &result, &diffs)
    return result ?? []
}

func constructArrayBacktracking(_ n: Int, _ k: Int, _ used: inout Set<Int>, _ arr: inout [Int], _ result: inout [Int]?, _ diffs: inout [Int: Int]) {
    if k >= n {
        return
    }
    
    if used.count == n, diffs.count == k {
        print("diffs: \(diffs)")
        result = arr
        return
    }
    
    if diffs.count > k {
        return
    }
    
    for i in 1...n {
        if result != nil {
            break
        }
        
        if !used.contains(i) {
            arr.append(i)
            if arr.count > 1 {
                let diff = arr.last! - arr[arr.count - 2]
                if diffs[diff] == nil {
                    diffs[diff] = 1
                } else {
                    diffs[diff]! += 1
                }
            }
            used.insert(i)
            constructArrayBacktracking(n, k, &used, &arr, &result, &diffs)
            if arr.count > 1 {
                let diff = arr.last! - arr[arr.count - 2]
                if diffs[diff] != nil {
                    diffs[diff]! -= 1
                }
                if diffs[diff] == 0 {
                    diffs.removeValue(forKey: diff)
                }
            }
            used.remove(i)
            arr.removeLast()
        }
    }
}

func constructArray(_ n: Int, _ k: Int) -> [Int] {
    var result = [Int]()
    //1 10 2 9 3 4 5 6 7 8 (n = 10, k = 5)
    //10 1 9 2 3 4 5 6 7 8 (n = 10, k = 4)
    var left = 1, right = n
    var kk = k
    if k%2 == 0 {
        result.append(right)
        right -= 1
        kk -= 1
    }
    var addLeft: Bool = true
    for _ in 1 ... kk {
        if addLeft {
            result.append(left)
            left += 1
            addLeft = false
        } else {
            result.append(right)
            right -= 1
            addLeft = true
        }
    }
    
    print("left: \(left), right: \(right)")
    
    if left <= right {
        for i in left ... right {
            result.append(i)
        }
    }
    
    return result
}

/*
 let seq = constructArray(50, 49)
 print(seq)
 var diffs: Set<Int> = []
 seq.enumerated().forEach { (iter) in
 if iter.offset < seq.count - 1 {
 diffs.insert(abs(iter.element - seq[iter.offset + 1]) )
 }
 }
 
 print(diffs)
 print("diffs count: \(diffs.count)")
 */

/*:
 
 ### Remove Duplicates from Sorted Array
 
 Given a sorted array nums, remove the duplicates in-place such that each element appear only once and return the new length.
 
 Do not allocate extra space for another array, you must do this by modifying the input array in-place with O(1) extra memory.
 
 Example 1:
 ````
 Given nums = [1,1,2],
 
 Your function should return length = 2, with the first two elements of nums being 1 and 2 respectively.
 
 It doesn't matter what you leave beyond the returned length.
 ````
 Example 2:
 ````
 Given nums = [0,0,1,1,1,2,2,3,3,4],
 
 Your function should return length = 5, with the first five elements of nums being modified to 0, 1, 2, 3, and 4 respectively.
 
 It doesn't matter what values are set beyond the returned length.
 ````
 Clarification:
 ````
 
 Confused why the returned value is an integer but your answer is an array?
 
 Note that the input array is passed in by reference, which means modification to the input array will be known to the caller as well.
 
 Internally you can think of this:
 
 // nums is passed in by reference. (i.e., without making a copy)
 int len = removeDuplicates(nums);
 
 // any modification to nums in your function would be known by the caller.
 // using the length returned by your function, it prints the first len elements.
 for (int i = 0; i < len; i++) {
 print(nums[i]);
 }
 ````
 */

func removeDuplicates(_ nums: inout [Int]) -> Int {
    if nums.count < 2 {
        return nums.count
    }
    
    var len = 1
    for i in 1..<nums.count {
        if nums[i] != nums[len-1] {
            nums[len] = nums[i]
            len += 1
        }
    }
    return len
}
/*
 var nums = [0,0,1,1,1,2,2,3,3,4]
 print(removeDuplicates(&nums))
 print(nums)
 */

/*:
 ### Triangle
 
 Given a triangle, find the minimum path sum from top to bottom. Each step you may move to adjacent numbers on the row below.
 
 For example, given the following triangle
 ````
 [
 [2],
 [3,4],
 [6,5,7],
 [4,1,8,3]
 ]
 The minimum path sum from top to bottom is 11 (i.e., 2 + 3 + 5 + 1 = 11).
 ````
 
 - Note:
 
 Bonus point if you are able to do this using only O(n) extra space, where n is the total number of rows in the triangle.
 */

func minimumTotal(_ triangle: [[Int]]) -> Int {
    guard triangle.count > 0, triangle[0].count > 0 else {
        return 0
    }
    
    var sums: [Int] = triangle.last!
    var i = triangle.count - 2
    while(i >= 0) {
        var current = triangle[i]
        for (index, num) in current.enumerated() {
            current[index] = num + min(sums[index], sums[index+1])
        }
        sums = current
        i -= 1
    }
    
    return sums[0]
}

/*:
 #### Partition Labels
 
 A string S of lowercase letters is given. We want to partition this string into as many parts as possible so that each letter appears in at most one part, and return a list of integers representing the size of these parts.
 
 Example 1:
 ````
 Input: S = "ababcbacadefegdehijhklij"
 Output: [9,7,8]
 ````
 Explanation:
 ````
 The partition is "ababcbaca", "defegde", "hijhklij".
 This is a partition so that each letter appears in at most one part.
 A partition like "ababcbacadefegde", "hijhklij" is incorrect, because it splits S into less parts.
 ````
 - Note:
 
 S will have length in range [1, 500].
 S will consist of lowercase letters ('a' to 'z') only.
 */
func partitionLabels(_ S: String) -> [Int] {
    if S.count == 0 {
        return [0]
    }
    var partitionsDict: [Set<Character>] = []
    var partitionsLenList: [Int] = []
    for char in S {
        print("Char: \(char)")
        var duplicateChar = false
        if partitionsDict.count == 0 {
            var newLabel = Set<Character>()
            newLabel.insert(char)
            partitionsDict.append(newLabel)
            partitionsLenList.append(1)
            continue
        }
        for i in 0..<partitionsDict.count {
            if partitionsDict[i].contains(char) {
                var j = partitionsDict.count - 1
                while j > i {
                    print("PartitionsDict[\(j)] : \(partitionsDict[j])")
                    partitionsDict[i] = partitionsDict[i].union(partitionsDict[j])
                    partitionsLenList[i] += partitionsLenList[j]
                    partitionsDict.removeLast()
                    partitionsLenList.removeLast()
                    j -= 1
                }
                duplicateChar = true
                partitionsLenList[i] += 1
                print("New partitionDict: \(partitionsDict)")
                break
            }
        }
        if !duplicateChar {
            var newLabel = Set<Character>()
            newLabel.insert(char)
            partitionsDict.append(newLabel)
            partitionsLenList.append(1)
        }
        print("PartitionDict: \(partitionsDict)")
        print("PartitionLenList: \(partitionsLenList)\n")
    }
    
    return partitionsLenList
}

//print(partitionLabels("ababcbacadefegdehijhklij"))
/*:
 
 ### Integer Break
 Given a positive integer n, break it into the sum of at least two positive integers and maximize the product of those integers. Return the maximum product you can get.
 
 For example, given n = 2, return 1 (2 = 1 + 1); given n = 10, return 36 (10 = 3 + 3 + 4).
 
 - Note: You may assume that n is not less than 2 and not larger than 58.
 */

func integerBreak(_ n: Int) -> Int {
    var maxList = [0,1,1]
    var nn = 3
    while nn > 2 && nn <= n {
        print("nn:\(nn)")
        var i = 1
        var maxPro = 1
        while i <= nn/2 {
            print("i:\(i)")
            maxPro = max(maxPro, max(i, maxList[i]) * max(nn-i, maxList[nn-i]))
            print("current: \(max(i, maxList[i]) * max(nn-i, maxList[nn-i])), max: \(maxPro)")
            i += 1
        }
        maxList.append(maxPro)
        nn += 1
        print("\n")
    }
    return maxList[n]
}

//print(integerBreak(50))

class TreeNode: CustomStringConvertible {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    
    @discardableResult
    func addValue( _ newValue:Int) -> TreeNode
    {
        if newValue == val // exclude duplicate entries
        { return self }
        else if newValue < val
        {
            if let newNode = left?.addValue(newValue)
            { return newNode }
            left = TreeNode(newValue)
            return left!
        }
        else
        {
            if let newNode = right?.addValue(newValue)
            { return newNode }
            right = TreeNode(newValue)
            return right!
        }
    }
    
    var description: String {
        return treeString(self){("\($0.val)",$0.left,$0.right)}
    }
    
    public func treeString<T>(_ node:T, reversed:Bool=false, isTop:Bool=true, using nodeInfo:(T)->(String,T?,T?)) -> String
    {
        // node value string and sub nodes
        let (stringValue, leftNode, rightNode) = nodeInfo(node)
        
        let stringValueWidth  = stringValue.count
        
        // recurse to sub nodes to obtain line blocks on left and right
        let leftTextBlock     = leftNode  == nil ? []
            : treeString(leftNode!,reversed:reversed,isTop:false,using:nodeInfo)
                .components(separatedBy:"\n")
        
        let rightTextBlock    = rightNode == nil ? []
            : treeString(rightNode!,reversed:reversed,isTop:false,using:nodeInfo)
                .components(separatedBy:"\n")
        
        // count common and maximum number of sub node lines
        let commonLines       = min(leftTextBlock.count,rightTextBlock.count)
        let subLevelLines     = max(rightTextBlock.count,leftTextBlock.count)
        
        // extend lines on shallower side to get same number of lines on both sides
        let leftSubLines      = leftTextBlock
            + Array(repeating:"", count: subLevelLines-leftTextBlock.count)
        let rightSubLines     = rightTextBlock
            + Array(repeating:"", count: subLevelLines-rightTextBlock.count)
        
        // compute location of value or link bar for all left and right sub nodes
        //   * left node's value ends at line's width
        //   * right node's value starts after initial spaces
        let leftLineWidths    = leftSubLines.map{$0.count}
        let rightLineIndents  = rightSubLines.map{$0.prefix{$0==" "}.count  }
        
        // top line value locations, will be used to determine position of current node & link bars
        let firstLeftWidth    = leftLineWidths.first   ?? 0
        let firstRightIndent  = rightLineIndents.first ?? 0
        
        
        // width of sub node link under node value (i.e. with slashes if any)
        // aims to center link bars under the value if value is wide enough
        //
        // ValueLine:    v     vv    vvvvvv   vvvvv
        // LinkLine:    / \   /  \    /  \     / \
        //
        let linkSpacing       = min(stringValueWidth, 2 - stringValueWidth % 2)
        let leftLinkBar       = leftNode  == nil ? 0 : 1
        let rightLinkBar      = rightNode == nil ? 0 : 1
        let minLinkWidth      = leftLinkBar + linkSpacing + rightLinkBar
        let valueOffset       = (stringValueWidth - linkSpacing) / 2
        
        // find optimal position for right side top node
        //   * must allow room for link bars above and between left and right top nodes
        //   * must not overlap lower level nodes on any given line (allow gap of minSpacing)
        //   * can be offset to the left if lower subNodes of right node
        //     have no overlap with subNodes of left node
        let minSpacing        = 2
        let rightNodePosition = zip(leftLineWidths,rightLineIndents[0..<commonLines])
            .reduce(firstLeftWidth + minLinkWidth)
            { max($0, $1.0 + minSpacing + firstRightIndent - $1.1) }
        
        
        // extend basic link bars (slashes) with underlines to reach left and right
        // top nodes.
        //
        //        vvvvv
        //       __/ \__
        //      L       R
        //
        let linkExtraWidth    = max(0, rightNodePosition - firstLeftWidth - minLinkWidth )
        let rightLinkExtra    = linkExtraWidth / 2
        let leftLinkExtra     = linkExtraWidth - rightLinkExtra
        
        // build value line taking into account left indent and link bar extension (on left side)
        let valueIndent       = max(0, firstLeftWidth + leftLinkExtra + leftLinkBar - valueOffset)
        let valueLine         = String(repeating:" ", count:max(0,valueIndent))
            + stringValue
        let slash             = reversed ? "\\" : "/"
        let backSlash         = reversed ? "/"  : "\\"
        let uLine             = reversed ? "¯"  : "_"
        // build left side of link line
        let leftLink          = leftNode == nil ? ""
            : String(repeating: " ", count:firstLeftWidth)
            + String(repeating: uLine, count:leftLinkExtra)
            + slash
        
        // build right side of link line (includes blank spaces under top node value)
        let rightLinkOffset   = linkSpacing + valueOffset * (1 - leftLinkBar)
        let rightLink         = rightNode == nil ? ""
            : String(repeating:  " ", count:rightLinkOffset)
            + backSlash
            + String(repeating:  uLine, count:rightLinkExtra)
        
        // full link line (will be empty if there are no sub nodes)
        let linkLine          = leftLink + rightLink
        
        // will need to offset left side lines if right side sub nodes extend beyond left margin
        // can happen if left subtree is shorter (in height) than right side subtree
        let leftIndentWidth   = max(0,firstRightIndent - rightNodePosition)
        let leftIndent        = String(repeating:" ", count:leftIndentWidth)
        let indentedLeftLines = leftSubLines.map{ $0.isEmpty ? $0 : (leftIndent + $0) }
        
        // compute distance between left and right sublines based on their value position
        // can be negative if leading spaces need to be removed from right side
        let mergeOffsets      = indentedLeftLines
            .map{$0.count}
            .map{leftIndentWidth + rightNodePosition - firstRightIndent - $0 }
            .enumerated()
            .map{ rightSubLines[$0].isEmpty ? 0  : $1 }
        
        
        // combine left and right lines using computed offsets
        //   * indented left sub lines
        //   * spaces between left and right lines
        //   * right sub line with extra leading blanks removed.
        let mergedSubLines    = zip(mergeOffsets.enumerated(),indentedLeftLines)
            .map{ ( $0.0, $0.1, $1 + String(repeating:" ", count:max(0,$0.1)) ) }
            .map{ $2 + String(rightSubLines[$0].dropFirst(max(0,-$1))) }
        
        // Assemble final result combining
        //  * node value string
        //  * link line (if any)
        //  * merged lines from left and right sub trees (if any)
        let treeLines = [leftIndent + valueLine]
            + (linkLine.isEmpty ? [] : [leftIndent + linkLine])
            + mergedSubLines
        
        return (reversed && isTop ? treeLines.reversed(): treeLines)
            .joined(separator:"\n")
    }
}

/*:
 
 ### Unique Binary Search Trees II
 
 Given an integer n, generate all structurally unique BST's (binary search trees) that store values 1 ... n.
 
 Example:
 ````
 Input: 3
 Output:
 [
 [1,null,3,2],
 [3,2,null,1],
 [3,1,null,null,2],
 [2,1,3],
 [1,null,2,null,3]
 ]
 Explanation:
 The above output corresponds to the 5 unique BST's shown below:
 
 1         3     3      2      1
 \       /     /      / \      \
 3     2     1      1   3      2
 /     /       \                 \
 2     1         2                 3
 ````
 */
func generateTrees(_ n: Int) -> [TreeNode?] {
    return generateTrees(1, n)
}

func generateTrees(_ left: Int, _ right: Int) ->[TreeNode?] {
    if left > right {
        return [nil]
    }
    if left == right {
        return [TreeNode(left)]
    }
    
    var trees: [TreeNode?] = []
    for i in left...right {
        
        let leftTrees = generateTrees(left, i-1)
        let rightTrees = generateTrees(i+1, right)
        for leftTree in leftTrees {
            for rightTree in rightTrees {
                let root = TreeNode(i)
                root.left = leftTree
                root.right = rightTree
                trees.append(root)
            }
        }
    }
    return trees
}

//let trees = generateTrees(4)
//for t in trees {
//    if t != nil {
//        print(t!)
//        print("\n")
//    }
//}

/*:
 
 ### Jewels and Stones
 
 You're given strings J representing the types of stones that are jewels, and S representing the stones you have.  Each character in S is a type of stone you have.  You want to know how many of the stones you have are also jewels.
 
 The letters in J are guaranteed distinct, and all characters in J and S are letters. Letters are case sensitive, so "a" is considered a different type of stone from "A".
 
 Example 1:
 `````
 Input: J = "aA", S = "aAAbbbb"
 Output: 3
 ````
 Example 2:
 ````
 Input: J = "z", S = "ZZ"
 Output: 0
 ````
 - Note:
 
 S and J will consist of letters and have length at most 50.
 The characters in J are distinct.
 */

func numJewelsInStones(_ J: String, _ S: String) -> Int {
    var jSet = Set<Character>()
    J.forEach{jSet.insert($0)}
    var result = 0
    S.forEach({(char) in
        if jSet.contains(char) {
            result += 1
        }
    })
    
    return result
}

/*:
 
 ### Edit Distance
 
 Given two words word1 and word2, find the minimum number of operations required to convert word1 to word2.
 
 You have the following 3 operations permitted on a word:
 
 Insert a character
 Delete a character
 Replace a character
 Example 1:
 ````
 Input: word1 = "horse", word2 = "ros"
 Output: 3
 ````
 Explanation:
 horse -> rorse (replace 'h' with 'r')
 rorse -> rose (remove 'r')
 rose -> ros (remove 'e')
 Example 2:
 ````
 Input: word1 = "intention", word2 = "execution"
 Output: 5
 ````
 Explanation:
 intention -> inention (remove 't')
 inention -> enention (replace 'i' with 'e')
 enention -> exention (replace 'n' with 'x')
 exention -> exection (replace 'n' with 'c')
 exection -> execution (insert 'u')
 */
func minDistance(_ word1: String, _ word2: String) -> Int {
    if word1.count == 0 {
        return word2.count
    }
    if word2.count == 0 {
        return word1.count
    }
    
    var dp = Array(repeating: Array(repeating: 0, count: word2.count), count: word1.count)
    
    for (c, i) in word1.enumerated() {
        for (d, j) in word2.enumerated() {
            print("c:\(c), i:\(i)")
            print("d:\(d), j:\(j)\n")
        }
    }
    
    var i=0
    while i < word1.count {
        defer {
            i += 1
        }
        let a = word1[word1.index(word1.startIndex, offsetBy: i)]
        var j = 0
        while j < word2.count {
            defer {
                j += 1
            }
            let b = word2[word2.index(word2.startIndex, offsetBy: j)]
            print("a: \(a), b: \(b)")
            let diff = a == b ? 0 : 1
            if i == 0, j == 0 {
                dp[i][j] = diff
                continue
            }
            
            if i == 0 {
                dp[i][j] = dp[i][j-1] + diff
                continue
            }
            if j == 0 {
                dp[i][j] = dp[i-1][j] + diff
                continue
            }
            
            dp[i][j] = min(min(dp[i-1][j-1], dp[i][j-1]), dp[i-1][j]) + diff
        }
    }
    return dp[word1.count-1][word2.count-1]
}

//print(minDistance("intention", "execution"))
/*:
 
 ### Friend Circles
 
 There are N students in a class. Some of them are friends, while some are not. Their friendship is transitive in nature. For example, if A is a direct friend of B, and B is a direct friend of C, then A is an indirect friend of C. And we defined a friend circle is a group of students who are direct or indirect friends.
 
 Given a N*N matrix M representing the friend relationship between students in the class. If M[i][j] = 1, then the ith and jth students are direct friends with each other, otherwise not. And you have to output the total number of friend circles among all the students.
 
 Example 1:
 ````
 Input:
 [[1,1,0],
 [1,1,0],
 [0,0,1]]
 Output: 2
 ````
 Explanation:The 0th and 1st students are direct friends, so they are in a friend circle.
 The 2nd student himself is in a friend circle. So return 2.
 Example 2:
 ````
 Input:
 [[1,1,0],
 [1,1,1],
 [0,1,1]]
 Output: 1
 ````
 Explanation:The 0th and 1st students are direct friends, the 1st and 2nd students are direct friends,
 so the 0th and 2nd students are indirect friends. All of them are in the same friend circle, so return 1.
 - Note:
 N is in range [1,200].
 M[i][i] = 1 for all students.
 If M[i][j] = 1, then M[j][i] = 1.
 */

func findCircleNum(_ M: [[Int]]) -> Int {
    guard M.count > 0, M[0].count > 0 else {
        return 0
    }
    
    var visited: [Bool] = Array(repeating: false, count: M.count)
    var circles = 0
    for i in 0..<M.count {
        if !visited[i] {
            circles += 1
            findFriends(M, &visited, i)
        }
    }
    return circles
}

func findFriends(_ M:[[Int]], _ visited: inout [Bool], _ friend: Int) {
    guard M.count > 0, M[0].count > 0 else {
        return
    }
    
    if visited[friend] == true {
        return
    }
    
    visited[friend] = true
    
    for i in 0..<M[friend].count {
        if M[friend][i] == 1 {
            findFriends(M, &visited, i)
        }
    }
}
/*
 print(findCircleNum([[1,0,0,1],
 [0,1,1,0],
 [0,1,1,1],
 [1,0,1,1]]))
 */

func largestNumber(_ nums: [Int]) -> String {
    var numsSorted = nums
    numsSorted.sort { (left, right) -> Bool in
        return combineTwoNum(left, right) > combineTwoNum(right, left)
    }
    
    var result = numsSorted.reduce(""){$0 + String($1)}
    
    while result.first == "0" {
        result.removeFirst()
    }
    return result == "" ? "0" : result
}

func combineTwoNum(_ left: Int, _ right: Int) -> Int {
    var base = 10
    while right >= base {
        base *= 10
    }
    return left * base + right
}

//print(largestNumber([3,30,34,5,9]))

/*:
 
 ### House rober
 
 You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed, the only constraint stopping you from robbing each of them is that adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.
 
 Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police.
 
 Example 1:
 
 Input: [1,2,3,1]
 Output: 4
 Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3).
 Total amount you can rob = 1 + 3 = 4.
 Example 2:
 
 Input: [2,7,9,3,1]
 Output: 12
 Explanation: Rob house 1 (money = 2), rob house 3 (money = 9) and rob house 5 (money = 1).
 Total amount you can rob = 2 + 9 + 1 = 12.
 */

func rob(_ nums: [Int]) -> Int {
    if nums.count == 0 {
        return 0
    }
    
    var dp = [0,nums[0]]
    
    for i in 1..<nums.count {
        dp.append(max(dp[i], dp[i-1] + nums[i]))
    }
    
    return dp[nums.count]
}

//print(rob([2,7,9,3,1]))

/*:
 ### House Robber II
 
 You are a professional robber planning to rob houses along a street. Each house has a certain amount of money stashed. All houses at this place are arranged in a circle. That means the first house is the neighbor of the last one. Meanwhile, adjacent houses have security system connected and it will automatically contact the police if two adjacent houses were broken into on the same night.
 
 Given a list of non-negative integers representing the amount of money of each house, determine the maximum amount of money you can rob tonight without alerting the police.
 
 Example 1:
 
 Input: [2,3,2]
 Output: 3
 Explanation: You cannot rob house 1 (money = 2) and then rob house 3 (money = 2),
 because they are adjacent houses.
 Example 2:
 
 Input: [1,2,3,1]
 Output: 4
 Explanation: Rob house 1 (money = 1) and then rob house 3 (money = 3).
 Total amount you can rob = 1 + 3 = 4.
 */

func rob2(_ nums: [Int]) -> Int {
    if nums.count == 0 {
        return 0
    }
    
    if nums.count == 1 {
        return nums[0]
    }
    
    return max(rob(Array<Int>(nums.dropFirst())), rob(Array<Int>(nums.dropLast())))
}

//print(rob([2,7,9,3,1]))

/*:
 ### House Robber
 
 The thief has found himself a new place for his thievery again. There is only one entrance to this area, called the "root." Besides the root, each house has one and only one parent house. After a tour, the smart thief realized that "all houses in this place forms a binary tree". It will automatically contact the police if two directly-linked houses were broken into on the same night.
 
 Determine the maximum amount of money the thief can rob tonight without alerting the police.
 
 Example 1:
 3
 / \
 2   3
 \   \
 3   1
 Maximum amount of money the thief can rob = 3 + 3 + 1 = 7.
 Example 2:
 3
 / \
 4   5
 / \   \
 1   3   1
 Maximum amount of money the thief can rob = 4 + 5 = 9.
 */

func rob3(_ root: TreeNode?) -> Int {
    return rob3(root, true)
}

func rob3(_ root: TreeNode?, _ robRoot: Bool) -> Int {
    guard let root = root else {
        return 0
    }
    return max((robRoot ? root.val : 0) + rob3(root.left, false) + rob3(root.right, false), rob3(root.left, true) + rob3(root.right, true))
}


/*:
 
 ### 3 Sum
 
 
 Given an array nums of n integers, are there elements a, b, c in nums such that a + b + c = 0? Find all unique triplets in the array which gives the sum of zero.
 
 Note:
 
 The solution set must not contain duplicate triplets.
 
 Example:
 
 Given array nums = [-1, 0, 1, 2, -1, -4],
 
 A solution set is:
 [
 [-1, 0, 1],
 [-1, -1, 2]
 ]
 */

func threeSum(_ nums: [Int]) -> [[Int]] {
    var numsCopy = nums.sorted()
    guard numsCopy.count >= 3 else {
        return []
    }
    var rst = [[Int]]()
    for i in 0..<numsCopy.count - 2 {
        if i>0, numsCopy[i] == numsCopy[i-1] {
            continue
        }
        var left = i+1
        var right = numsCopy.count - 1
        while left < right {
            let sum = numsCopy[i] + numsCopy[left] + numsCopy[right]
            if sum == 0 {
                rst.append([numsCopy[i], numsCopy[left], numsCopy[right]])
            }
            if sum <= 0 {
                left += 1
                while left < right, numsCopy[left] == numsCopy[left + 1]  {
                    print("left: \(left), ->")
                    left += 1
                }
            }
            if sum >= 0 {
                right -= 1
                while left < right, numsCopy[right] == numsCopy[right - 1] {
                    print("right: \(right), <-")
                    right -= 1
                }
            }
        }
    }
    return rst
}
//print(threeSum([-1,0,1,2,-1,-4]))

/*:
 ### serialize and deserialize of binary tree
 Serialization is the process of converting a data structure or object into a sequence of bits so that it can be stored in a file or memory buffer, or transmitted across a network connection link to be reconstructed later in the same or another computer environment.
 
 Design an algorithm to serialize and deserialize a binary tree. There is no restriction on how your serialization/deserialization algorithm should work. You just need to ensure that a binary tree can be serialized to a string and this string can be deserialized to the original tree structure.
 
 Example:
 
 You may serialize the following tree:
 
 1
 / \
 2   3
 / \
 4   5
 
 as "[1,2,3,null,null,4,5]"
 Clarification: The above format is the same as how LeetCode serializes a binary tree. You do not necessarily need to follow this format, so please be creative and come up with different approaches yourself.
 
 Note: Do not use class member/global/static variables to store states. Your serialize and deserialize algorithms should be stateless.
 */

/*:
 ### Merge k Sorted Array
 Merge k sorted linked lists and return it as one sorted list. Analyze and describe its complexity.
 
 Example:
 ````
 Input:
 [
 1->4->5,
 1->3->4,
 2->6
 ]
 Output: 1->1->2->3->4->4->5->6
 ````
 */
public class ListNode: CustomStringConvertible {
    public var val: Int
    public var next: ListNode?
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    
    public func insert(_ value: Int) -> ListNode {
        self.next = ListNode(value)
        return self.next!
    }
    
    public var description: String {
        get {
            var str = String(val)
            if next != nil {
                str += " -> " + next!.description
            }
            return str
        }
    }
}
func mergeKLists(_ lists: [ListNode?]) -> ListNode? {
    var nodes = lists
    if nodes.count == 0 {return nil}
    var head = ListNode(0)
    var cur = head
    var minNode: Int?
    var minIndex: Int = -1
    repeat {
        minNode = nil
        for i in 0..<nodes.count {
            if nodes[i] == nil {
                continue
            }
            
            print("Node value: \(nodes[i]!.val)")
            print("Min Node value: \(minNode)")
            if minNode == nil || minNode! > nodes[i]!.val {
                minNode = nodes[i]!.val
                minIndex = i
                print("find new min")
            }
        }
        print("")
        if minNode != nil {
            nodes[minIndex] = nodes[minIndex]!.next
            cur.next = ListNode(minNode!)
            cur = cur.next!
        }
    } while minNode != nil
    return head.next
}
/*
 var linked1 = ListNode(1)
 linked1.insert(4).insert(5)
 var linked2 = ListNode(1)
 linked2.insert(3).insert(4)
 var linked3 = ListNode(2)
 linked3.insert(6)
 print(mergeKLists([linked1, linked2, linked3]) ?? "nil")
 */

/*:
 ### Sum of Distance tree
 An undirected, connected tree with N nodes labelled 0...N-1 and N-1 edges are given.
 
 The ith edge connects nodes edges[i][0] and edges[i][1] together.
 
 Return a list ans, where ans[i] is the sum of the distances between node i and all other nodes.
 
 Example 1:
 
 Input: N = 6, edges = [[0,1],[0,2],[2,3],[2,4],[2,5]]
 Output: [8,12,6,10,10,10]
 Explanation:
 Here is a diagram of the given tree:
 0
 / \
 1   2
 /|\
 3 4 5
 We can see that dist(0,1) + dist(0,2) + dist(0,3) + dist(0,4) + dist(0,5)
 equals 1 + 1 + 2 + 2 + 2 = 8.  Hence, answer[0] = 8, and so on.
 Note: 1 <= N <= 10000
 */

func sumOfDistancesInTree(_ N: Int, _ edges: [[Int]]) -> [Int] {
    var graph = [Int: [Int]]()
    edges.forEach{ edge in
        let s = edge[0], d = edge[1]
        if graph[s] == nil {
            graph[s] = Array<Int>()
        }
        graph[s]!.append(d)
        if graph[d] == nil {
            graph[d] = Array<Int>()
        }
        graph[d]!.append(s)
    }
    
    print("Graph: \(graph)")
    
    var result = [Int]()
    for i in 0..<N {
        var sumDistance = 0
        for j in 0..<N {
            if i != j {
                print("finding: \(i) -> \(j)")
                var visited = Array(repeating: false, count: N)
                sumDistance += distance(i, j, graph, &visited)
                print("distance: \(sumDistance)")
                print("")
            }
        }
        result.append(sumDistance)
    }
    return result
}

func distance(_ a: Int, _ b: Int, _ graph: [Int:[Int]], _ visited: inout [Bool]) -> Int {
    print("passing: \(a)")
    guard let list = graph[a] else {
        return -1
    }
    
    if list.contains(b) {return 1}
    
    visited[a] = true
    for node in list {
        if !visited[node] {
            let d = distance(node, b, graph, &visited)
            if d != -1 {
                return d + 1
            }
        }
    }
    return -1
}

//print(sumOfDistancesInTree(6, [[0,1],[0,2],[2,3],[2,4],[2,5]]))

/*:
 ### Find minimum in a rotated sorted array I && II
 
 Suppose an array sorted in ascending order is rotated at some pivot unknown to you beforehand.
 
 (i.e.,  [0,1,2,4,5,6,7] might become  [4,5,6,7,0,1,2]).
 
 Find the minimum element.
 
 The array may contain duplicates.
 
 Example 1:
 ````
 Input: [1,3,5]
 Output: 1
 ````
 Example 2:
 ````
 Input: [2,2,2,0,1]
 Output: 0
 ````
 - Note:
 
 This is a follow up problem to Find Minimum in Rotated Sorted Array.
 Would allow duplicates affect the run-time complexity? How and why?
 */

func findMin(_ nums: [Int]) -> Int {
    var left = 0, right = nums.count-1
    while left < right-1 {
        if nums[left] < nums[right] {
            break
        }
        let mid = (left + right)/2
        if nums[mid] > nums[left], nums[mid] > nums[right] {
            left = mid
        } else if nums[mid] < nums[left], nums[mid] < nums[right] {
            right = mid
        }
    }
    return min(nums[left], nums[right])
}

func findMin2(_ nums: [Int]) -> Int {
    return findMin(nums, 0, nums.count-1)
}

func findMin(_ nums: [Int], _ left: Int, _ right: Int) -> Int {
    if left > right {
        return .max
    }
    if left == right {
        return nums[left]
    }
    if nums[left] < nums[right] {
        return nums[left]
    }
    
    var mid = (left + right)/2
    if nums[left] > nums[mid], nums[mid] > nums[right] {
        return nums[right]
    }
    return min(findMin(nums, left, mid), findMin(nums, mid + 1, right))
}
//print(findMin2([10,10,10,-10,-10,-10,-10,-9,-9,-9,-9,-9,-9,-9,-8,-8,-8,-8,-8,-8,-8,-8,-7,-7,-7,-7,-6,-6,-6,-5,-5,-5,-4,-4,-4,-4,-3,-3,-2,-2,-2,-2,-2,-2,-2,-2,-1,-1,-1,-1,-1,0,0,0,0,0,0,0,1,1,1,1,2,2,2,2,2,2,2,3,3,3,4,4,4,5,5,5,5,6,6,6,7,7,7,7,7,8,8,8,8,9,9,9,9,9,9,9,10,10]))

/*:
 ### Construct Binary Tree from Preorder and Inorder Traversal
 
 Given preorder and inorder traversal of a tree, construct the binary tree.
 
 - Note:
 You may assume that duplicates do not exist in the tree.
 
 For example, given
 ````
 preorder = [3,9,20,15,7]
 inorder = [9,3,15,20,7]
 Return the following binary tree:
 
 3
 / \
 9  20
 /  \
 15   7
 ````
 */

func buildTree(_ preorder: [Int], _ inorder: [Int]) -> TreeNode? {
    return buildTree(preorder, 0, preorder.count-1, inorder, 0, inorder.count-1)
}
func buildTree(_ preorder: [Int], _ pLeft: Int, _ pRight: Int, _ inorder: [Int], _ iLeft: Int, _ iRight: Int) -> TreeNode? {
    if preorder.count == 0 || inorder.count == 0 {
        return nil
    }
    if pLeft > pRight || pRight - pLeft != iRight - iLeft {
        return nil
    }
    
    var root = TreeNode(preorder[pLeft])
    var index = iLeft
    for i in iLeft...iRight {
        if inorder[i] == preorder[pLeft] {
            index = i
            break
        }
    }
    root.left = buildTree(preorder, pLeft + 1, index - iLeft + pLeft, inorder, iLeft, index - 1)
    root.right = buildTree(preorder, pRight - iRight + index + 1, pRight, inorder, index + 1, iRight)
    return root
}

//print(buildTree([3,9,20,15,7], [9,3,15,20,7]) ?? "nil")

/*:
 ### Minimum Path Sum
 Given a m x n grid filled with non-negative numbers, find a path from top left to bottom right which minimizes the sum of all numbers along its path.
 
 Note: You can only move either down or right at any point in time.
 
 Example:
 ````
 Input:
 [
 [1,3,1],
 [1,5,1],
 [4,2,1]
 ]
 Output: 7
 ````
 Explanation: Because the path 1→3→1→1→1 minimizes the sum.
 */
func minPathSum(_ grid: [[Int]]) -> Int {
    guard grid.count > 0 else {
        return 0
    }
    
    var dp = grid
    for i in 0..<grid.count {
        for j in 0..<grid[i].count {
            if i == 0, j == 0 {
                continue
            }
            if i == 0 {
                dp[i][j] += dp[i][j-1]
                continue
            }
            if j == 0 {
                dp[i][j] += dp[i-1][j]
                continue
            }
            
            dp[i][j] += min(dp[i-1][j], dp[i][j-1])
        }
    }
    print(dp)
    return dp.last!.last!
}

//print(minPathSum([[1,3,1],[1,5,1],[4,2,1]]))
extension String {
    public subscript(_ index: Int) -> Character {
        return self[self.index(startIndex, offsetBy: index)]
    }
    
    public subscript(_ range: Range<Int>) -> String {
        return String(self[index(startIndex, offsetBy: range.lowerBound)..<index(startIndex, offsetBy: range.upperBound)])
    }
    
    public subscript(_ range: ClosedRange<Int>) -> String {
        return String(self[index(startIndex, offsetBy: range.lowerBound)...index(startIndex, offsetBy: range.upperBound)])
    }
}

/*:
 ### Group Anagrams
 Given an array of strings, group anagrams together.
 Example:
 ````
 Input: ["eat", "tea", "tan", "ate", "nat", "bat"],
 Output:
 [
 ["ate","eat","tea"],
 ["nat","tan"],
 ["bat"]
 ]
 ````
 - Note:
 * All inputs will be in lowercase.
 * The order of your output does not matter.
 */

func groupAnagrams(_ strs: [String]) -> [[String]] {
    let strsCopy = strs.map{String($0.sorted())}
    let map = strsCopy.enumerated().reduce(into: [String: [Int]]()){$0[$1.element, default: []].append($1.offset)}
    return map.map{$0.value.reduce(into: [String]()){$0.append(strs[$1])}}
}

print(groupAnagrams(["eat", "tea", "tan", "ate", "nat", "bat"]))
