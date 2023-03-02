//
//  ViewTest.swift
//  MarvelCharactersTests
//
//  Created by Apple on 16/07/22.
//

import XCTest

@testable import MarvelCharacters

class ViewTest: XCTestCase {
    
    var sut = UIView()
    
    override func setUp() {
        super.setUp()
        setupMainScreenWorker()
    }
    
    // MARK: Test setup
    
    func setupMainScreenWorker() {
     
        let myview = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        sut.fillSuperView(myview)
        sut.addBorder(color: .black)
        sut.anchor(top: myview.topAnchor, left: myview.leftAnchor, bottom: myview.bottomAnchor, right: myview.rightAnchor, paddingTop: 0, paddingLeft: 0, paddingBottom: 0, paddingRight: 0, width: 100, height: 100)
        sut.center(inView: myview)
        XCTAssertEqual(myview.frame, (sut.frame))
    }
}
