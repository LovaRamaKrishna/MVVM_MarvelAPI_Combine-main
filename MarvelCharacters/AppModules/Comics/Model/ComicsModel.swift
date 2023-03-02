//
//  ComicsModel.swift
//  MarvelCharacters
//
//  Created by Apple on 13/07/22.
//

struct ComicsModel: Codable {
    let code: Int
    let status, copyright, attributionText, attributionHTML: String
    let etag: String
    let data: DataClas
}

// MARK: - DataClass
struct DataClas: Codable {
    let offset, limit, total, count: Int
    let results: [ComicsObj]
}

// MARK: - Result
struct ComicsObj: Codable {
    let id, digitalID: Int
    let title: String
    let issueNumber: Int
    let variantDescription: String
    let resultDescription: String?
    let isbn, upc: String
    let ean, issn: String
    let pageCount: Int
    let resourceURI: String
    let urls: [URLElement]
    let thumbnail: Thumbnail
    let images: [Thumbnail]

    enum CodingKeys: String, CodingKey {
        case id
        case digitalID = "digitalId"
        case title, issueNumber, variantDescription
        case resultDescription = "description"
        case isbn, upc, ean, issn, pageCount, resourceURI, urls, thumbnail, images
    }
}


enum FilterActions: Int, CaseIterable {
    case all         = 0
    case lastWeek    = 1
    case thisWeek    = 2
    case nextWeek    = 3
    case thisMonth   = 4
    
    static var buttonList: [String] {
        return FilterActions.allCases.map { $0.description }
    }
    
    var description: String {
        switch self {
        case .all:          return "All"
        case .lastWeek:     return "Last Week"
        case .thisWeek:     return "This Week"
        case .nextWeek:     return "Next Week"
        case .thisMonth:    return "This Month"
        }
    }
    
    var apiKeys: String {
        switch self {
        case .all:          return ""
        case .lastWeek:     return "lastWeek"
        case .thisWeek:     return "thisWeek"
        case .nextWeek:     return "nextWeek"
        case .thisMonth:    return "thisMonth"
        }
    }
}

