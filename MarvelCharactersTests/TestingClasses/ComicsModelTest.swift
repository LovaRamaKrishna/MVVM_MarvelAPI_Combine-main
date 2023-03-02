//
//  ComicsModelTest.swift
//  MarvelCharactersTests
//
//  Created by Apple on 15/07/22.
//

import XCTest

@testable import MarvelCharacters


struct MockComicsData {
    
    var comics: ComicsModel?
    
    mutating func setComicsData() {
        let classObj = ComicsModelTest()
        self.comics = classObj.comicsData
    }
    
}

class ComicsModelTest: XCTestCase {
    
    var comicsData: ComicsModel?
    
    func testCanParseComicsViaJSONFile() throws {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Comics", ofType: "json") else {
            fatalError("json not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }

        let jsonData = json.data(using: .utf8)!
        let comicsData = try! JSONDecoder().decode(ComicsModel.self, from: jsonData)
        self.comicsData = comicsData
        XCTAssertEqual("Marvel Previews (2017)", comicsData.data.results.first?.title)
        XCTAssertEqual(52699, comicsData.data.total)
        XCTAssertEqual(comicsData.data.total, self.comicsData?.data.total)
    }

}
