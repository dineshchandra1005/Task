//
//  UtilityCode.swift
//  Task
//
//  Created by Dinesh on 11/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit
import Foundation
import AVFoundation


public class UtilityCode {
    

    class func convertDateFormater(_ date: String) -> String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
        let getDate = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMM d, yyyy || h:mm a"
        return  dateFormatter.string(from: getDate!)
        
    }
    
}

extension String {
    var youtubeID: String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        
        let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive)
        let range = NSRange(location: 0, length: count)
        
        guard let result = regex?.firstMatch(in: self, range: range) else {
            return nil
        }
        
        return (self as NSString).substring(with: result.range)
    }
}
