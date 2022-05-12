//
//  AnyPublisher+Extension.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import Foundation
import Combine
import Moya
import Domain

extension Publisher where Output == Response, Failure == AppError {
    
    func mapData<T: Codable>(_ type: T.Type) -> AnyPublisher<T, AppError> {
        return subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap { try $0.map(T.self) }
            .mapError(AppError.init)
            .eraseToAnyPublisher()
    }
}
