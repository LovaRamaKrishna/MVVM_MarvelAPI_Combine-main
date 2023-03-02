//
//  APIManer.swift
//  MarvelCharacters
//
//  Created by Apple on 06/07/22.
//

import Foundation
import Combine


enum NetworkError : Error, LocalizedError {
    case noInternet
    case httpStatus(Int)
    case unknown(Error)
    
    public var errorDescription: String? {
        switch self {
            case .noInternet:
            return Constants.noInternet
                
            case .httpStatus(let code):
            return Constants.httpstatusCode + "\(code)"
                
            case .unknown(let error):
            return Constants.error +  "\(error)"
        }
    }
}


protocol APIManagerService {
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void)
}

class APIManager: APIManagerService {
    
    private var subscriber = Set<AnyCancellable>()
    
    func fetchItems<T: Decodable>(url: URL, completion: @escaping (Result<T, NetworkError>) -> Void) {
        if InternetConnectionManager.isConnectedToNetwork(){
            // 1. Create 'dataTaskPusblisher'(Publisher) to make the API call
            URLSession.shared.dataTaskPublisher(for: url)
            // 2. Use 'map'(Operator) to get the data from the result
                .map { $0.data }
            // 3. Decode the data into the 'Decodable' struct using JSONDecoder
                .decode(type: T.self, decoder: JSONDecoder())
            // 4. Make this process in main thread. (you can do this in background thread as well)
                .receive(on: DispatchQueue.main)
            // 5. Use 'sink'(Subcriber) to get the decoaded value or error, and pass it to completion handler
                .sink { (resultCompletion) in
                    switch resultCompletion {
                    case .failure(let error):
                        completion(.failure(NetworkError.unknown(error)))
                        print(error)
                    case .finished:
                        break
                    }
                } receiveValue: { (result) in
                    completion(.success(result))
                }
            // 6. saving the subscriber into an AnyCancellable Set (without this step this won't work)
                .store(in: &subscriber)
        }  else {
            completion(.failure(NetworkError.noInternet))
        }
    }
}
