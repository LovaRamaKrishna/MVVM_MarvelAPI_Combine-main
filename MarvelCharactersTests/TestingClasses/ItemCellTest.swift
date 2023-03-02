//
//  ItemCellTest.swift
//  MarvelCharactersTests
//
//  Created by Apple on 17/07/22.
//

import XCTest
import Combine

@testable import MarvelCharacters

class ItemCellTest: XCTestCase {
    
    var sut: ItemCell!
    var charactersResult  = MockCharacterData().characters?.data?.results?.first
    var comicResult = MockComicsData().comics?.data.results.first
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
        sut = ItemCell()
    }
    
    func test_setup(){
        sut.setup()
    }
    
    func test_configureCharactersCell() {
        if let results = charactersResult {
        sut.configureCharactersCell(results: results)
           XCTAssertNotNil(results)
            XCTAssertEqual("3-D Man", results.name)
        if let path = results.thumbnail?.path, let thumbnailExtension = results.thumbnail?.thumbnailExtension {
            sut.imageView.loadRemoteImageFromServer(urlString: "\(path)\(AppURLS.extentionImageUrl)\(thumbnailExtension)")
        }
        }
    }
    
    func test_configureComicCell() {
        if let result = comicResult {
            sut.configureComicCell(results: result)
            XCTAssertNotNil(result)
            XCTAssertEqual("Marvel Previews (2017)", result.title)
        }
    }
    
}
