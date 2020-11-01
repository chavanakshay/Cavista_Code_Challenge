//
//  ProductService.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import Foundation
import Alamofire


class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ProductService {
    
    
    func getProductsFromServer(completionHandler:@escaping (Result<[Product],AFError>)->Void)  {
        //create request
        let request = AF.request(Urls.products)
        request.responseDecodable(of: [Product].self) { (response)  in
            if(response.error != nil){
                completionHandler(.failure(response.error!))
            }
            guard let products = response.value else { return }
            //save products locally
            if let dbManager = try? ProductDbManager() {
                do {
                    try dbManager.saveProducts(products)
                } catch let error as NSError {
                    completionHandler(.failure(error as! AFError))
                }
            }
            completionHandler(.success(products))
        }
    }
    
    //This will download the image from server and save in local
    func getImageFromServer(product:Product,completionHandler:@escaping (Result<UIImage?,AFError>)throws->Void) {
        guard let url = product.data else {
            return
        }
        AF.request( url,method: .get).response{ response in
            switch response.result {
                case .success(let responseData):
                    try? completionHandler(.success(UIImage(data: responseData!, scale:1)))
                
                case .failure(let error):
                    try? completionHandler(.failure(error))
            }
        }
    }
    
    func handleIfImageExistFor(products:[Product]) {
        for product in products {
            if product.type == Type.image {
                self.getImageFromServer(product: product) { [weak self](result) in
                    switch result {
                        case .success(let image):
                            self?.saveImage(image: image, for: product)
                        
                        case .failure(let error):
                            throw error
                    }
                }
            }
        }
    }
    
    func saveImage(image:UIImage?, for product:Product){
        if let dbMangager = try? ProductDbManager() {
            try? dbMangager.saveImageInDocumentDirectory(from: product.data, for: product.id, image: image)
        }
    }
    
}

