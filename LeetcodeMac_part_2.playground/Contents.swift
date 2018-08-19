//: Playground - noun: a place where people can play
import Foundation
/*:
 ### Valid Number
 Validate if a given string is numeric.
 
 Some examples:
 ````
 "0" => true
 "000000" => true
 " 0.1 " => true
 "abc" => false
 "1 a" => false
 "2e10" => true
 "0e10" => true
 "00012" => true
 "0 0012" => false
 ````
 - Note:
 It is intended for the problem statement to be ambiguous. You should gather all requirements up front before implementing one.
 */

func toRad(_ x: Double) -> Double {
    return x * Double.pi / 180.0
}

func y(_ lat: Double, _ lon: Double, _ z: Double) -> Int {
    let latRad = toRad(lat)
    let a = latRad*Double.pi/180.0
    let b = 1.0/cos(a)
    let c = tan(a)
    let d = log2(b + c)
    let e = d/Double.pi
    print("a:\(a), b:\(b), c:\(c), d:\(d), e:\(e)")
    return Int((1-e) * pow(2.0,z-1))
}

func x(_ lat: Double, _ lon: Double, _ z: Double) -> Int {
    let lonRad = toRad(lon)
    return Int((lonRad+180.0)/360.0*pow(2.0,z))
}

func xy(_ lat: Double, _ lon: Double, _ z: Double) -> (x: Int, y: Int) {
    print("lat: \(lat), lon: \(lon), z: \(z)")
    return (x(lat,lon,z), y(lat,lon,z))
}

func tranformCoordinate(_ latitudeDegree: Double, _ longitudeDegree: Double, withZoom zoom: Int) -> (x: Int, y: Int) {
    let longitude = toRad(longitudeDegree)
    let latitude = toRad(latitudeDegree)
    let tileX = Int(floor((longitude + 180) / 360.0 * pow(2.0, Double(zoom))))
    let tileY = Int(floor((1 - log( tan( latitude * Double.pi / 180.0 ) + 1 / cos( latitude * Double.pi / 180.0 )) / Double.pi ) / 2 * pow(2.0, Double(zoom))))
    
    return (tileX, tileY)
}

func tileToLatLon(tileX : Int, tileY : Int, mapZoom: Int) -> (lat_deg : Double, lon_deg : Double) {
    let n : Double = pow(2.0, Double(mapZoom))
    let lon = (Double(tileX) / n) * 360.0 - 180.0
    let lat = atan( sinh (.pi - (Double(tileY) / n) * 2 * Double.pi)) * (180.0 / .pi)
    
    return (lat, lon)
}

print(tranformCoordinate(-85.051128779806604, -360, withZoom: 3))
print(tileToLatLon(tileX: 0, tileY: 0, mapZoom: 2))
