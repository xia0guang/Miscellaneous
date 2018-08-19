//: Playground - noun: a place where people can play

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
}

func minByKey(_ key: String, _ db: [[String: Int]]) -> [String: Int] {
    let dbCopy = db.sorted{($0[key] ?? 0) < ($1[key] ?? 0)}
    if db.count >= 1 {
        return dbCopy[0]
    } else {
        return [:]
    }
}

/*
 assert min_by_key("a", [{"a": 1, "b": 2}, {"a": 2}]) == {"a": 1, "b": 2}
 assert min_by_key("a", [{"a": 2}, {"a": 1, "b": 2}]) == {"a": 1, "b": 2}
 assert min_by_key("b", [{"a": 1, "b": 2}, {"a": 2}]) == {"a": 2}
 assert min_by_key("a", [{}]) == {}
 assert min_by_key("b", [{"a": -1}, {"b": -1}]) == {"b": -1}
 */
/*
print(minByKey("a", [["a": 1, "b": 2], ["a": 2]]))
print(minByKey("a", [["a": 2], ["a": 1, "b": 2]]))
print(minByKey("b", [["a": 1, "b": 2], ["a": 2]]))
print(minByKey("a", []))
print(minByKey("b", [["a": -1], ["b": -1]]))
 */

class ServerAllocation {
    var serverDict: [String: [Int]] = [:]
    func allocate(_ serverType: String) -> String {
        // if self.serverDict[serverType] == nil {
        //     self.serverDict[serverType] = [Int]()
        // }
        
        let nextSequence = missingPositive(self.serverDict[serverType, default: [Int]()])
        
        self.serverDict[serverType, default: [Int]()].append(nextSequence)
        
        return "\(serverType)\(nextSequence)"
    }
    
    func deallocate(_ serverName: String) {
        var seperator = 0
        for (i,ch) in serverName.enumerated() {
            if (Character("0")...Character("9")).contains(ch) {
                seperator = i
            }
        }
        let serverType = serverName[0..<seperator]
        guard let serverSequence = Int(serverName[seperator..<serverName.count]) else {
            print("server name is invalid")
            return
        }
        if self.serverDict[serverType] != nil {
            if let index = self.serverDict[serverType]!.index(of: serverSequence) {
                self.serverDict[serverType]!.remove(at: index)
            } else  {
                print("can't find the server:\(serverName)")
            }
            
        } else {
            print("can't find server name:\(serverName)")
        }
        
    }
    
    fileprivate func missingPositive(_ nums: [Int]) -> Int {
        var array = nums
        if array.count == 0 {
            return 1
        }
        
        var i = 0
        while i < array.count {
            let num = array[i]
            if num > 0, num <= array.count, num != array[num-1] {
                array.swapAt(i, num-1)
            } else {
                i += 1
            }
        }
        for (index, num) in array.enumerated() {
            if(index != num - 1) {
                return index + 1
            }
        }
        return array.count + 1
    }
}
/*
let server = ServerAllocation()
server.deallocate("a1")
print("allocate: " + server.allocate("a"))
print("server: " + server.serverDict.description)
print("allocate: " + server.allocate("a"))
print("server: " + server.serverDict.description)
print("deallocate: a1")
server.deallocate("a1")
server.deallocate("a4")
print("server: " + server.serverDict.description)
print("allocate: " + server.allocate("c"))
print("server: " + server.serverDict.description)
print("allocate: " + server.allocate("c"))
print("allocate: " + server.allocate("c"))
print("allocate: " + server.allocate("c"))
print("allocate: " + server.allocate("c"))
print("allocate: " + server.allocate("c"))
print("server: " + server.serverDict.description)
print("allocate: " + server.allocate("a"))
print("server: " + server.serverDict.description)
print("deallocate: c3")
server.deallocate("c3")
print("server: " + server.serverDict.description)
print("deallocate: c1")
server.deallocate("c1")
print("server: " + server.serverDict.description)
print("allocate: " + server.allocate("c"))
print("allocate: " + server.allocate("c"))
print("server: " + server.serverDict.description)
*/

func maximumSwap(_ num: Int) -> Int {
    let numStr = num.description
    var i = 0
    repeat {
         i += 1
    } while i<numStr.count
    return 0
}




