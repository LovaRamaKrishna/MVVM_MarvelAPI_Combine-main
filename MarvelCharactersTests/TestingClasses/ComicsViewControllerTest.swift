//
//  ComicsViewControllerTest.swift
//  MarvelCharactersTests
//
//  Created by Apple on 15/07/22.
//

import XCTest

@testable import MarvelCharacters

class ComicsViewControllerTest: XCTestCase {
    
    var sut: ComicsViewController!
    
    override func setUp() {
        super.setUp()
        setupMainScreenWorker()
    }
    
    override func tearDown() {
     super.tearDown()
        sut = nil
     }
    
    // MARK: Test setup
    
    func setupMainScreenWorker() {
        let layout = UICollectionViewFlowLayout()
        sut = ComicsViewController(collectionViewLayout: layout)
    }
    
    func test_viewDidLoad() {
        sut.viewDidLoad()
        sut.change(to: 1)
        XCTAssertNotNil(sut)
    }
   
}
