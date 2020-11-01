//
//  ProductViewModel.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit
import Alamofire

class ProductViewModel {
    var products:[Product]?
    
    func getProducts(completionHandler:@escaping (Result<Bool,Error>)->Void)  {
        let service = ProductService()
        
        //check for the network availability
        if Connectivity.isConnectedToInternet {
            //Get products from server and return
            service.getProductsFromServer {[weak self] (result) in
                switch result {
                    case .success(let products):
                        self?.products = products
                        self?.sortProducts()
                        service.handleIfImageExistFor(products: products)
                        completionHandler(.success(true))
                    case .failure(let error):
                        completionHandler(.failure(error))
                }
            }
        }else{
            //get products from local
            if let dbManager = try?ProductDbManager(){
                self.products = dbManager.getAllProducts().filter({ (product) -> Bool in
                    true
                })
            }
            
            if self.products?.count == 0 {
                completionHandler(.failure(ProductError.nodataExist(message: "No products available.")))
            }else{
                self.sortProducts()
                completionHandler(.success(true))
            }
        }
        
    }
    
    //This will sort the products in assending order
    private func sortProducts(){
        products?.sort(by: { (product1, product2) -> Bool in
            guard let type1 = product1.type else{
                return false
            }
            guard let type2 = product2.type else{
                return false
            }
            return type1.localizedCaseInsensitiveCompare(type2) == ComparisonResult.orderedAscending
        })
    }
}

