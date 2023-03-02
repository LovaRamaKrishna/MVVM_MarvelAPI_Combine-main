//
//  ComicsViewModel.swift
//  MarvelCharacters
//
//  Created by Apple on 13/07/22.
//

import Foundation
import Combine


class ComicsViewModel {
    
    private var usersSubject = PassthroughSubject<[ComicsObj], Error>()
    private var title: String = TitlesConstants.comicsTitle
    private var arrayOfResults: [ComicsObj] = []
    var totalCount : Int64?
    var isGetResponse : Bool = false
    var totalArrayCount = 0
    var offSetValue = 0
    private let offsetcount = 20
    
    // Dependency Injection
    private var router: Router
    private let apiManager: APIManagerService
    
    init(apiManager: APIManagerService, router: Router) {
        self.apiManager = apiManager
        self.router     = router
    }
    
    func getComics(isFromSearch: Bool, isNewPage: Bool, filterKey: String?, isNewOffset: Bool) {
        if !isNewPage {
            LoadingIndicatorView.show()
        }
        if isNewOffset{
            self.offSetValue = 0
        }
        self.router = .getComics(offSet: Int64(offSetValue), filterKey: filterKey ?? Constants.emptyString)
        let url = self.router.getUrl()
        self.apiManager.fetchItems(url: url) { [weak self] (result: Result<ComicsModel, NetworkError>) in
            LoadingIndicatorView.hide()
            switch result {
            case.failure(let error):
                self?.usersSubject.send(completion: .failure(error))
            case .success(let comicsModel):
                DispatchQueue.main.async {
                    self?.isGetResponse = false
                    self?.totalCount = Int64(comicsModel.data.results.count)
                    self?.totalArrayCount = comicsModel.data.total
                    if !isFromSearch {
                        self?.offSetValue = (self?.arrayOfResults.count ?? 0) + (self?.offsetcount ?? 0)
                        self?.arrayOfResults += comicsModel.data.results
                    } else {
                        self?.offSetValue += self?.offsetcount ?? 0
                        self?.arrayOfResults = comicsModel.data.results
                    }
                   // print(comicsModel.data.results)
                    self?.usersSubject.send(comicsModel.data.results)
                }
            }
        }
    }
    
    func getTitle() -> String {
        return self.title
    }
    
    func getComics() -> [ComicsObj] {
        return self.arrayOfResults
    }
    
    func setCharacters(arrayOfResults: [ComicsObj]) {
        self.arrayOfResults = arrayOfResults
    }
    
    func getUserSubject() -> PassthroughSubject<[ComicsObj], Error> {
        return self.usersSubject
    }
}
