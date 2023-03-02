//
//  ComicsModel.swift
//  MarvelCharactersTests
//
//  Created by Apple on 15/07/22.
//

import XCTest

@testable import MarvelCharacters




struct MockCharacterData {
    
    var characters: Characters?
    
    let classObj = CharactersModelTest()
    
    mutating func setCharacters(){
        self.characters = classObj.charactersData
    }
}

class CharactersModelTest: XCTestCase {
    
    var charactersData: Characters?
    
    func testCanParseCharactersViaJSONFile() throws {

        guard let pathString = Bundle(for: type(of: self)).path(forResource: "Characters", ofType: "json") else {
            fatalError("json not found")
        }

        guard let json = try? String(contentsOfFile: pathString, encoding: .utf8) else {
            fatalError("Unable to convert json to String")
        }

        let jsonData = json.data(using: .utf8)!
        let charactersData = try! JSONDecoder().decode(Characters.self, from: jsonData)
        self.charactersData = charactersData
        XCTAssertEqual("3-D Man", charactersData.data?.results?.first?.name)
        XCTAssertEqual(1562, charactersData.data?.total)
        XCTAssertEqual(charactersData.data?.total, self.charactersData?.data?.total)
    }

}
