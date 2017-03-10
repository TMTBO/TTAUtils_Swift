//
//  BannerModel.swift
//  KuaiYiGou_Swift
//
//  Created by TobyoTenma on 07/03/2017.
//  Copyright © 2017 TobyoTenma. All rights reserved.
//

import ObjectMapper

/// Banner view model
class BannerModel: Mappable  {
    
    var image: String?
    var title: String?
    var urlString: String?
    
    /// This function can be used to validate JSON prior to mapping. Return nil to cancel mapping at this point
    public required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        image <- map["image"]
        title <- map["title"]
        urlString <- map["urlString"]
    }
}
