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
    return 0
}
