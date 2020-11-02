//
//  Cavista_Code_ChallengeTests.swift
//  Cavista Code ChallengeTests
//
//  Created by Akshay  Chavan on 08/10/20.
//  Copyright © 2020 Akshay  Chavan. All rights reserved.
//

import XCTest
@testable import Cavista_Code_Challenge

class Cavista_Code_ChallengeTests: XCTestCase {
    var productModel:ProductViewModel!
    
    override func setUp() {
        super.setUp()
        productModel = ProductViewModel()
    }
    
    override func tearDown() {
        productModel = nil
        super.tearDown()
    }
    
    // Asynchronous test: success fast, failure slow
    func testValidCallToGetProducts() {
        
        let promise = expectation(description: "Status code: 200")
        productModel.getProducts { (result) in
            
            switch result {
                case .success( _):
                    promise.fulfill()
                
                case .failure(let error):
                    XCTFail("Error: \(error.localizedDescription)")
            }
        }
        wait(for: [promise], timeout: 5)
    }
    
}
