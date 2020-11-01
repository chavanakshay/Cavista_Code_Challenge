//
//  ProductListViewController.swift
//  Cavista Code Challenge
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import UIKit
import SnapKit

class ProductListViewController: UIViewController {
    private let viewModel = ProductViewModel()
    private let tableView = UITableView()
    private var label:UILabel?
    override func viewDidLoad() {
        super.viewDidLoad()
        createUIComponants()
        self.view.backgroundColor = UIColor.white
        viewModel.getProducts {[weak self] (result) in
            switch(result){
                case .success( _):
                    self?.label?.isHidden = true
                    self?.tableView.reloadData()
                case.failure(let error):
                    guard case ProductError.nodataExist(let message) = error else { fatalError() }
                    self?.label?.text = message
            }
            
        }
    }
}

//This extention is for creating the UI elements programatically
extension ProductListViewController{
    
    private func createUIComponants()  {
        self.createTableView()
        self.showNothing()
    }
    
    private func showNothing()  {
        label = UILabel(frame: .zero)
        label?.numberOfLines = 0
        label?.textAlignment = .center
        label?.font = .boldSystemFont(ofSize: 20)
        label?.text = "Loading..."
        
        self.view.addSubview(label!)
        
        label?.snp.makeConstraints({ (make) in
            make.top.bottom.left.right.equalToSuperview().offset(0)
        })
    }
    
    
    private func createTableView(){
        self.view.addSubview(tableView)
        tableView.tableFooterView = UIView()
        tableView.snp.makeConstraints { (make) in
            make.bottom.equalTo(self.view).offset(-5)
            make.leading.equalTo(self.view).inset(16)
            make.trailing.equalTo(self.view).offset(-10)
            let height:Int = Int(self.navigationController?.navigationBar.frame.size.height ?? 0)
            make.top.equalTo(self.view).offset(height)
        }
        
        tableView.register(ProductTableViewCell.self, forCellReuseIdentifier: ProductTableViewCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 100
    }
}

//This extention will be used to handle the UITableView Delegate and DataSource Methods
extension ProductListViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductTableViewCell.identifier, for: indexPath) as! ProductTableViewCell
        if let product = viewModel.products?[indexPath.item] {
            cell.updateData(product: product)
            
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let product = viewModel.products?[indexPath.item] {
            let viewController = ProductDescriptionViewController()
            viewController.product = product
            self.navigationController?.pushViewController(viewController, animated: true)
        }
    }
}
