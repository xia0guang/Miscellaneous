//: Playground - noun: a place where people can play

import Cocoa

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
    var flightsDict = flights.reduce(into: [Int: [(d: Int, p: Int)]]()) { $0[$1[0], default: [(d: Int, p: Int)]()].append(($1[1], $1[2]))}
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
            print("possible flights: \(allFlights), total price: \(e.p + price)")
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

//Queue with fixed length array
protocol Queue {
    var count: Int {get}
    mutating func offer(e: Int)
    mutating func poll() -> Int?
}

struct QueueWithArray: Queue {
    private var headList: NSMutableArray
    private var tailList: NSMutableArray
    var count: Int
    private var head: Int
    private var tail: Int
    
    private let MAX_PER_LIST: Int
    
    init(_ fixedSize: Int) {
        self.MAX_PER_LIST = fixedSize
        self.count = 0
        self.head = 0
        self.tail = -1
        self.headList = NSMutableArray(capacity: fixedSize)
        self.tailList = headList
    }
    
    mutating func offer(e: Int) {
        print("queue: \(tailList)")
        if tail < self.MAX_PER_LIST - 2 {
            tail += 1
        } else {
            self.tailList.add(NSMutableArray(capacity: self.MAX_PER_LIST))
            self.tailList = self.tailList[tail+1] as! NSMutableArray
            self.tail = 0
        }
        self.tailList.add(e)
        count += 1
        print("head: \(headList)")
    }
    mutating func poll() -> Int? {
        if count == 0 {
            return nil
        }
        
        let rst = self.headList[head] as? Int
        head += 1
        if head == MAX_PER_LIST - 1 {
            self.headList = headList[head] as! NSMutableArray
            head = 0
        }
        
        count -= 1
        print("head after poll: \(headList)")
        return rst
    }
}
/*
var q = QueueWithArray(3)
q.offer(e: 3)
q.offer(e: 4)
q.offer(e: 5)
q.offer(e: 6)
q.offer(e: 7)
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
print("poll: \(q.poll() ?? 0)")
*/
 

//Travel Buddy
struct Buddy: CustomStringConvertible {
    let name: String
    let similarity: Double
    let wishList: [String]
    
    var description: String {
        get {
            return """
            name: \(self.name),
            similarity: \(self.similarity),
            wishList: \(self.wishList.description)
            """
        }
    }
}

class Solution2 {
    var buddyList: [Buddy]
    var myWishList: [String]
    init(_ wishList: [String], _ friendsWishlists: [String: [String]]) {
        self.buddyList = []
        self.myWishList = wishList
        let wishSet = Set<String>(self.myWishList)
        friendsWishlists.forEach { iter in
            let list = iter.value
            let similarity = Double(list.reduce(0){$0 + (wishSet.contains($1) ? 1 : 0)}) / Double(wishList.count)
            if similarity >= 0.5 {
                buddyList.append(Buddy(name: iter.key, similarity: similarity, wishList: list))
            }
        }
    }
    
    func getSortedBuddyList() -> [Buddy] {
        return self.buddyList.sorted{$0.similarity > $1.similarity}
    }
    
    func recommend(_ max: Int) -> [String] {
        let buddies = self.getSortedBuddyList()
        let wishSet = Set<String>(self.myWishList)
        var result = Set<String>()
        for buddy in buddies {
            if result.count < max {
                for city in buddy.wishList {
                    if result.count < max {
                        if !wishSet.contains(city) {
                            result.insert(city)
                        }
                    }
                }
            }
        }
        return Array<String>(result)
    }
}
//let s = Solution2(["a", "b", "c", "d"], ["1": ["a", "d", "e", "f"], "2":["a", "d", "c", "g"] ])
//print("buddy list:\n\(s.getSortedBuddyList())")
//print("recommend list:\n\(s.recommend(2))")


//Palindrome pair

extension String {
    subscript(_ index: Int) -> Character {
        let stringIndex = self.index(self.startIndex, offsetBy: index)
        return self[stringIndex]
    }
    
    subscript(_ range: Range<Int>) -> String {
        let lowerIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upperIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[lowerIndex..<upperIndex])
    }
    
    subscript(_ range: ClosedRange<Int>) -> String {
        let lowerIndex = self.index(self.startIndex, offsetBy: range.lowerBound)
        let upperIndex = self.index(self.startIndex, offsetBy: range.upperBound)
        return String(self[lowerIndex...upperIndex])
    }
    
    func isPal() -> Bool {
        for i in 0..<self.count/2 {
            if self[i] != self[self.count-i-1] {
                return false
            }
        }
        return true
    }
}

class Solution3 {
    func palindromePair(_ wordList: [String]) -> [(Int, Int)] {
        var result = [(Int, Int)]()
        var wordMap = wordList.enumerated().reduce(into: [String: Int]()) {$0[$1.element] = $1.offset}
        
        for i in 0..<wordList.count {
            let word = wordList[i]
            let len = word.count
            for j in 0..<len {
                let preSub = word[0..<j]
                let postSub = word[j..<len]
                
                if preSub.isPal() {
                    let postSubReversed = String(postSub.reversed())
                    if wordMap[postSubReversed] != nil, wordMap[postSubReversed] != i {
                        result.append((wordMap[postSubReversed]!, i))
                    }
                }
                
                if postSub.isPal() {
                    let preSubReversed = String(preSub.reversed())
                    if wordMap[preSubReversed] != nil, wordMap[preSubReversed] != i, postSub.count != 0 {
                        result.append((i, wordMap[preSubReversed]!))
                    }
                }
            }
        }
        return result
    }
}
//print("Palindrome pair: \(Solution3().palindromePair(["abcd", "dcba", "lls", "s", "sssll"]))")

func findMedianInLargeFile(_ list: [Int]) -> Int {
    if list.count%2 == 1 {
        return findMedianInLargeFileHelper(list, Int.min, Int.max)
    } else {
        return (findMedianInLargeFileHelper(list[1..<list.count as! Range], Int.min, Int.max) +
        findMedianInLargeFileHelper(list[0..<list.count-1 as! Range], Int.min, Int.max))/2
    }
}

func findMedianInLargeFileHelper(_ list: [Int], _ left: Int, _ right: Int) -> Int {
    var count = 0
    var potionalMin = right
    for num in list {
        if num < (left + right)/2 {
            count += 1
        } else {
            potionalMin = min(potionalMin, num)
        }
    }
    if count == list.count/2 {
        return potionalMin
    } else if count < list.count/2 {
        return findMedianInLargeFileHelper(list, left + 1, right)
    } else {
        return findMedianInLargeFileHelper(list, left, right - 1)
    }
}

//print(findMedianInLargeFile(1,2,4,5,6,3,56,6,1,5,7,2,5,7,2,5))

//Regular expresstion, support '.', '*', '+'
func regularMatch(_ source: String, _ pattern: String) -> Bool {
    if pattern.count == 0 {return source.count == 0}
    if pattern.count == 1 {return source.count == 1 && isMatch(pattern.first!, source.first!)}
    
    let firstMatch = source.count >= 1 && isMatch(source.first!, pattern.first!)
    
    if pattern[2] == Character("*") {
        return regularMatch(source, pattern[2..<pattern.count] || (firstMatch && regularMatch(source[1..<source.count], pattern)))
    } else if pattern[2] == Character("+") {
            
    } else {
        
    }
    
    
}

func isMatch(_ a: Character, _ b: Character) -> Bool {
    return a == b || b == Character(".")
}

print(regularMatch("ab", "ba"))

