//
//  Repository.swift
//  TestArch
//
//  Created by Roman Syrota on 28.04.2022.
//

import Foundation
import Combine
import Domain

protocol AbstractRepository {
    associatedtype T
    func fetch(_ token: AppAPI) -> AnyPublisher<T, AppError>
    func fetch(_ token: AppAPI) -> AnyPublisher<[T], AppError>
}

final class Repository<T: Codable>: AbstractRepository {
    
    private let provider: AppNetworking
    
    init(provider: AppNetworking) {
        self.provider = provider
    }
    
    func fetch(_ token: AppAPI) -> AnyPublisher<T, AppError> {
        return provider
            .request(token)
            .mapData(T.self)
    }
    
    func fetch(_ token: AppAPI) -> AnyPublisher<[T], AppError> {
        return provider
            .request(token)
            .mapData([T].self)
    }
}
