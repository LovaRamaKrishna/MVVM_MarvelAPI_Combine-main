//
//  CharactersViewModel.swift
//  MarvelCharacters
//
//  Created by Apple on 03/07/22.
//

import Foundation
import Combine

class CharactersViewModel {
 
    private var usersSubject = PassthroughSubject<[Results], Error>()
    private var title: String = TitlesConstants.charactersTitle
    private var arrayOfResults: [Results] = []
    var totalCount : Int64?
    var isGetResponse : Bool = false
    var totalArrayCount = 0
    var offSetValue = 0
    private var searchHistory: [String] = {
        var array = Array<String>()
        array.reserveCapacity(5)
        return array
    }()
    
    // Dependency Injection
    private var router: Router
    private let apiManager: APIManagerService
    
    init(apiManager: APIManagerService, router: Router) {
        self.apiManager = apiManager
        self.router     = router
    }
        
    func getCharacters(text: String, isFromSearch: Bool, isNewPage: Bool) {
        if isFromSearch{
            self.router = .getCharacters(searchKey: text, offSet: 0)
        }else{
            self.router = .getCharacters(searchKey: text, offSet: Int64(offSetValue))
        }
        if !isNewPage {
            LoadingIndicatorView.show()
        }
        let url = self.router.getUrl()
        self.apiManager.fetchItems(url: url) { [weak self] (result: Swift.Result<Characters, NetworkError>) in
            LoadingIndicatorView.hide()
            switch result {
            case.failure(let error):
                self?.usersSubject.send(completion: .failure(error))
            case .success(let characters):
                DispatchQueue.main.async {
                    self?.isGetResponse = false
                    self?.totalCount = Int64(characters.data?.results?.count ?? 0)
                    self?.totalArrayCount = characters.data?.total ?? 0
                    if !isFromSearch{
                        self?.offSetValue = (self?.arrayOfResults.count ?? 0) + 20
                        self?.arrayOfResults += characters.data?.results ?? []
                    } else {
                        self?.arrayOfResults = characters.data?.results ?? []
                    }
                    self?.usersSubject.send(characters.data?.results ?? [])
                }
            }
        }
    }
    
    func addNewElementTofixedArray(element: String) -> [String] {
        if var array = UserDefaults.standard.stringArray(forKey: Constants.searchHistoryArray) {
            if UserDefaults.standard.stringArray(forKey: Constants.searchHistoryArray)?.count == 5 {
                array.removeLast()
                array.insert(element, at: 0)
                UserDefaults.standard.set(array, forKey: Constants.searchHistoryArray)
                UserDefaults.standard.synchronize()
            } else {
                array.insert(element, at: 0)
                UserDefaults.standard.set(array, forKey: Constants.searchHistoryArray)
                UserDefaults.standard.synchronize()
            }
            return UserDefaults.standard.stringArray(forKey: Constants.searchHistoryArray) ?? [String]()
        } else {
            self.searchHistory.append(element)
            UserDefaults.standard.set(self.searchHistory, forKey: Constants.searchHistoryArray)
            UserDefaults.standard.synchronize()
            return UserDefaults.standard.stringArray(forKey: Constants.searchHistoryArray) ?? [String]()
        }
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getCharacters() -> [Results] {
        return self.arrayOfResults
    }
    
    func setCharacters(arrayOfResults: [Results]) {
        self.arrayOfResults = arrayOfResults
    }
    
    func getUserSubject() -> PassthroughSubject<[Results], Error> {
        return self.usersSubject
    }
    
    func getSearchHistoryArray() -> [String] {
        return UserDefaults.standard.stringArray(forKey: Constants.searchHistoryArray) ?? [String]()
    }
}
