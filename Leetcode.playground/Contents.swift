//: Playground - noun: a place where people can play
import UIKit
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
 
 ### Cheapest Flights Within K Stops
 
 There are n cities connected by m flights. Each fight starts from city u and arrives at v with a price w.
 
 Now given all the cities and fights, together with starting city src and the destination dst, your task is to find the cheapest price from src to dst with up to k stops. If there is no such route, output -1.
 
 Example 1:
 ````
 Input:
 n = 3, edges = [[0,1,100],[1,2,100],[0,2,500]]
 src = 0, dst = 2, k = 1
 Output: 200
 ````
 Explanation:
 The graph looks like this:
 
 
 The cheapest price from city 0 to city 2 with at most 1 stop costs 200, as marked red in the picture.
 Example 2:
 ````
 Input:
 n = 3, edges = [[0,1,100],[1,2,100],[0,2,500]]
 src = 0, dst = 2, k = 0
 Output: 500
 ````
 Explanation:
 The graph looks like this:
 
 
 The cheapest price from city 0 to city 2 with at most 0 stop costs 500, as marked blue in the picture.
 */

func findCheapestPrice(_ n: Int, _ flights: [[Int]], _ src: Int, _ dst: Int, _ K: Int) -> Int {
    var flightsDict = [Int: [(d: Int, p: Int)]]()
    for list in flights {
        if flightsDict[list[0]] == nil {
            flightsDict[list[0]] = [(list[1], list[2])]
        } else {
            flightsDict[list[0]]!.append((list[1], list[2]))
        }
    }
    for i in 0..<n {
        print("src: \(i), dst: \(flightsDict[i]!.sorted(by: {$0.d < $1.d}))")
    }
    var allFlights: [Int] = [src]
    var cheapest: Int = .max
    var visited: [Bool] = Array(repeating: false, count: n)
    findCheapestPrice(flightsDict, src, dst, K, 0, &cheapest, &visited, &allFlights)
    return cheapest == .max ? -1 : cheapest
}

func findCheapestPrice( _ flights: [Int: [(d: Int, p: Int)]], _ src: Int, _ dst: Int, _ k: Int, _ price: Int, _ cheapest: inout Int, _ visited: inout [Bool], _ allFlights: inout [Int]) {
    if k < 0 {
        return
    }
    
    if visited[src] {
        return
    }
    
    if price >= cheapest {
        return
    }
    
    visited[src] = true
    
    guard let avalibleFlights = flights[src] else {
        return
    }
    
    avalibleFlights.enumerated().forEach({ (i,e) in
        allFlights.append(e.d)
        if e.d == dst {
            print("possible flights: \(allFlights)")
            cheapest = min(cheapest, e.p + price)
        }
        findCheapestPrice(flights, e.d, dst, k-1, price + e.p, &cheapest, &visited, &allFlights)
        allFlights.removeLast()
    })
    visited[src] = false
}

//print(findCheapestPrice(17,[[0,12,28],[5,6,39],[8,6,59],[13,15,7],[13,12,38],[10,12,35],[15,3,23],[7,11,26],[9,4,65],[10,2,38],[4,7,7],[14,15,31],[2,12,44],[8,10,34],[13,6,29],[5,14,89],[11,16,13],[7,3,46],[10,15,19],[12,4,58],[13,16,11],[16,4,76],[2,0,12],[15,0,22],[16,12,13],[7,1,29],[7,14,100],[16,1,14],[9,6,74],[11,1,73],[2,11,60],[10,11,85],[2,5,49],[3,4,17],[4,9,77],[16,3,47],[15,6,78],[14,1,90],[10,5,95],[1,11,30],[11,0,37],[10,4,86],[0,8,57],[6,14,68],[16,8,3],[13,0,65],[2,13,6],[5,13,5],[8,11,31],[6,10,20],[6,2,33],[9,1,3],[14,9,58],[12,3,19],[11,2,74],[12,14,48],[16,11,100],[3,12,38],[12,13,77],[10,9,99],[15,13,98],[15,12,71],[1,4,28],[7,0,83],[3,5,100],[8,9,14],[15,11,57],[3,6,65],[1,3,45],[14,7,74],[2,10,39],[4,8,73],[13,5,77],[10,0,43],[12,9,92],[8,2,26],[1,7,7],[9,12,10],[13,11,64],[8,13,80],[6,12,74],[9,7,35],[0,15,48],[3,7,87],[16,9,42],[5,16,64],[4,5,65],[15,14,70],[12,0,13],[16,14,52],[3,10,80],[14,11,85],[15,2,77],[4,11,19],[2,7,49],[10,7,78],[14,6,84],[13,7,50],[11,6,75],[5,10,46],[13,8,43],[9,10,49],[7,12,64],[0,10,76],[5,9,77],[8,3,28],[11,9,28],[12,16,87],[12,6,24],[9,15,94],[5,7,77],[4,10,18],[7,2,11],[9,5,41]],13,4,13))


/*:
 ### Flood Fill
 An image is represented by a 2-D array of integers, each integer representing the pixel value of the image (from 0 to 65535).
 
 Given a coordinate (sr, sc) representing the starting pixel (row and column) of the flood fill, and a pixel value newColor, "flood fill" the image.
 
 To perform a "flood fill", consider the starting pixel, plus any pixels connected 4-directionally to the starting pixel of the same color as the starting pixel, plus any pixels connected 4-directionally to those pixels (also with the same color as the starting pixel), and so on. Replace the color of all of the aforementioned pixels with the newColor.
 
 At the end, return the modified image.
 
 Example 1:
 Input:
 image = [[1,1,1],[1,1,0],[1,0,1]]
 sr = 1, sc = 1, newColor = 2
 Output: [[2,2,2],[2,2,0],[2,0,1]]
 Explanation:
 From the center of the image (with position (sr, sc) = (1, 1)), all pixels connected
 by a path of the same color as the starting pixel are colored with the new color.
 Note the bottom corner is not colored 2, because it is not 4-directionally connected
 to the starting pixel.
 - Note:
 
 The length of image and image[0] will be in the range [1, 50].
 The given starting pixel will satisfy 0 <= sr < image.length and 0 <= sc < image[0].length.
 The value of each color in image[i][j] and newColor will be an integer in [0, 65535].
 */

func printVector<Element>(_ vector: [[Element]]) {
    for list in vector {
        print(list)
    }
    print("\n")
}

func floodFill(_ image: [[Int]], _ sr: Int, _ sc: Int, _ newColor: Int) -> [[Int]] {
    var imageCopy = image
    printVector(imageCopy)
    floodFIll(&imageCopy, image[sr][sc], sr, sc, newColor)
    return imageCopy
}

func floodFIll(_ image: inout [[Int]], _ oldColor: Int, _ r: Int, _ c: Int, _ newColor: Int) {
    if r < 0 || r >= image.count || image.count == 0 || c < 0 || c >= image[0].count {
        return
    }
    
    if image[r][c] == oldColor {
        image[r][c] = newColor + 1
        floodFIll(&image, oldColor, r-1, c, newColor)
        floodFIll(&image, oldColor, r+1, c, newColor)
        floodFIll(&image, oldColor, r, c-1, newColor)
        floodFIll(&image, oldColor, r, c+1, newColor)
        image[r][c] = newColor
    }
}

//printVector(floodFill([[1,1,1],[1,1,0],[1,0,1]], 1, 1, 2))

/*:
 
 ### Combination Sum
 
 Given a set of candidate numbers (candidates) (without duplicates) and a target number (target), find all unique combinations in candidates where the candidate numbers sums to target.
 
 The same repeated number may be chosen from candidates unlimited number of times.
 
 Note:
 
 All numbers (including target) will be positive integers.
 The solution set must not contain duplicate combinations.
 Example 1:
 
 Input: candidates = [2,3,6,7], target = 7,
 A solution set is:
 [
 [7],
 [2,2,3]
 ]
 Example 2:
 
 Input: candidates = [2,3,5], target = 8,
 A solution set is:
 [
 [2,2,2,2],
 [2,3,3],
 [3,5]
 ]
 */

func combinationSum(_ candidates: [Int], _ target: Int) -> [[Int]] {
    var combination = [Int]()
    var result = [[Int]]()
    combinationSum(candidates, target, 0, &combination, &result)
    return result
    
}

func combinationSum(_ candidates: [Int], _ target: Int, _ index: Int, _ combination: inout [Int], _ result: inout [[Int]]) {
    if candidates.count == 0 || index >= candidates.count || target < 0 {
        return
    }
    
    if target == 0 {
        result.append(combination)
        return
    }
    
    for i in index..<candidates.count {
        combination.append(candidates[i])
        combinationSum(candidates, target - candidates[i], i, &combination, &result)
        combination.removeLast()
    }
}

//print(combinationSum([2,3,5], 8))

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
 ### Maximal Square
 
 Given a 2D binary matrix filled with 0's and 1's, find the largest square containing only 1's and return its area.
 
 Example:
 
 Input:
 
 1 0 1 0 0
 1 0 1 1 1
 1 1 1 1 1
 1 0 0 1 0
 
 Output: 4
 */

func maximalSquare(_ matrix: [[Character]]) -> Int {
    guard matrix.count != 0, matrix[0].count != 0 else {
        return 0
    }
    
    var dp = Array(repeating: Array(repeating: 0, count: matrix[0].count), count: matrix.count) //height
    var maxSquare = 0
    
    for (i, list) in matrix.enumerated() {
        for (j, ch) in list.enumerated() {
            if ch == "0" {
                dp[i][j] = 0
                continue
            }
            
            if i == 0 || j == 0 {
                dp[i][j] = 1
                
            } else {
                dp[i][j] = min(dp[i-1][j], dp[i][j-1], dp[i-1][j-1]) + 1
            }
            maxSquare = max(maxSquare, dp[i][j] * dp[i][j])
            
        }
    }
    
    return maxSquare
}

//print(maximalSquare([["1","0","1","0","0"],
//                     ["1","0","1","1","1"],
//                     ["1","1","1","1","1"],
//                     ["1","0","0","1","0"]]))

/*:
 
 ### Regular Expression Matching
 
 Given an input string (s) and a pattern (p), implement regular expression matching with support for '.' and '*'.
 
 '.' Matches any single character.
 '*' Matches zero or more of the preceding element.
 The matching should cover the entire input string (not partial).
 
 Note:
 
 s could be empty and contains only lowercase letters a-z.
 p could be empty and contains only lowercase letters a-z, and characters like . or *.
 Example 1:
 
 Input:
 s = "aa"
 p = "a"
 Output: false
 Explanation: "a" does not match the entire string "aa".
 Example 2:
 
 Input:
 s = "aa"
 p = "a*"
 Output: true
 Explanation: '*' means zero or more of the precedeng element, 'a'. Therefore, by repeating 'a' once, it becomes "aa".
 Example 3:
 
 Input:
 s = "ab"
 p = ".*"
 Output: true
 Explanation: ".*" means "zero or more (*) of any character (.)".
 Example 4:
 
 Input:
 s = "aab"
 p = "c*a*b"
 Output: true
 Explanation: c can be repeated 0 times, a can be repeated 1 time. Therefore it matches "aab".
 Example 5:
 
 Input:
 s = "mississippi"
 p = "mis*is*p*."
 Output: false
 */

/*:
 ### Text Justification
 
 Given an array of words and a width maxWidth, format the text such that each line has exactly maxWidth characters and is fully (left and right) justified.
 
 You should pack your words in a greedy approach; that is, pack as many words as you can in each line. Pad extra spaces ' ' when necessary so that each line has exactly maxWidth characters.
 
 Extra spaces between words should be distributed as evenly as possible. If the number of spaces on a line do not divide evenly between words, the empty slots on the left will be assigned more spaces than the slots on the right.
 
 For the last line of text, it should be left justified and no extra space is inserted between words.
 
 Note:
 
 A word is defined as a character sequence consisting of non-space characters only.
 Each word's length is guaranteed to be greater than 0 and not exceed maxWidth.
 The input array words contains at least one word.
 Example 1:
 
 Input:
 words = ["This", "is", "an", "example", "of", "text", "justification."]
 maxWidth = 16
 Output:
 [
 "This    is    an",
 "example  of text",
 "justification.  "
 ]
 Example 2:
 
 Input:
 words = ["What","must","be","acknowledgment","shall","be"]
 maxWidth = 16
 Output:
 [
 "What   must   be",
 "acknowledgment  ",
 "shall be        "
 ]
 Explanation: Note that the last line is "shall be    " instead of "shall     be",
 because the last line must be left-justified instead of fully-justified.
 Note that the second line is also left-justified becase it contains only one word.
 Example 3:
 
 Input:
 words = ["Science","is","what","we","understand","well","enough","to","explain",
 "to","a","computer.","Art","is","everything","else","we","do"]
 maxWidth = 20
 Output:
 [
 "Science  is  what we",
 "understand      well",
 "enough to explain to",
 "a  computer.  Art is",
 "everything  else  we",
 "do                  "
 ]
 */
func fullJustify(_ words: [String], _ maxWidth: Int) -> [String] {
    var lines = [String]()
    
    var index = 0
    while index < words.count {
        var lineArr = [words[index]]
        var count = words[index].count
        index += 1
        while index < words.count, count + 1 + words[index].count < maxWidth {
            lineArr.append(words[index])
            count += 1 + words[index].count
            index += 1
        }
        
        print("lineArr: \(lineArr)")
        
        var currentStr = ""
        var currentLen = 0
        if index == words.count {
            for (i, str) in lineArr.enumerated() {
                currentStr += str
                currentLen += str.count
                
                if maxWidth - currentLen > 0 {
                    currentStr += " "
                    currentLen += 1
                }
                
                if i == lineArr.endIndex - 1, maxWidth - currentLen > 0 {
                    currentStr += String(repeating: " ", count: maxWidth - currentLen)
                }
            }
        } else {
            if lineArr.count == 1 {
                let spaces = maxWidth - lineArr[0].count
                currentStr = "\(lineArr[0])\(spaces > 0 ? String(repeating: " ", count: spaces) : "")"
            } else {
                let totalWordsLen = lineArr.reduce(0){$0 + $1.count}
                print("Total words len: \(totalWordsLen)")
                let eachSpaces = (maxWidth - totalWordsLen)/(lineArr.count - 1)
                let eachExtraSpaces = maxWidth - totalWordsLen - eachSpaces * (lineArr.count - 1)
                print("space: \(eachSpaces), extra: \(eachExtraSpaces)")
                for (i, str) in lineArr.enumerated() {
                    currentStr += str
                    currentLen += str.count
                    if i != lineArr.endIndex - 1 {
                        currentStr += String(repeating: " ", count: eachSpaces)
                        currentLen += eachExtraSpaces
                    }
                    if i < eachExtraSpaces {
                        currentStr += " "
                        currentLen += 1
                    }
                }
            }
        }
        print("currentStr: \(currentStr)")
        lines.append(currentStr)
    }
    return lines
}

//print(fullJustify(["Science","is","what","we","understand","well","enough","to","explain","to","a","computer.","Art","is","everything","else","we","do"], 20))

/*:
 ### Pour Water
 
 We are given an elevation map, heights[i] representing the height of the terrain at that index. The width at each index is 1. After V units of water fall at index K, how much water is at each index?
 
 Water first drops at index K and rests on top of the highest terrain or water at that index. Then, it flows according to the following rules:
 
 If the droplet would eventually fall by moving left, then move left.
 Otherwise, if the droplet would eventually fall by moving right, then move right.
 Otherwise, rise at it's current position.
 Here, "eventually fall" means that the droplet will eventually be at a lower level if it moves in that direction. Also, "level" means the height of the terrain plus any water in that column.
 
 
 
 We can assume there's infinitely high terrain on the two sides out of bounds of the array. Also, there could not be partial water being spread out evenly on more than 1 grid block - each unit of water has to be in exactly one block.
 
 
 
 Example 1:
 
 Input: heights = [2,1,1,2,1,2,2], V = 4, K = 3
 Output: [2,2,2,3,2,2,2]
 Explanation:
 #       #
 #       #
 ##  # ###
 #########
 0123456    <- index
 
 The first drop of water lands at index K = 3:
 
 #       #
 #   w   #
 ##  # ###
 #########
 0123456
 
 When moving left or right, the water can only move to the same level or a lower level.
 (By level, we mean the total height of the terrain plus any water in that column.)
 Since moving left will eventually make it fall, it moves left.
 (A droplet "made to fall" means go to a lower height than it was at previously.)
 
 #       #
 #       #
 ## w# ###
 #########
 0123456
 
 Since moving left will not make it fall, it stays in place.  The next droplet falls:
 
 #       #
 #   w   #
 ## w# ###
 #########
 0123456
 
 Since the new droplet moving left will eventually make it fall, it moves left.
 Notice that the droplet still preferred to move left,
 even though it could move right (and moving right makes it fall quicker.)
 
 #       #
 #  w    #
 ## w# ###
 #########
 0123456
 
 #       #
 #       #
 ##ww# ###
 #########
 0123456
 
 After those steps, the third droplet falls.
 Since moving left would not eventually make it fall, it tries to move right.
 Since moving right would eventually make it fall, it moves right.
 
 #       #
 #   w   #
 ##ww# ###
 #########
 0123456
 
 #       #
 #       #
 ##ww#w###
 #########
 0123456
 
 Finally, the fourth droplet falls.
 Since moving left would not eventually make it fall, it tries to move right.
 Since moving right would not eventually make it fall, it stays in place:
 
 #       #
 #   w   #
 ##ww#w###
 #########
 0123456
 
 The final answer is [2,2,2,3,2,2,2]:
 
 #
 #######
 #######
 0123456
 
 
 Example 2:
 
 Input: heights = [1,2,3,4], V = 2, K = 2
 Output: [2,3,3,4]
 Explanation:
 The last droplet settles at index 1, since moving further left would not cause it to eventually fall to a lower height.
 
 
 Example 3:
 
 Input: heights = [3,1,3], V = 5, K = 1
 Output: [4,4,4]
 
 
 - Note:
 
 heights will have length in [1, 100] and contain integers in [0, 99].
 V will be in range [0, 2000].
 K will be in range [0, heights.length - 1].
 */

func pourWater(_ heights: [Int], _ v: Int, _ k: Int) -> [Int] {
    guard heights.count > 0 else {
        return heights
    }
    
    var heightsCopy = heights
    for i in 1...v {
        var l=k, r=k, n=heightsCopy.count
        while l>0, heightsCopy[l] >= heightsCopy[l-1] {l -= 1}
        while l<k, heightsCopy[l] == heightsCopy[l+1] {l += 1}
        while r<n-1, heightsCopy[r] >= heightsCopy[r+1] {r += 1}
        while r>k, heightsCopy[r] == heightsCopy[r-1] {r -= 1}
        l < k ? (heightsCopy[l] += 1) : (heightsCopy[r] += 1)
        print("Pouring \(i)th water: \(heightsCopy)")
    }
    return heightsCopy
}

//print(pourWater([3,1,3], 5, 1))

/*:
 ### Meeting rooms
 
 Given an array of meeting time intervals consisting of start and end times [[s1,e1],[s2,e2],...] (si < ei), determine if a person could attend all meetings.
 
 For example,
 Given [[0, 30],[5, 10],[15, 20]],
 return false.
 */

func canAttendMeetings(_ intervals: [(start: Int, end: Int)]) -> Bool {
    guard intervals.count > 0 else {
        return true
    }
    
    var sortedIntervals = intervals.sorted{$0.start < $1.start}
    for i in 0..<sortedIntervals.count - 1 {
        if sortedIntervals[i].end > sortedIntervals[i+1].start {
            return false
        }
    }
    return true
}

//print(canAttendMeetings([(0, 30),(5, 10),(15, 20)]))

/*:
 ### Meeting Rooms II
 Given an array of meeting time intervals consisting of start and end times [[s1,e1],[s2,e2],...] (si < ei), find the minimum number of conference rooms required.
 
 For example,
 Given [[0, 30],[5, 10],[15, 20]],
 return 2.
 */

func minMeetingRooms(_ intervals: [(start: Int, end: Int)]) -> Int {
    guard intervals.count > 0 else {
        return 0
    }
    
    var starts = (intervals.map{$0.start}).sorted()
    var ends = (intervals.map{$0.end}).sorted()
    var res = 0, endPos = 0
    for i in 0..<intervals.count {
        if starts[i] < ends[endPos] {
            res += 1
        } else {
            endPos += 1
        }
    }
    return res
}

//print(minMeetingRooms([(0,30), (5,15), (15,20)]))

/*:
 ### Number of Connected Components in an Undirected Graph
 
 
 Given n nodes labeled from 0 to n - 1 and a list of undirected edges (each edge is a pair of nodes), write a function to find the number of connected components in an undirected graph.
 
 Example 1:
 
 0          3
 
 |          |
 
 1 --- 2    4
 
 Given n = 5 and edges = [[0, 1], [1, 2], [3, 4]], return 2.
 
 Example 2:
 
 0           4
 
 |           |
 
 1 --- 2 --- 3
 
 Given n = 5 and edges = [[0, 1], [1, 2], [2, 3], [3, 4]], return 1.
 
 Note:
 
 You can assume that no duplicate edges will appear in edges. Since all edges are undirected, [0, 1] is the same as [1, 0] and thus will not appear together in edges.
 */
func countComponents(_ edges: [(Int, Int)], _ n: Int) -> Int {
    guard edges.count > 0 else {
        return 0
    }
    
    var adjecencyList: [Int:[Int]] = [:]
    edges.forEach{ edge in
        if adjecencyList[edge.0] == nil {
            adjecencyList[edge.0] = []
        }
        adjecencyList[edge.0]!.append(edge.1)
        if adjecencyList[edge.1] == nil {
            adjecencyList[edge.1] = []
        }
        adjecencyList[edge.1]!.append(edge.0)
    }
    print("AdjecencyList: \(adjecencyList)")
    var visited = Array<Bool>(repeating: false, count: n)
    var res = 0
    for i in 0..<n {
        if !visited[i] {
            res += 1
            traverse(adjecencyList, i, &visited)
        }
    }
    return res
}
func traverse(_ adjecencyList: [Int:[Int]],_ node: Int, _ visited: inout [Bool]) {
    guard let list = adjecencyList[node], !visited[node] else {
        return
    }
    
    visited[node] = true
    list.forEach{traverse(adjecencyList, $0, &visited)}
}

func countComponentsUnionFind(_ edges: [(Int, Int)], _ n: Int) -> Int {
    var rootArr = (0..<n).map{$0}
    edges.forEach { (edge) in
        let a = edge.0
        let b = edge.1
        let rootB = getRoot(rootArr, b)
        let rootA = getRoot(rootArr, a)
        rootArr[rootB] = rootA
    }
    rootArr.enumerated().forEach{print("\($0.offset): \($0.element)", " ")}
    return rootArr.enumerated().reduce(0) { ($1.offset == $1.element ? 1 : 0) + $0 }
}

func getRoot(_ arr: [Int], _ x: Int) -> Int {
    var xx = x
    while xx != arr[xx] {
        xx = arr[xx]
    }
    return xx
}

//print(countComponentsUnionFind([(0, 1), (1, 2), (3, 4)], 5))

func wizardDistance(_ n: Int, _ edges: [(Int, Int)]) -> Int {
    var ajcencyList = Array(repeating: [Int](), count: n)
    edges.forEach{ajcencyList[$0.0].append($0.1)}
    edges.forEach{ajcencyList[$0.1].append($0.0)}
    print("ajcencyList:")
    ajcencyList.enumerated().forEach{print("\($0.offset): \($0.element)")}
    var visited = Array(repeating: false, count: n)
    var distance = Array(repeating: Int.max, count: n)
    distance[0] = 0
    var queue = [0]
    visited[0] = true
    while queue.count > 0 {
        let count = queue.count
        for _ in 0..<count {
            let cur = queue.removeFirst()
            print("current: \(cur)")
            visited[cur] = true
            let list = ajcencyList[cur]
            for e in list {
                if !visited[e] {
                    print("visiting: \(e)")
                    print("distance: \(distance)")
                    distance[e] = min(distance[e], distance[cur] + (e-cur) * (e-cur))
                    print("distance: \(distance)")
                    if distance[e] < distance[n-1], !queue.contains(e) {
                        queue.append(e)
                        print("append: \(e)")
                    }
                }
            }
        }
    }
    return distance[n-1]
}

//print(wizardDistance(5, [(0,1),(0,2),(0,3),(1,3), (1,4),(2,3),(2,4), (3,4)]))


struct Point {
    let x: Int
    let y: Int
}
struct Rect {
    let l: Point
    let r: Point
}
func intersect(_ a: Rect, _ b: Rect) -> Bool {
    if a.l.x > b.r.x || b.l.x > a.r.x {
        return false
    }
    if a.r.y > b.l.y || b.r.y > a.l.y {
        return false
    }
    return true
}

func findParents(_ parents: [Int], _ i: Int) -> Int {
    var ii = i
    while parents[ii] != ii {
        ii = parents[ii]
    }
    return ii
}

func countIntersect(_ rects: [Rect]) -> Int {
    var parents = (0..<rects.count).map{$0}
    for i in 0..<rects.count - 1 {
        for j in i+1..<rects.count {
            let rectA = rects[i]
            let rectB = rects[j]
            if intersect(rectA, rectB) {
                let rootA = findParents(parents, i)
                let rootB = findParents(parents, j)
                parents[rootB] = rootA
            }
        }
    }
    print("parents: ", terminator: "")
    parents.enumerated().forEach{print("\($0.offset): \($0.element)", terminator: ", ")}
    print(" ")
    return parents.enumerated().reduce(0){($1.offset == $1.element ? 1 : 0) + $0}
}

//print(countIntersect([Rect(l: Point(x: 1, y: 7), r: Point(x: 4, y: 4)),
//                      Rect(l: Point(x: 2, y: 6), r: Point(x: 5, y: 3)),
//                      Rect(l: Point(x: 3, y: 8), r: Point(x: 6, y: 4)),
//                      Rect(l: Point(x: 5, y: 2), r: Point(x: 7, y: 1))]))

func findSteps(_ n: Int, _ dp: inout [Int: Int]) -> Int {
    if n == 1 || n == 0 { return 1}
    if dp[n] != nil {
        return dp[n]!
    }
    if n%2 == 0 {
        dp[n] = 1 + findSteps(n/2, &dp)
    } else {
        dp[n] = 1 + findSteps(3 * n + 1, &dp)
    }
    return dp[n]!
}

func findLongestSteps(_ n: Int) -> Int {
    var dp: [Int: Int] = [:]
    if n < 2 {
        return 0
    }
    var rst = 0
    for i in 2...n {
        let steps = findSteps(i, &dp)
        rst = max(steps, rst)
    }
    return rst
}

//print("long: \(findLongestSteps(1000000))")

func preferenceList(_ lists: [[Int]]) -> [Int] {
    var graph = [Int:[Int]]()
    for list in lists {
        for i in 0..<list.count {
            let prefer = list[i]
            if graph[prefer] == nil {
                graph[prefer] = Array<Int>()
            }
            if i < list.count - 1 {
                graph[prefer]!.append(contentsOf: list[(i+1)...])
            }
        }
    }
    
    var preferenceList: [Int] = []
    var toRemove = graph
    while graph.count != 0 {
        graph.forEach { (pair) in
            pair.value.forEach{toRemove.removeValue(forKey: $0)}
        }
        toRemove.forEach{ pair in
            graph.removeValue(forKey: pair.key)
            preferenceList.append(pair.key)
        }
        toRemove = graph
    }
    return preferenceList
}

//print("\(preferenceList([[3,5,7,9],[2,3,8], [5,8]]))")
class Solution {
    var wordMap: [String: [String]] = [:]
    init(_ words: [String]) {
        var prefixLen = 1
        var prefix: String = ""
        var list: [String] = []
        var maxLen = 0
        while true {
            for i in 0..<words.count {
                let curWord = words[i]
                maxLen = max(maxLen, curWord.count)
                if curWord.count < prefixLen {
                    continue
                }
                let endIndex = curWord.index(curWord.startIndex, offsetBy: prefixLen)
                if prefix == "" {
                    prefix = String(curWord[curWord.startIndex..<endIndex])
                    list.append(curWord)
                } else {
                    if curWord.hasPrefix(prefix) {
                        list.append(curWord)
                    } else {
                        self.wordMap[prefix] = list
                        //Here is the bug, when prefix changed, I forget to put the first word in the list
                        //list = [String]()
                        list = [curWord]
                        prefix = String(curWord[curWord.startIndex..<endIndex])
                    }
                }
            }
            self.wordMap[prefix] = list
            list = []
            prefixLen += 1
            prefix = ""
            if prefixLen > maxLen {
                break
            }
        }
        print(self.wordMap)
    }
    
    func getCandidates(_ prefix: String) -> [String] {
        return self.wordMap[prefix] ?? []
    }
}

let solution = Solution(["ab", "abc", "ac", "ace"])


