//
//  ProductDescriptionViewController.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 09/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit

class ProductDescriptionViewController: UIViewController {
    weak var product:Product?
    var label:UILabel?
    var imageView:UIImageView?
    let viewModel = ProductDataViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Product Data"
        self.view.backgroundColor = .white
        createUI()
        // Do any additional setup after loading the view.
    }

}


//This extention is to create the UI Componants
extension ProductDescriptionViewController{
    func createUI()  {
        guard let type = product?.type else {
            return
        }
        
        switch type {
        case TYPE.image:
            showImage()
        case TYPE.string:
            showText()
        default:
            showNothing()
        }
    }
    
    func showText()  {
        label = UILabel(frame: .zero)
        label?.numberOfLines = 0
        label?.textAlignment = .center
        if let text = product?.data {
            label?.text = text
        }
        self.view.addSubview(label!)
        
        label?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        })
        
    }
    
    func showImage()  {
        imageView = UIImageView(frame: .zero)
        imageView?.contentMode = .scaleAspectFit
        self.view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        })
        
        let label = UILabel(frame: .zero)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: 20)
        label.text = "Loading..."
        imageView?.addSubview(label)
        label.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview()
        })
        
            viewModel.getImageFor(product: product!) { (result) in
                switch result {
                case .success(_):
                    if(self.viewModel.image == nil){
                        label.text = "Something went wrong!"
                    }else{
                    label.removeFromSuperview()
                    self.imageView?.image = self.viewModel.image
                    }
                case .failure(let error):
                    label.text = error.localizedDescription
                }
            }
    }
    
    func showNothing()  {
        label = UILabel(frame: .zero)
        label?.numberOfLines = 0
        label?.textAlignment = .center
        label?.text = "No Data available!"

        self.view.addSubview(label!)
        
        label?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        })
    }
}
