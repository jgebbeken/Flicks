//
//  NetworkRequest.swift
//  Flicks
//
//  Created by Josh Gebbeken on 1/7/16.
//  Copyright © 2016 Josh Gebbeken. All rights reserved.
//
//import Cocoa

class NetworkRequest: NSObject {
    
    
   // Network Request Snippet
    
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let url = NSURL(string:"https://api.themoviedb.org/3/movie/now_playing?api_key=\(apiKey)")
    let request = NSURLRequest(URL: url!)
    let session = NSURLSession(
        configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
        delegate:nil,
        delegateQueue:NSOperationQueue.mainQueue()
    )
    
    let task : NSURLSessionDataTask = session.dataTaskWithRequest(request,
        completionHandler: { (dataOrNil, response, error) in
            if let data = dataOrNil {
                if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
                    data, options:[]) as? NSDictionary {
                        NSLog("response: \(responseDictionary)")
                        
                }
            }
    });
    task.resume()

}
