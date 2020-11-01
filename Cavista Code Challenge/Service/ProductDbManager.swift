//
//  ProductDbManager.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 31/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit
import RealmSwift

class ProductDbManager {
    var realm: Realm
    
    init()throws {
        do {
            self.realm = try Realm()
        } catch let error as NSError {
            // handle error
            throw ProductError.realmInitFailed(error: error)
        }
    }
    
    //This method will save the product in realm
    private func saveProduct(_ product: Product)throws{
        do {
            try realm.write {
                realm.add(product)
            }
        } catch let error as NSError {
            throw ProductError.saveProductFailed(error: error)
        }
    }
    
    //this method will look for the product in realm and return if it exist
    private func findProduct(_ id: String) -> Results<Product>{
        let predicate = NSPredicate(format: "id = %@", id)
        return realm.objects(Product.self).filter(predicate)
    }
    
    //this method will update the product localy if it is updated on server
    private func updateProduct(_ oldProduct: Product, with newProduct: Product)throws{
        do {
            try realm.write {
                oldProduct.date = newProduct.date
                oldProduct.type = newProduct.type
                oldProduct.data = newProduct.data
            }
        } catch let error as NSError {
            throw ProductError.saveProductFailed(error: error)
        }
    }
    
    //this method will take the array of products and save them by calling saveProduct method
    func saveProducts(_ products:[Product])throws{
        //Retrive each product
        do {
            try products.forEach { (product) in
                //check if the product is exist in local
                let results = findProduct(product.id)
                if(results.count == 0){
                    do {
                        try saveProduct(product)
                    } catch let error as NSError {
                        throw ProductError.saveProductFailed(error: error)
                    }
                }else{
                    //if product is exist then update the product
                    guard let newProduct = results.first else{
                        return
                    }
                    do {
                        try updateProduct(product, with: newProduct)
                    } catch let error as NSError {
                        throw ProductError.saveProductFailed(error: error)
                    }
                }
            }
        } catch let error as NSError {
            throw ProductError.saveProductFailed(error: error)
        }
        
    }
    
    //this method will retrive all the products from local
    func getAllProducts() -> Results<Product>{
        return realm.objects(Product.self)
    }
    
    //This will return the image from document directory
    func getImageFromDocumentDirectory(for product:Product) -> UIImage? {
        guard let url = product.data else {
            return nil
        }
        
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        if let imageName = url.components(separatedBy: "/").last {
            let finalImageName = "\(imageName)_\(product.id)"
            let fileURL = documentsURL.appendingPathComponent(finalImageName)
            let image    = UIImage(contentsOfFile: fileURL.path)
            return image
        }
        return nil
    }
    
    //This will save the image in document directory
    func saveImageInDocumentDirectory(from url:String?, for productId:String, image:UIImage?)throws{
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var finalImageName = ""
        if let imageName = url?.components(separatedBy: "/").last {
            finalImageName = "\(imageName)_\(productId)"
        }
        let fileURL = documentsURL.appendingPathComponent(finalImageName)
        if let data = image?.jpegData(compressionQuality:  1.0){
            do {
                try data.write(to: fileURL)
            } catch let error as NSError {
                throw error
            }
        }
    }
}
