//
//  ProductDataViewModel.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 09/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit

class ProductDataViewModel {

    var image:UIImage?
    
    func getImageFor(product:Product,completionHandler:@escaping (Result<Bool,Error>)->Void) {
        let service = ProductService()
        service.getImageFromServer(product: product) { (result) in
            switch result {
                case .success(let image):
                    self.image = image
                    completionHandler(.success(true))
                case .failure(let error):
                    completionHandler(.failure(error))
            }
        }
    }
}
