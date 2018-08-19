// [5,4,2,1,2,3,2,1,0,1,2,4]

func printLand(_ height:[Int]) {
    let maxHeight = height.reduce(0){$0 < $1 ? $1 : $0}
    for i in stride(from: maxHeight, through: 0, by: -1) {
        for j in 0..<height.count {
            if i > height[j] {
                print(" ", terminator: "")
            } else {
                print("+", terminator: "")
            }
        }
        print("")
    }
}

func printLandAndWater(_ height: [Int], _ heightCopy: [Int]) {
    let maxHeight = heightCopy.reduce(0){$0 < $1 ? $1 : $0}
    for i in stride(from: maxHeight, through: 0, by: -1) {
        for j in 0..<height.count {

            if i > heightCopy[j] {
                print(" ", terminator: "")
            } else if i > height[j] {
                print("W", terminator: "")
            } else {
                print("+", terminator: "")
            }
        }
        print("")
    }
}

// printLand([5,4,2,1,2,3,2,1,0,1,2,4])

func dropRain(_ height: [Int], _ water: Int, _ location: Int) -> [Int] {
    if location >= height.count || water <= 0 {
        return height
    }

    var heightCopy = height

    for i in 0..<water {
        var left = location, right = location
        while left > 0, heightCopy[left - 1] <= heightCopy[left] {left -= 1}
        // while left < location, heightCopy[left + 1] == heightCopy[left] {left += 1}
        while right < heightCopy.count - 1, heightCopy[right + 1] <= heightCopy[right] {right += 1}
        // while right > location, heightCopy[right - 1] == heightCopy[right] {right -= 1}
        // if left < location {
        //     heightCopy[left] += 1
        // } else {
        //     heightCopy[right] += 1
        // }
        if heightCopy[left] < heightCopy[right] {
            heightCopy[left] += 1
        } else {
            heightCopy[right] += 1
        }
    }

    return heightCopy

}

// let height = [5,4,2,1,2,3,2,1,0,1,2,4]
// printLand(height)
// let heightNew = dropRain(height, 2, 4)
// printLandAndWater(height, heightNew)


