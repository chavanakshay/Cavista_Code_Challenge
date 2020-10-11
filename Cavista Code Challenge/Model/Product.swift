//
//  Product.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit
import RealmSwift


class Product: Object,Codable {
    @objc dynamic var id:String
    @objc dynamic var date:String?
    @objc dynamic var type:String?
    @objc dynamic var data:String?
}
