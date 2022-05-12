//
//  UseCaseProvider.swift
//  Networking
//
//  Created by Roman Syrota on 28.04.2022.
//

import Foundation
import Domain

public class UseCaseProvider: Domain.UseCaseProvider {
    
    let provider: AppNetworking
    
    public init(provider: AppNetworking) {
        self.provider = provider
    }
    
    public func makeCharacterUseCase() -> Domain.CharacterUseCase {
        let repository = Repository<Character>(provider: provider)
        return CharacterUseCase(repository: repository)
    }
}
