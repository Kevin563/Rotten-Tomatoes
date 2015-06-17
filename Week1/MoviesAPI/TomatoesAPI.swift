//
//  TomatoesAPI.swift
//  kevin563-Week1
//
//  Created by Kevin Chang on 2015/6/13.
//  Copyright (c) 2015年 Kevin Chang. All rights reserved.
//

import Foundation

class TomatoesAPI {
    
    var rottenTomatoesURLString: String
    
    init (url: String) {
        self.rottenTomatoesURLString = url
    }
    
    func loadTomatoes (completion: (([AnyObject]) -> Void)!) {
        let session = NSURLSession.sharedSession()
        let tomatoesUrl = NSURL(string: rottenTomatoesURLString)
        
        var task = session.dataTaskWithURL(tomatoesUrl!) {(data, response, error) -> Void in
            if error != nil {
                println(error!.localizedDescription)
            } else {
                var err: NSError?
                if let jsonResult = NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers, error: &err) as? NSDictionary {
                    if err != nil {
                        println("JSON error \(err!.localizedDescription)")
                    }
                    else {
                        var tomatoesData = jsonResult["movies"] as! NSArray
                        var tomatoes = [TomatoesEntity]()
                        for tomatoe in tomatoesData {
                            let tomatoe = TomatoesEntity(data: tomatoe as! NSDictionary)
                            tomatoes.append(tomatoe)
                        }
                
                        let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                        dispatch_async(dispatch_get_global_queue(priority, 0)) {
                            dispatch_async(dispatch_get_main_queue()) {
                                 completion(tomatoes)
                            }
                        }
                    }
                }
            }
        }
        
        task.resume()
    }
}