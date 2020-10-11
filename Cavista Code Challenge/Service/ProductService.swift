//
//  ProductService.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import Foundation
import Alamofire
import RealmSwift

class Connectivity {
    class var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
}

class ProductService {
    var realm: Realm = try! Realm()
    
    func getProductsFromServer(completionHandler:@escaping (Result<[Product],AFError>)->Void)  {
        
        //create request
          let request = AF.request(URLS.products)
          request.responseDecodable(of: [Product].self) { (response) in
            if(response.error != nil){
                print("ERROR: \(String(describing: response.error?.localizedDescription))")
                completionHandler(.failure(response.error!))
            }
            guard let products = response.value else { return }
            //save products locally
            self.saveProducts(products)
            completionHandler(.success(products))
          }
    }
    
    //This will download the image from server and save in local
    func getImageFromServer(product:Product,completionHandler:@escaping (Result<UIImage?,AFError>)->Void){
        guard let url = product.data else {
            return
        }
        if Connectivity.isConnectedToInternet {
            AF.request( url,method: .get).response{ response in
               switch response.result {
                case .success(let responseData):
                    self.saveImageInDocumentDirectory(from: url, for: product.id, image: UIImage(data: responseData!, scale:1))
                    completionHandler(.success(UIImage(data: responseData!, scale:1)))
                
                case .failure(let error):
                    completionHandler(.failure(error))
                }
            }
        }else{
            let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            if let imageName = url.components(separatedBy: "/").last {
                let finalImageName = "\(imageName)_\(product.id)"
                let fileURL = documentsURL.appendingPathComponent(finalImageName)
                let image    = UIImage(contentsOfFile: fileURL.path)
                completionHandler(.success(image))
            }
        }
    }
}


//This extention is for saving the objects in Realm and also saving the Images in Document directory
extension ProductService {
    
    //This will save the image in document directory
    private func saveImage(of product:Product){
        if Connectivity.isConnectedToInternet {
            self.getImageFromServer(product: product) { (result) in
                switch result {
                case .success(_):
                    print("SAVED")
                case .failure(_):
                    print("FAILED ")
                }
            }
        }
    }
    
    private func saveImageInDocumentDirectory(from url:String, for productId:String, image:UIImage?){
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        var finalImageName = ""
        if let imageName = url.components(separatedBy: "/").last {
            finalImageName = "\(imageName)_\(productId)"
        }
        let fileURL = documentsURL.appendingPathComponent(finalImageName)
        if let data = image?.jpegData(compressionQuality:  1.0){
            try? data.write(to: fileURL)
        }
    }
    
    //This method will save the product in realm
    private func saveProduct(_ product: Product){
        if product.type == TYPE.image {
                saveImage(of: product)
        }
        
        try! realm.write {
            realm.add(product)
        }
    }
    
    //this method will look for the product in realm and return if it exist
    private func findProduct(_ id: String) -> Results<Product>{
        let predicate = NSPredicate(format: "id = %@", id)
        return realm.objects(Product.self).filter(predicate)
    }
    
    //this method will update the product localy if it is updated on server
    private func updateProduct(_ oldProduct: Product, with newProduct: Product){
        if newProduct.type == TYPE.image {
               saveImage(of: newProduct)
        }

        try! realm.write {
            oldProduct.date = newProduct.date
            oldProduct.type = newProduct.type
            oldProduct.data = newProduct.data
        }
    }
    
    //this method will take the array of products and save them by calling saveProduct method
    func saveProducts(_ products:[Product]){
        //Retrive each product
        products.forEach { (product) in
            //check if the product is exist in local
            let results = findProduct(product.id)
            if(results.count == 0){
                //if product is not exist save the product in local
                saveProduct(product)
            }else{
                //if product is exist then update the product
                guard let newProduct = results.first else{
                    return
                }
                updateProduct(product, with: newProduct)
            }
        }
    }
    
    //this method will retrive all the products from local
    func getAllProducts() -> Results<Product>{
        return realm.objects(Product.self)
    }
    
}
