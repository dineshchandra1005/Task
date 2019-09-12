//
//  ApiService.swift
//  Task
//
//  Created by Dinesh on 11/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit

typealias Parameters = [String: String]

let imageCache : NSCache<NSString, UIImage> = {
    let imageCache = NSCache<NSString, UIImage>()
    imageCache.countLimit = 100
    return imageCache
}()


class ApiService: NSObject {
    
    static func callPost(url:String, params: Any ,methodType: String, tag : String ,  finish: @escaping ((message:String, data:Data?, tag : String)) -> Void)
    {
        
        guard let url = URL(string: url) else { return }
        var request = URLRequest(url: url)
        request.httpMethod = methodType
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if methodType == "POST"  || methodType == "PUT" {

        guard let httpBody = try? JSONSerialization.data(withJSONObject: params, options: []) else { return }
        request.httpBody = httpBody
            
        }
        DispatchQueue.global(qos: .background).async {
        var result:(message:String, data:Data? , tag : String) = (message: "Fail", data: nil , tag: tag)
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (data, response, error) in
            if let response = response {
                print(response)
            }
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                    print(json)
                    
                } catch {
                    print(error)
                }
            }
            
            DispatchQueue.main.async {
                
                if(error != nil)
                {
                    result.message = "Fail Error not null : \(error.debugDescription)"
                }
                else
                {
                    
                    result.message = "Success"
                    result.data = data
                    result.tag = tag
                    
                }
                
                finish(result)
                
            
            }

            }
            task.resume()
            
        }
    }
    
    static func loadImageUsingUrlString(_ urlString: String, image: UIImage) {
    
       var imageUrlString: String?

        var image = image
        
        imageUrlString = urlString
        
        let url = URL(string: urlString)
        
        
        if let imageFromCache = imageCache.object(forKey: urlString as NSString) {
            image = imageFromCache
            
            return
        }
        
        URLSession.shared.dataTask(with: url!, completionHandler: { (data, respones, error) in
            
            if error != nil {
                print(error ?? "test")
                return
            }
            
            DispatchQueue.main.async(execute: {
                
                let imageresize = UIImage(data: data!)
                
                if imageUrlString == urlString && imageresize != nil {
                    
                    
                    image = imageresize!
                    
                    
                }else {
                    
                    image = UIImage(named: "camera")!
                    
                }
                
                if imageresize != nil {
                    
                    imageCache.setObject(imageresize!, forKey: urlString as NSString)
                    
                }
            })
            
        }).resume()
    }
    
}
