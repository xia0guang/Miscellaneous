//: Playground - noun: a place where people can play

import UIKit
import CoreLocation
import PlaygroundSupport

class StreamReader  {
    
    let encoding : String.Encoding
    let chunkSize : Int
    var fileHandle : FileHandle!
    let delimData : Data
    var buffer : Data
    var atEof : Bool
    
    init?(url: URL, delimiter: String = "\n", encoding: String.Encoding = .utf8,
          chunkSize: Int = 4096) {
        guard let delimData = delimiter.data(using: encoding) else {
            return nil
        }
    
        do {
            let fileHandle = try? FileHandle(forReadingFrom: url)
            self.encoding = encoding
            self.chunkSize = chunkSize
            self.fileHandle = fileHandle
            self.delimData = delimData
            self.buffer = Data(capacity: chunkSize)
            self.atEof = false
        } catch {
            print("no FileHandle with error: \(error)")
            return nil
        }
    }
    
    deinit {
        self.close()
    }
    
    /// Return next line, or nil on EOF.
    func nextLine() -> String? {
        precondition(fileHandle != nil, "Attempt to read from closed file")
        
        // Read data chunks from file until a line delimiter is found:
        while !atEof {
            if let range = buffer.range(of: delimData) {
                // Convert complete line (excluding the delimiter) to a string:
                let line = String(data: buffer.subdata(in: 0..<range.lowerBound), encoding: encoding)
                // Remove line (and the delimiter) from the buffer:
                buffer.removeSubrange(0..<range.upperBound)
                return line
            }
            let tmpData = fileHandle.readData(ofLength: chunkSize)
            if tmpData.count > 0 {
                buffer.append(tmpData)
            } else {
                // EOF or read error.
                atEof = true
                if buffer.count > 0 {
                    // Buffer contains last line in file (not terminated by delimiter).
                    let line = String(data: buffer as Data, encoding: encoding)
                    buffer.count = 0
                    return line
                }
            }
        }
        return nil
    }
    
    /// Start reading from the beginning of file.
    func rewind() -> Void {
        fileHandle.seek(toFileOffset: 0)
        buffer.count = 0
        atEof = false
    }
    
    /// Close the underlying file. No reading must be done after calling this method.
    func close() -> Void {
        fileHandle?.closeFile()
        fileHandle = nil
    }
}

extension StreamReader : Sequence {
    func makeIterator() -> AnyIterator<String> {
        return AnyIterator {
            return self.nextLine()
        }
    }
}

let outputFileName = "Cross_Country_Location_Data_9-22_10_01_3000m"
var fileIncrement: Int = 1

func writeToFile(string: String, createNewFile: Bool) {
    if createNewFile {
        fileIncrement += 1
    }
    do {
        let writeUrl = playgroundSharedDataDirectory.appendingPathComponent("\(outputFileName)_\(fileIncrement).csv")
        let writeFile = try FileHandle(forWritingTo: writeUrl)
        if let d = string.data(using: .utf8) {
            writeFile.seekToEndOfFile()
            writeFile.write(d)
            writeFile.closeFile()
        }
    } catch {
        print("Access denied: \(error)")
    }
}

let url = playgroundSharedDataDirectory.appendingPathComponent("PSO_LocationLog(2017-10-04-10-18-08).csv")
if let streamReader = StreamReader(url: url) {
    let firstLine = streamReader.nextLine() ?? ""
    let columnName = (firstLine).components(separatedBy: ",")
    print(columnName)
    writeToFile(string: firstLine + "\n", createNewFile: false)
    
    var nextLine = streamReader.nextLine()
    var previousLocation: CLLocation? = nil
    var numberOfLines = 0
    while(nextLine != nil) {
        defer {
            nextLine = streamReader.nextLine()
        }
        let cells = nextLine!.components(separatedBy: ",")
        if cells.count == 7 {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZZZ"
            guard let date = dateFormatter.date(from: cells[1]),
                let latitude = Double(cells[2]),
                let longitude = Double(cells[3]),
                let accuracy = Double(cells[4]) else {
                    print("parsing error, line: \(nextLine!)")
                    continue
            }
            
            if accuracy > 15.0 {
                continue
            }
            
            let currentLocation = CLLocation(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), altitude: 0.0, horizontalAccuracy: accuracy, verticalAccuracy: 5.0, timestamp: date)
            if previousLocation == nil || currentLocation.distance(from: previousLocation!) >= 3000.0 {
                //Store a new location
                previousLocation = currentLocation
                if numberOfLines == 1999 {
                    writeToFile(string: firstLine + "\n", createNewFile: true)
                    numberOfLines = 0
                }
                writeToFile(string: "\(nextLine!)\n", createNewFile: false)
                numberOfLines += 1
            }
        }
        
    }
    streamReader.close()
}

