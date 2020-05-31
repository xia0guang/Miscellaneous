import Foundation

// Utilitiy functions
func format(date: Date, dateFormat: String) -> String {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = dateFormat
    formatter.timeZone = TimeZone.current
    return formatter.string(from: date)
}

func format(date: Date) -> String {
    return format(date: date, dateFormat: "yyyy-MM-dd HH:mm:ss.SSSZZZZZ")
}

func randomString(length: Int) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyz"
    return String((0..<length).map{ _ in letters.randomElement()! })
}

// Purpose for defining thread safe property
@propertyWrapper
struct Atomic<Value> {

    private var value: Value
    private let lock = NSLock()

    init(wrappedValue value: Value) {
        self.value = value
    }

    var wrappedValue: Value {
      get { return load() }
      set { store(newValue: newValue) }
    }

    func load() -> Value {
        lock.lock()
        defer { lock.unlock() }
        return value
    }

    mutating func store(newValue: Value) {
        lock.lock()
        defer { lock.unlock() }
        value = newValue
    }
}


// Models
enum Temp: String {
    case hot
    case cold
    case frozen
    case anyTemp = "overflow"

    func decayModifier() -> Int {
        return (self == .anyTemp ? 2 : 1)
    }
}

enum RunningError: String, Error {
    case inValidJson
    case noOrderInJson
}

class Shelf: CustomStringConvertible {
    let temp: Temp
    let capacity: Int
    var decayModifier: Int {
        return temp.decayModifier()
    }
    var count: Int {
        return orders.count
    }
    var orders: [Order] = []

    init(temp: Temp, capacity: Int) {
        self.temp = temp
        self.capacity = capacity
    }

    func addOrder(_ order: Order) {
        order.onMovedTo(self)
        orders.append(order)
    }

    func removeOrder(at index: Int) {
        orders.remove(at: index)
    }

    func remove(order: Order) {
        if let index = orders.firstIndex(of: order) {
            self.removeOrder(at: index)
        }
    }

    func has(order: Order) -> Bool {
        return orders.firstIndex(of: order) != nil
    }

    subscript(x : Int) -> Order {
        return orders[x]
    }
    

    var description: String {
        return "\(temp.rawValue) shelf"
    }
}

class Courier: Equatable {
    @Atomic static var courierIdIncrement = 0
    let id: String
    let name: String
    var assignedOrder: Order?
    var isDelivering: Bool = false
    var willAvailableToPickUp: Date?

    init(name: String) {
        self.id = String(Courier.courierIdIncrement)
        Courier.courierIdIncrement += 1
        self.name = name
    }

    func delivered() {
        assignedOrder = nil
        isDelivering = false
        willAvailableToPickUp = Date(timeIntervalSinceNow: Double.random(in: 2.0...6.0))
    }

    static func == (lhs: Courier, rhs: Courier) -> Bool {
        return lhs.id == rhs.id
    }
}

class Order: Equatable {
    let id: String
    let name: String
    let temp: Temp
    let decayRate: Double
    let shelfLife: Int
    var placedShelf: Shelf?
    var placedOnShelfTimestamp: Date = Date()
    var accumulatedDecayedLife: Double = 0.0
    var decayedLife: Double {
        decayRate * Date().timeIntervalSince(placedOnShelfTimestamp) * Double(placedShelf?.decayModifier ?? 0) / Double(shelfLife) + accumulatedDecayedLife
    }
    var orderLifeLeft: Double {
        return 1.0 - decayedLife
    }

    init(id: String, name: String, temp: Temp, decayRate: Double, shelfLife: Int) {
        self.id = id
        self.name = name
        self.temp = temp
        self.decayRate = decayRate
        self.shelfLife = shelfLife
    }

    func onMovedTo(_ shelf: Shelf) {
        // When moved from overflow shelf to temp matched shelf, calculate the decayedLife
        accumulatedDecayedLife = decayedLife
        placedOnShelfTimestamp = Date()
        placedShelf = shelf
    }

    static func == (lhs: Order, rhs: Order) -> Bool {
        return lhs.id == rhs.id
    }
    
}


//Protocols 
protocol Simulating {
    var orderRate: Int { get }
    var shelvesDict: [Temp: Shelf] { get }
    var courierQueue: [Courier] { get }
    func readOrderFromFile(_ path: String)
    func run()
    func stop(message: String?, error: RunningError?)
}

protocol Ordering {
    func receiveOrder(_ order: Order)
    func discardOrder(_ orderIndex: Int, from shelf: Shelf)
    func ordersLifeCheck()
}

protocol Delivering {
    func distributeCourier(forOrder order: Order) -> Courier?
    func courierArrive(_ courier: Courier)
}

protocol Logging {
    var cachedLogs: [String] { get }
    var logsCountMaximum: Int { get }
    var filePathForSavingLogs: String { get }
    var cachedLogsToSave: [String] { get }
    var logsCountMaximumBeforeDump: Int { get }
    func debugInfo(log: String)
    func saveLog(_ log: String)
}


//Class for System
final class CloudKitchenSystem: Simulating, Ordering, Delivering, Logging {
    let orderRate: Int
    @Atomic var shelvesDict: [Temp: Shelf] = [
        .hot: Shelf(temp: .hot, capacity: 10),
        .cold: Shelf(temp: .cold, capacity: 10),
        .frozen: Shelf(temp: .frozen, capacity: 10),
        .anyTemp: Shelf(temp: .anyTemp, capacity: 15)
    ]
    @Atomic var courierQueue: [Courier] = []
    var inComingOrders: [Order] = []

    private var newOrderTimer: Timer?

    init(orderRate: Int = 2, logsCountMaximum: Int = 25, logsCountMaximumBeforeDump: Int = 100) {
        self.orderRate = orderRate
        self.logsCountMaximum = logsCountMaximum
        self.filePathForSavingLogs = format(date: Date(), dateFormat: "yyyy-MM-dd-HH-mm-s") + ".txt"
        self.logsCountMaximumBeforeDump = logsCountMaximumBeforeDump
    }

    // procotol Simulating
    func readOrderFromFile(_ path: String) {
        guard FileManager.default.fileExists(atPath: FileManager.default.currentDirectoryPath + "/" + path) else {
            debugInfo(log: "No file found in path: \(FileManager.default.currentDirectoryPath + "/" + path)")
            return
        }
        
        guard let jsonData = FileManager.default.contents(atPath: path),
            let jsonResult = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableLeaves), 
            let orderJsonArray = jsonResult as? [Any],
            orderJsonArray.count > 0 else {
            stop(error: .inValidJson)
            return
        }

        orderJsonArray.forEach { orderJson in 
            guard let order = orderJson as? [String: Any],
                let id = order["id"] as? String,
                let name = order["name"] as? String,
                let tempStr = order["temp"] as? String,
                let temp = Temp(rawValue: tempStr),
                let shelfLife = order["shelfLife"] as? Int,
                let decayRate = order["decayRate"] as? Double else {
                    return
                }

            let newOrder = Order(id: id, name: name, temp: temp, decayRate: decayRate, shelfLife: shelfLife)
            inComingOrders.append(newOrder)
        }
        if inComingOrders.count == 0 {
            stop(error: .noOrderInJson)
        }
    }

    func run() {
        newOrderTimer = Timer.scheduledTimer(withTimeInterval: 1.0/Double(orderRate), repeats: true) { [weak self] timer in 
            // Every 0.5 second(when order rate is 2), there will be a new order created and receiveOrder method will be called.
            guard let self = self else { return }

            // Check if there ever be any order need to handle and move around. 
            self.ordersLifeCheck()

            // Handle receiving order logic
            if self.inComingOrders.count > 0 {
                self.receiveOrder(self.inComingOrders.removeFirst())
            } else {
                self.newOrderTimer?.invalidate()
            }
        }
        debugInfo(log: "Cloud Kitchen System started...")
        newOrderTimer?.fire()
        RunLoop.current.add(newOrderTimer!, forMode: RunLoop.Mode.default)
        RunLoop.current.run()
    }

    func stop(message: String? = nil, error: RunningError? = nil ) {
        if error != nil {
            debugInfo(log: "System is stopped due to an error: \(error?.rawValue ?? "unknown")")
            return
        }
        debugInfo(log: "System is successfully stopped with message: \(message ?? "n/a")")
        logsDumpQueue.async { [weak self] () -> () in 
            self?.saveLog(self?.cachedLogsToSave.reduce(into: "") {$0.append("\n" + $1)} ?? "")
        }
        newOrderTimer?.invalidate()
        exit(0)
    } 

    // protocol Ordering
    func receiveOrder(_ order: Order) {
        // Store order on temp matched shelf if available
        if let matchShelf = shelvesDict[order.temp],
            matchShelf.count < matchShelf.capacity {
            matchShelf.addOrder(order)
            debugInfo(log: "Order: \(order.name) has been put on \(matchShelf) ")
        // Store order on overflow shelf if available
        } else if let overflowShelf = shelvesDict[Temp.anyTemp] {
            // Moved a certain order in overflow to its corresponding shelf if overflow shelf is full
            if overflowShelf.count == overflowShelf.capacity {
                var i = 0
                while i < overflowShelf.count {
                    let cur = overflowShelf[i]
                    if let matchShelf = shelvesDict[cur.temp], matchShelf.count < matchShelf.capacity {
                        matchShelf.addOrder(cur)
                        debugInfo(log: "Order: \(cur.name) has been moved from overflow shelf to \(matchShelf)")
                        break
                    }
                    i += 1
                }
                if i < overflowShelf.count {
                    overflowShelf.removeOrder(at: i)
                }
            }

            // Discard a random order from overflow shelf if overflow shelf is still full after last step
            if overflowShelf.count == overflowShelf.capacity {
                let toDiscardIndex = Int.random(in: 0...overflowShelf.count-1)
                discardOrder(toDiscardIndex, from: overflowShelf)
            }

            overflowShelf.addOrder(order)
            debugInfo(log: "Order: \(order.name) has been put on overflow shelf")
        }

        _ = distributeCourier(forOrder: order)
    }

    func discardOrder(_ orderIndex: Int, from shelf: Shelf) {
        if orderIndex < shelf.count {
            let toDiscardOrder = shelf[orderIndex]
            debugInfo(log: "\(toDiscardOrder.name) from \(shelf) has been discarded")
            shelvesDict[shelf.temp]?.removeOrder(at: orderIndex)
        } else {
            debugInfo(log: "Error occurs when discard order on \(shelf)")
        }
    }

    func ordersLifeCheck() {
        // discard decayed order
        var toDiscardDict: [Temp: [Int]] = [:]
        for (temp, shelf) in shelvesDict {
            for i in 0..<shelf.count {
                if shelf[i].orderLifeLeft <= 0 {
                    toDiscardDict[temp, default:[]].append(i)
                }
            }
        }

        for (temp, toDiscardIndices) in toDiscardDict {
            for index in toDiscardIndices {
                if let shelf = shelvesDict[temp] {
                    let toDiscardOrder = shelf[index]
                    debugInfo(log: "Order: \(toDiscardOrder.name) is totally decayed and should be discard immediately")
                    discardOrder(index, from: shelf)
                }
            }
        }
    }

    // protocol Delivering
    func distributeCourier(forOrder order: Order) -> Courier? {
        //TODO: recycle existing courier
        let firstName = randomString(length: 5)
        let lastName = randomString(length: 5)
        let courier = Courier(name: "\(firstName) \(lastName)")
        courier.assignedOrder = order
        let courierTime = Double.random(in: 2.0...6.0)
        courier.willAvailableToPickUp = Date(timeIntervalSinceNow: courierTime)
        courierQueue.append(courier)
        let newCourierTimer = Timer.scheduledTimer(withTimeInterval: courierTime, repeats: false) { [weak self] timer in 
            self?.courierArrive(courier)
        }
        RunLoop.current.add(newCourierTimer, forMode: RunLoop.Mode.default)
        debugInfo(log: "Courier: \(courier.name) is coming to pick up order: \(order.name) in \(String(format: "%.2f", courierTime)) seconds at \(format(date: courier.willAvailableToPickUp!))")
        return courier
    }

    func courierArrive(_ courier: Courier) {
        courier.isDelivering = true
        if let order = courier.assignedOrder, 
            let shelf = shelvesDict[order.temp],
            let overflowShelf = shelvesDict[Temp.anyTemp] {

            if let courierIndex = self.courierQueue.firstIndex(of: courier) {
                self.courierQueue.remove(at: courierIndex)
            }
            let  orderIsOnMatchShelf = shelf.has(order: order)
            if orderIsOnMatchShelf {
                shelf.remove(order: order)
                debugInfo(log: "Courier: \(courier.name) is delivering order: \(order.name) which is removed from \(shelf)")
            } else {
                overflowShelf.remove(order: order)
                debugInfo(log: "Courier: \(courier.name) is delivering order: \(order.name) which is removed from \(overflowShelf)")
            }
        }
        
        //Check if courier queue is empty, stop the system if it is empty
        if courierQueue.count == 0 {
            stop(message: "All orders are delivered. The inventory is empty")
        }

    }

    // protocol Logging
    private let logsDumpQueue = DispatchQueue(label: "LogsDump")
    var cachedLogs: [String] = []
    var logsCountMaximum: Int

    func debugInfo(log: String) {
        logsDumpQueue.async { [weak self] () -> () in 
            self?.cachedLogsToSave.append(log)
            if (self?.cachedLogsToSave.count ?? 0) > (self?.logsCountMaximumBeforeDump ?? 0) {
                self?.saveLog(self?.cachedLogsToSave.reduce(into: "") {$0.append("\n" + $1)} ?? "")
            }
        }

        if self.cachedLogs.count == self.logsCountMaximum {
            self.cachedLogs.removeFirst()
        }
        self.cachedLogs.append(log)

        print("\u{001B}[2J")
        var count: Int = self.shelvesDict[.hot]?.count ?? 0
        self.shelvesDict[.hot]?.orders.forEach{print($0.name + ", ", terminator: "")}
        print("\n|===================================Hot Shelf============================================total:\(count)=============|\n")
        count = self.shelvesDict[.cold]?.count ?? 0
        self.shelvesDict[.cold]?.orders.forEach{print($0.name + ", ", terminator: "")}
        print("\n|===================================Cold Shelf===========================================total:\(count)=============|\n")
        count = self.shelvesDict[.frozen]?.count ?? 0
        self.shelvesDict[.frozen]?.orders.forEach{print($0.name + ", ", terminator: "")}
        print("\n|===================================Frozen Shelf=========================================total:\(count)=============|\n")
        count = self.shelvesDict[.anyTemp]?.count ?? 0
        self.shelvesDict[.anyTemp]?.orders.forEach{print($0.name + ", ", terminator: "")}
        print("\n|===================================Overflow Shelf=======================================total:\(count)=============|\n")
        self.cachedLogs.forEach{print("\(format(date: Date())): \($0)")}
    
    }

    var cachedLogsToSave: [String] = []
    var filePathForSavingLogs: String
    var logsCountMaximumBeforeDump: Int

    func saveLog(_ logs: String) {
        let absoluteLogFilePath = FileManager.default.currentDirectoryPath + "/" + filePathForSavingLogs
        print(absoluteLogFilePath)
        if !FileManager.default.fileExists(atPath: absoluteLogFilePath) {
            if !FileManager.default.createFile(atPath:absoluteLogFilePath, contents: logs.data(using: .utf8)) {
                assertionFailure("Failed to create file: \(absoluteLogFilePath)")
            }
        } else {
            if let fileHandle = FileHandle(forWritingAtPath: absoluteLogFilePath), 
                let logData = logs.data(using: .utf8) {
                defer {
                    fileHandle.closeFile()
                    cachedLogsToSave.removeAll()
                }
                fileHandle.seekToEndOfFile()
                fileHandle.write(logData)
            } else {
                assertionFailure("Failed to open file: \(absoluteLogFilePath)")
            }
        }
    }
}

let system = CloudKitchenSystem(orderRate: 5)
system.readOrderFromFile("orders.json")
system.run()