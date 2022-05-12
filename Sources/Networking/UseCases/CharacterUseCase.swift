//
//  CharacterUseCase.swift
//  Networking
//
//  Created by Roman Syrota on 28.04.2022.
//

import Foundation
import Domain
import Combine

final class CharacterUseCase<Repository>: Domain.CharacterUseCase where Repository: AbstractRepository, Repository.T == Character {
    
    let repository: Repository
    
    init(repository: Repository) {
        self.repository = repository
    }
    
    func characters() -> AnyPublisher<[Character], AppError> {
        return repository
            .fetch(.allCharacters)
    }
    
    func character(_ id: Int) -> AnyPublisher<Character, AppError> {
        return repository
            .fetch(.character(id))
            .compactMap { $0.first }
            .eraseToAnyPublisher()
    }
}
