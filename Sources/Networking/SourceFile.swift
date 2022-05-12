//
//  SourceFile.swift
//  Networking
//
//  Created by Roman Syrota on 04.05.2022.
//

import Foundation

struct SourceFile {
    
    var resource: String
    var pathExtension: String
    var bundle = Bundle(identifier: "com.swiftui.Networking")!
    
    init(resource: String, withExtension pathExtension: String) {
        self.resource = resource
        self.pathExtension = pathExtension
    }
    
    func url(forResource: SourceFile) -> URL? {
        return bundle.url(forResource: forResource.resource, withExtension: forResource.pathExtension)
    }
}

struct File {
    
    static var charactersJson: URL? {
        let fileResource = SourceFile(resource: "characters", withExtension: "json")
        return fileResource.url(forResource: fileResource)
    }
    
    static var characterJson: URL? {
        let fileResource = SourceFile(resource: "character", withExtension: "json")
        return fileResource.url(forResource: fileResource)
    }
}
