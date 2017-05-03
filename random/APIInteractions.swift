//
//  APIInteractions.swift
//  random
//
//  Created by Chris Chadillon on 2017-05-02.
//  Copyright © 2017 Chris Chadillon. All rights reserved.
//

import Foundation


class APIInteractions {
    class func getRandomNumbers(theURL:URL, onCompletion: @escaping ([String:Any]!)->Void) {
        var request = URLRequest(url: theURL)
        request.httpMethod = "GET"
        let searchTask = URLSession.shared.dataTask(with: request) {(data, response, error) in
            if error != nil {
                print("Error fetching products: \(String(describing: error))")
                onCompletion([:])
                return
            }
            do {
                let resultsDictionary = try JSONSerialization.jsonObject(with: data!, options: []) as? [String:Any]
                onCompletion(resultsDictionary!)
            } catch {
                print("Error parsing JSON: \(error)")
                onCompletion([:])
                return
            }
        }
        searchTask.resume()
    }
}
