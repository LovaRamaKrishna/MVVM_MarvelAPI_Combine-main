//
//  ArrayExt.swift
//  MarvelCharacters
//
//  Created by Apple on 12/07/22.
//

import Foundation


extension Sequence where Iterator.Element: Hashable {
    func unique() -> [Iterator.Element] {
        var seen: Set<Iterator.Element> = []
        return filter { seen.insert($0).inserted }
    }
}
