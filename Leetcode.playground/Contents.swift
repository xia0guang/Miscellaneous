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
    for i in 1 ... kk {
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
