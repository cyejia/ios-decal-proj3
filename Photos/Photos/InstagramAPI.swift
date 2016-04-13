//
//  InstagramAPI.Swift
//  Photos
//
//  Created by Gene Yoo on 11/3/15.
//  Copyright © 2015 iOS DeCal. All rights reserved.
//

import Foundation

class InstagramAPI {
    /* Connects with the Instagram API and pulls resources from the server. */
    func loadPhotos(completion: (([Photo]) -> Void)!) {
        /* 
         * 1. Get the endpoint URL to the popular photos 
         *    HINT: Look in Utils
         * 2. Create a Session
         * 3. Create a Data Task with a URL and completionHandler
         *    If no error:
         *       a. Get NSDictionary from the JSON object, from key the "photos"
         *       b. Create Array of NSDictionaries (one NSDictionary for each photo)
         *       c. For each NSDictionary, create a Photo object, and add to Photos array
         *       d. Wait for completion of Photos array
         */
        // FILL ME IN
        var url: NSURL
        
        url = Utils.getPopularURL()

        let task = NSURLSession.sharedSession().dataTaskWithURL(url) {
            (data: NSData?, response: NSURLResponse?, error: NSError?) -> Void in
            if error == nil {
                //FIX ME
                let photos: [Photo]!
                photos = [Photo]()
                do {
                    let feedDictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: NSJSONReadingOptions.MutableContainers) as! NSDictionary
                    // FILL ME IN, REMEMBER TO USE FORCED DOWNCASTING
                    var dictionaryArray = [NSDictionary]()
                    if let data = feedDictionary["data"] as? [[String: AnyObject]] {
                        for datum in data {
                            var likes : Int?
                            var url : String?
                            var username : String?
                            var dateCreated : NSDate?
                            
                            likes = 0
                            url = ""
                            username = ""
                            dateCreated = NSDate()
                            
                            
                            if let likesDictionary = datum["likes"] as? [String: AnyObject] {
                                likes = likesDictionary["count"] as? Int
                            }
                            
                            if let user = datum["user"] as? [String: AnyObject] {
                                username = user["username"] as? String
                            }
                            
                            if let images = datum["images"] as? [String: AnyObject] {
                                if let standardResolution = images["standard_resolution"] as? [String: AnyObject] {
                                    url = standardResolution["url"] as? String
                                }
                            }
                            
                            if let createdTime = datum["created_time"] as? String {
                                dateCreated = NSDate.init(timeIntervalSince1970: Double(createdTime)!)
                            }
                            
                            let photoDictionary : [String: AnyObject]
                            photoDictionary = ["likes": likes!, "url": url!, "username": username!, "dateCreated": dateCreated!]
                            
                            let photoNSDictionary = NSDictionary(dictionary: photoDictionary)
                            dictionaryArray.append(photoNSDictionary)
                        }
                    }
                    
                    for dict in dictionaryArray {
                        photos.append(Photo(data: dict))
                    }
                
                    // DO NOT CHANGE BELOW
                    let priority = DISPATCH_QUEUE_PRIORITY_DEFAULT
                    dispatch_async(dispatch_get_global_queue(priority, 0)) {
                        dispatch_async(dispatch_get_main_queue()) {
                            completion(photos)
                        }
                    }
                } catch let error as NSError {
                    print("ERROR: \(error.localizedDescription)")
                }
            }
        }
        task.resume()
    }
}