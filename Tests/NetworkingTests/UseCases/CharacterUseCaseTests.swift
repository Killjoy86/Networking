//
//  File.swift
//  Created by Roman Syrota on 12.05.2022.
//

import XCTest
import Combine
import Domain
@testable import Networking

class MockCharacterUseCaseTests: XCTestCase {
    
    var bag = Set<AnyCancellable>()
    
    var mockedServices: Domain.UseCaseProvider!
    var mockedUseCase: Domain.CharacterUseCase!
    
    override func setUp() {
        super.setUp()
        
        let provider: AppNetworking = .stubbedNetworking()
        mockedServices = Networking.UseCaseProvider(provider: provider)
        mockedUseCase = mockedServices.makeCharacterUseCase()
    }
    
    override func tearDown() {
        super.tearDown()
        bag.removeAll()
    }
}

final class CharacterUseCaseTests: MockCharacterUseCaseTests {
    
    func testSuccessRequestCharacters() throws {
        let publisher = mockedUseCase
            .characters()
        
        let result = try awaitPublisher(publisher)
        XCTAssertFalse(result.isEmpty)
    }
    
    func testSuccessRequstSingleCharacter() throws {
        let publisher = mockedUseCase
            .character(1)
        let result = try awaitPublisher(publisher)
        
        XCTAssertEqual(result, .stub)
    }
}
