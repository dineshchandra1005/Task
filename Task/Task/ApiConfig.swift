//
//  ApiConfig.swift
//  Task
//
//  Created by Dinesh on 11/09/19.
//  Copyright © 2019 task. All rights reserved.
//

import UIKit


struct ApiConfig {
    
    static var BASE_URL = "https://hn.algolia.com/api/v1/"
    
}
    
struct ApiInterface {

    static var getPostsData = ApiConfig.BASE_URL + "search_by_date?tags=story&page="


}


