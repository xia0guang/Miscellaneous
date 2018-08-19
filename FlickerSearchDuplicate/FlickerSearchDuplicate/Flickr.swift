/**
 * Copyright (c) 2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
	
import UIKit

let apiKey = "675894853ae8ec6c242fa4c077bcf4a0"

enum Environment {
    case prod
    case test
}

class Flickr {
    var environment: Environment
    let processingQueue = OperationQueue()
    init(_ environment: Environment) {
        self.environment = environment
    }
    
    func searchFlickrForTerm(_ searchTerm: String, completion: @escaping (FlickrSearchResults) -> Void) {
        switch self.environment {
        case .prod:
            guard let searchURL = self.flickrSearchURLForSearchTerm(searchTerm) else {
                return
            }
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: processingQueue)
            let task = session.dataTask(with: searchURL) {data, response, error in
                guard let data = data,
                    let response = response as? HTTPURLResponse else {
                    print(error?.localizedDescription ?? "unknow error")
                        return
                }
                
                print("status: \(response.statusCode)")
                if (200..<300).contains(response.statusCode) {
                    self.parseRawResult(data, completion: completion)
                }
            }
            task.resume()
        case .test:
            self.parseRawResult(kTestResultString, completion: completion)
        }
    }
    
    
    func parseRawResult(_ resultString: String, completion: @escaping (FlickrSearchResults) -> Void) {
        guard let data = resultString.data(using: .utf8) else {
            return
        }
        
        self.parseRawResult(data, completion: completion)
    }
    
    func parseRawResult(_ resultData: Data, completion: @escaping (FlickrSearchResults) -> Void) {
        do {
            guard let resultDict = try JSONSerialization.jsonObject(with: resultData, options: .allowFragments) as? [String: AnyObject],
                let photos = resultDict["photos"] as? [String: AnyObject],
                let photoArray = photos["photo"] as? [[String: AnyObject]] else {
                    print("data json serialization error")
                    return
            }
            
            var flickrPhotos = [FlickrPhoto]()
            for photoObject in photoArray {
                guard let photoID = photoObject["id"] as? String,
                    let farm = photoObject["farm"] as? Int ,
                    let server = photoObject["server"] as? String ,
                    let secret = photoObject["secret"] as? String else {
                        break
                }
                let flickrPhoto = FlickrPhoto(photoID: photoID, farm: farm, server: server, secret: secret)
                flickrPhotos.append(flickrPhoto)
            }
            
            let flickrSearchResult = FlickrSearchResults(searchTerm: "", searchResults: flickrPhotos)
            OperationQueue.main.addOperation {
                completion(flickrSearchResult)
            }
            
        } catch {
            print("data json serialization error")
        }
    }
  
  fileprivate func flickrSearchURLForSearchTerm(_ searchTerm:String) -> URL? {

    guard let escapedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
      return nil
    }

    let URLString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&text=\(escapedTerm)&per_page=20&format=json&nojsoncallback=1"

    guard let url = URL(string:URLString) else {
      return nil
    }

    return url
  }
}
