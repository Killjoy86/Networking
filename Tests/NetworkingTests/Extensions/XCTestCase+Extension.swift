//
//  File.swift
//  Created by Roman Syrota on 12.05.2022.
//

import XCTest
import Combine

extension XCTestCase {
    func awaitPublisher<T: Publisher>(
        _ publisher: T,
        timeout: TimeInterval = 10,
        file: StaticString = #file,
        line: UInt = #line
    ) throws -> T.Output {
        var result: Result<T.Output, Error>?
        let expectation = expectation(description: "awaiting publisher")
        
        let cancellable = publisher
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    result = .failure(error)
                }
                expectation.fulfill()
            }, receiveValue: { value in
                result = .success(value)
            })
            
        wait(for: [expectation], timeout: timeout)
        cancellable.cancel()
        
        return try XCTUnwrap(
            result,
            "Awaited publisher did not produce any output",
            file: file,
            line: line
        ).get()
    }
}

