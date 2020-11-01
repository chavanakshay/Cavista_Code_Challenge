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
    private var textView:UITextView?
    private var imageView:UIImageView?
    private var label:UILabel?
    private let viewModel = ProductDataViewModel()
    
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
    private func createUI()  {
        guard let type = product?.type else {
            return
        }
        
        switch type {
            case Type.image:
                showImage()
            case Type.string:
                showText()
            default:
                showNothing()
        }
    }
    
    private func showText()  {
        textView = UITextView(frame: .zero)
        textView?.textAlignment = .natural
        if let text = product?.data {
            textView?.text = text
        }
        self.view.addSubview(textView!)
        textView?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview()
        })
        textView?.isScrollEnabled = false
        textView?.isScrollEnabled = true
        textView?.isEditable = false
    }
    
    private func showImage()  {
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
    
    private func showNothing()  {
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
