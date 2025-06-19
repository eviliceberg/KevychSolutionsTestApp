//
//  NetworkManager.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 19.06.2025.
//

import Foundation
import Combine

final class NetworkingManager {
    
    static func download(url: URL) -> AnyPublisher<Data, any Error> {
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap( { try handleURLSession(output: $0, url: url) } )
            .retry(3)
            .eraseToAnyPublisher()
    }
    
    static func handleURLSession(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard let response = output.response as? HTTPURLResponse , response.statusCode >= 200 && response.statusCode < 300 else {
            throw URLError(.badURL)
        }
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
        case .finished:
            break
        case .failure(let failure):
            print(failure.localizedDescription)
        }
    }
    
}
