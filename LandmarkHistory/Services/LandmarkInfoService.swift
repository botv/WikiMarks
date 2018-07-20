//
//  MediaWikiService.swift
//  LandmarkHistory
//
//  Created by Robert May on 7/16/18.
//  Copyright © 2018 Ben Botvinick. All rights reserved.
//

import SwiftyJSON
import SwiftSoup

class LandmarkInfoService {
    
    static func getWikiLink(for landmark: String) -> String {
        let requestLink = "https://en.wikipedia.org/wiki/" + landmark.replacingOccurrences(of: " ", with: "_")
        return requestLink
    }
    
    static func getInformation(for landmark: String, completion: @escaping ([String: Any]?) -> Void) {
        let requestLink = getWikiLink(for: landmark)
        guard let myURL = URL(string: requestLink) else {
            print("Error: \(requestLink) doesn't seem to be a valid URL")
            completion(nil)
            return
        }
        do {
            var info = [String: Any]()
            let html = try String(contentsOf: myURL, encoding: .ascii)
            let doc: Document = try! SwiftSoup.parse(html)
            let table: Element? = try doc.select("table.infobox").first()
            if let table = table,
                let infobox = try table.select("tbody").first() {
                // Get info
                for tr in infobox.children().array() {
                    var key: String = try tr.select("th").text()
                    var value: String = try tr.select("td").text()
                    
                    key = removeRefs(from: key)
                    value = removeRefs(from: value)
                    
                    key = key.replacingOccurrences(of: "â¢", with: "")
                    value = value.replacingOccurrences(of: "â¢", with: "")
                    
                    key = key.replacingOccurrences(of: "â¢ ", with: "")
                    value = value.replacingOccurrences(of: "â¢ ", with: "")
                    
                    key = key.replacingOccurrences(of: "â", with: "-")
                    value = value.replacingOccurrences(of: "â", with: "-")
                    
                    key = key.replacingOccurrences(of: "â ", with: "- ")
                    value = value.replacingOccurrences(of: "â ", with: "- ")
                    
                    key = key.replacingOccurrences(of: "Ã©", with: "é")
                    value = value.replacingOccurrences(of: "Ã©", with: "é")
                    
                    key = key.replacingOccurrences(of: "Ã© ", with: "é ")
                    value = value.replacingOccurrences(of: "Ã© ", with: "é ")
                    
                    if key != "" && value != "" {
                        if info[key] == nil {
                            info[key] = value
                        } else {
                            info[key] = nil
                        }
                    }
                }
                // Get image
                if let imageA = try infobox.select("a.image").first(),
                   let image = try imageA.select("img").first() {
                    let imgURL = try image.attr("src")
                    info["image"] = "https:" + imgURL
                }
            }
            completion(info)
        } catch let error {
            print(error.localizedDescription)
            completion(nil)
        }
    }
    
    static private func jsonToDict(for json: JSON) -> [String: Any] {
        var result = [String: Any]()
        for (key, object) in json {
            if object.stringValue == "" {
                result[key] = jsonToDict(for: object)
            } else {
                result[key] = object.stringValue
            }
        }
        return result
    }
    
    static private func removeRefs(from str: String) -> String {
        var ind = 0
        var refBeginningInd = str.startIndex
        var searching = false
        var str = str
        while ind < str.count {
            // If [ not previously found and is current character
            let currentInd = str.index(str.startIndex, offsetBy: ind)
            let currentChar = String(str[currentInd])
            if !searching && currentChar == String("[") {
                // Begin checking for numbers
                searching = true
                refBeginningInd = currentInd
            }
            // Otherwise, if [ previously found and ] has been found with a at least 1 number between them and no non-numeric characters
            else if searching && currentChar == String("]") {
                if Int(String(str[str.index(before: currentInd)])) != nil {
                    str.removeSubrange(refBeginningInd...currentInd)
                }
                searching = false
            }
            // Otherwisea, if [ previously found an current character is not a number
            else if searching && Int(currentChar) == nil {
                // It is not a reference
                searching = false
            }
            ind += 1
        }
        return str
    }
    
}
