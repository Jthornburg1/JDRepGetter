//
//  RepGetter.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 11/25/17.
//  Copyright © 2017 jon-thornburg. All rights reserved.
//

import Foundation

struct RepGetter {
    public static let shared = RepGetter()
    
    fileprivate init(){ print("RepGetter initialized") }
    
    func getRepsBy(zip: String, completion: ([String:AnyObject]) -> Void) {
        if let query = zip.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) {
            let urlString = String(format: "http://whoismyrepresentative.com/getall_mems.php?zip=%@&output=JSON", query)
            if let url = URL(string: urlString) {
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                let session = URLSession.shared
                let task = session.dataTask(with: request, completionHandler: { (boogerFace, toiletMan, buttFace) in
                    if let response = toiletMan as? HTTPURLResponse {
                        if response.statusCode == 200 {
                            if let data = boogerFace {
                                print(data)
                                if let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue:0)) {
                                    if let dict = json as? [[String:AnyObject]] {
                                        print(dict)
                                    }
                                }
                            }
                        } else {
                            print("response code is: \(response.statusCode)")
                        }
                    }
                })
                task.resume()
            }
        }
        
    }
    
    func getJSONFrom(urlString: String, handler:@escaping ([[String:AnyObject]]) -> Void) {
        let session = URLSession.shared
        let url = URL(string:urlString)
        var request = URLRequest(url: url!)
        request.httpMethod = "GET"
        let task = session.dataTask(with: request) { (data, response, error) in
            if (response as? HTTPURLResponse) != nil {
                if let dta = data {
                    if let json = try? JSONSerialization.jsonObject(with: dta, options: JSONSerialization.ReadingOptions(rawValue:0)) as? [String:AnyObject] {
                        if let jsn = json {
                            let jsonArray = [jsn]
                            DispatchQueue.main.async(execute: {
                                handler(jsonArray)
                            })
                        }
                    } else {
                        if let json = try? JSONSerialization.jsonObject(with: dta, options: JSONSerialization.ReadingOptions(rawValue:0)) as? [[String:AnyObject]] {
                            if let jsn = json {
                                DispatchQueue.main.async(execute: {
                                    handler(jsn)
                                })
                            }
                        }
                    }
                }
            }
        }
        task.resume()
    }
}
