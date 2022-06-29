//
//  AppAPI.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import Foundation
import Moya
import CombineMoya

public enum AppAPI {
    case allCharacters
    case character(_ id: Int)
}

extension AppAPI: Moya.TargetType, AccessTokenAuthorizable {
    
    public var baseURL: URL {
        return URL(string: "https://www.breakingbadapi.com/api/")!
    }
    
    public var path: String {
        switch self {
        case .allCharacters:
            return "characters"
        case .character(let id):
            return "characters/\(id)"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        default:
            return .get
        }
    }
    
    public var task: Task {
        switch self {
        default:
            return .requestPlain
        }
    }
    
    public var sampleData: Data {
        var url: URL?
        
        switch self {
        case .allCharacters: url = File.charactersJson
        case .character:     url = File.characterJson
        }
        
        if let url = url, let data = try? Data(contentsOf: url) {
            return data
        }
        
        return "There isn't mock data".data(using: .utf8)!
    }
    
    public var headers: [String : String]? {
        switch self {
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    public var authorizationType: AuthorizationType? {
        switch self {
        default:
            return .basic
        }
    }
}
