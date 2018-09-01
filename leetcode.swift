import Cocoa
import Foundation

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

func minByKey(_ key: String, _ db: [[String: Int]]) -> [String: Int] {
    let dbCopy = db.sorted{($0[key] ?? 0) < ($1[key] ?? 0)}
    if db.count >= 1 {
        return dbCopy[0]
    } else {
        return [:]
    }
}

func maxNumber(_ nums1: [Int], _ nums2: [Int], _ k: Int) -> [Int] {
    if k == 0 {return []}
    var result: [Int] = []
    var i = max(0, k - nums2.count)
    while i <= min(k, nums1.count) {
        print("result: \(result)")
        print("i: \(i)")
        let max1 = maxNumber(nums1, i)
        print("max1: \(max1)")
        let max2 = maxNumber(nums2, k-i)
        print("max2: \(max2)")
        let max12 = maxNumber(max1, max2)
        print("max12: \(max12)")
        if result.lexicographicallyPrecedes(max12) {
            result = max12
        }
        i += 1
    }
    return result
}

func maxNumber(_ nums:[Int], _ k: Int) -> [Int] {
    if k <= 0 {return []}

    var result: [Int] = []
    var to_pop = nums.count - k
    nums.forEach{ num in 
        while !result.isEmpty, to_pop > 0, result.last! < num {
            result.removeLast()
            to_pop -= 1
        }
        result.append(num)
    }
    return [Int](result[result.startIndex..<k])
}

func maxNumber(_ a: [Int], _ b: [Int]) -> [Int] {
    var result: [Int] = []
    var astart = 0, bstart = 0, aend = a.count-1, bend = b.count-1
    while astart <= aend || bstart <= bend {
        if astart > aend {
            return result + b[bstart..<b.endIndex]
        }
        if bstart > bend {
            return result + a[astart..<a.endIndex]
        }
        if a[astart..<a.endIndex].lexicographicallyPrecedes(b[bstart..<b.endIndex]){
            result.append(b[bstart])
            bstart += 1
        } else {
            result.append(a[astart])
            astart += 1
        }
    }
    return result
}

//nums1 = [3, 4, 6, 5]
//nums2 = [9, 1, 2, 5, 8, 3]

// print(maxNumber([3, 4, 6, 5], [9, 1, 2, 5, 8, 3], 5))
// print(maxNumber([3, 4, 6, 5], [9, 1, 2, 5, 8], 5))
func maximumSwap(_ num: Int) -> Int {
    var numArr = num.description.map{Int(String($0))!}
    if numArr.count <= 1 {
        return num
    }


    var i = 1
    var turnIndex = -1
    var maxRight = 0
    var maxRightIndex = -1
    var mostLeftIndex = -1

    while i < numArr.count {
        let previous = numArr[i-1]
        let cur = numArr[i]
        if turnIndex < 0 {
            if previous < cur {
                turnIndex = i-1
                i -= 1
            }
        } else {
            if maxRight <= cur {
                maxRight = cur
                maxRightIndex = i
            }
        }
        i += 1
    }

    for (index,ch) in numArr.enumerated() {
        if ch < maxRight {
            mostLeftIndex = index
            break
        }
    }


    if turnIndex != -1 {
        numArr.swapAt(mostLeftIndex, maxRightIndex)
        return numArr.reduce(0){$0 * 10 + $1}
    }
    
    return num
}

// print(maximumSwap(9934))

func reverseWords(_ words: String) -> String {
    return (words.reversed().split(separator: " ").reduce("") {$0 + String($1).reversed() + " "}).trimmingCharacters(in: CharacterSet(charactersIn: " "))
}

// print(reverseWords("the sky is blue"))

//a3[b2[cde]f2[gh]5[]]ik4[l]mno
func decompress(_ compressedString: String) -> String {
    if compressedString.count == 0 {
        return ""
    }
    var bracketPairs: [(Int, Int)] = []
    var leftBracketIndex = -1
    var bracketCount = 0
    for (i, c) in compressedString.enumerated() {
        if ("0"..."9").contains(c), i+1 < compressedString.count, compressedString[i+1] == Character("[") {
            if(bracketCount == 0) {
                leftBracketIndex = i + 1
            }
            bracketCount += 1
        }
        if c == Character("]") {
            bracketCount -= 1
            if bracketCount == 0 {
                bracketPairs.append((leftBracketIndex, i))
                leftBracketIndex = -1
            }
        }
    }

    print("pairs: \(bracketPairs)")

    var result = ""
    var lastIndex = 0
    for pair in bracketPairs {
        result += compressedString[lastIndex..<pair.0-1]
        result += String(repeating: decompress(compressedString[pair.0+1..<pair.1]), count: Int(String(compressedString[pair.0-1])) ?? 0)
        lastIndex = pair.1+1
    }
    result += compressedString[lastIndex..<compressedString.count]
    return result
}

// print("decompress \"a3[b2[cde]f2[gh]5[]]ik4[l]mno\":\n\(decompress("a3[b2[cde]f2[gh]5[]]ik4[l]mno"))")