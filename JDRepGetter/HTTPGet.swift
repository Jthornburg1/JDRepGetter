//
//  HTTPGet.swift
//  JDRepGetter
//
//  Created by jonathan thornburg on 1/5/18.
//  Copyright © 2018 jon-thornburg. All rights reserved.
//

import Foundation
import Alamofire

class HTTPGet {
    
    var urlString: String?
    
    init(urlString: String) {
        self.urlString = urlString
    }
    
    func apiGet(handler:(Data) -> Void) {
        
    }
}
