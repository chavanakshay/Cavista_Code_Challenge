//
//  Constant.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import Foundation

let BASE_URL = "https://raw.githubusercontent.com/AxxessTech/Mobile-Projects/master"

struct Urls {
    static let products = "\(BASE_URL)/challenge.json"
}

struct Type {
    static let string = "text"
    static let image = "image"
}

enum ProductError:Error{
    case nodataExist(message: String)
    case realmInitFailed(error:Error)
    case saveProductFailed(error:Error)
    case imageSavingFailed(error:Error)
}
