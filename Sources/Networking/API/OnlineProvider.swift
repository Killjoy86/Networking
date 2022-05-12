//
//  OnlineProvider.swift
//  TestArch
//
//  Created by Roman Syrota on 22.04.2022.
//

import Foundation
import Domain
import Moya
import Combine
import CombineMoya

public final class OnlineProvider<Target> where Target: Moya.TargetType {
    
    fileprivate let online: AnyPublisher<Bool, Never>
    fileprivate let provider: MoyaProvider<Target>
    
    init(endpointClosure: @escaping MoyaProvider<Target>.EndpointClosure = MoyaProvider<Target>.defaultEndpointMapping,
         requestClosure: @escaping MoyaProvider<Target>.RequestClosure = MoyaProvider<Target>.defaultRequestMapping,
         stubClosure: @escaping MoyaProvider<Target>.StubClosure = MoyaProvider<Target>.neverStub,
         plugins: [PluginType] = [],
         trackInflights: Bool = false,
         online: AnyPublisher<Bool, Never> = Reachability.shared.reach) {
        self.online = online
        self.provider = MoyaProvider(
            endpointClosure: endpointClosure,
            requestClosure: requestClosure,
            stubClosure: stubClosure,
            plugins: plugins,
            trackInflights: trackInflights
        )
    }
    
    func request(_ token: Target) -> AnyPublisher<Response, AppError> {
        let request = provider
            .requestPublisher(token)
        
        return online
            .prefix(1) // Take 1 to make sure we only invoke the API once.
            .flatMap { _ in
                request
                    .filterSuccessfulStatusCodes()
                    .handleEvents(receiveCompletion: { completion in
                        switch completion {
                        case .failure(let error):
                            switch error {
                            case .statusCode(let response):
                                if response.statusCode == 401 {
                                    // Unauthorized
                                }
                            default:
                                break
                            }
                        default:
                            break
                        }
                    })
            }
            .mapError(AppError.init)
            .eraseToAnyPublisher()
    }
}

public protocol NetworkingType {
    associatedtype T: TargetType
    var provider: OnlineProvider<T> { get }
}

public struct AppNetworking: NetworkingType {
    public typealias T = AppAPI
    public let provider: OnlineProvider<AppAPI>
}

// MARK: - "Public" interfaces
extension AppNetworking {
    func request(_ token: AppAPI) -> AnyPublisher<Moya.Response, AppError> {
        let actualRequest = provider.request(token)
        return actualRequest
    }
}

// Static methods
extension NetworkingType {
    public static func appNetworking(xAccessToken: String? = nil) -> AppNetworking {
        let provider = OnlineProvider<AppAPI>(
            endpointClosure: AppNetworking.endpointsClosure(xAccessToken),
            requestClosure: AppNetworking.endpointResolver(),
            stubClosure: AppNetworking.APIKeysBasedStubBehaviour,
            plugins: plugins
        )
        return AppNetworking(provider: provider)
    }
    
    public static func stubbedNetworking() -> AppNetworking {
        let provider: OnlineProvider<AppAPI> = OnlineProvider(
            endpointClosure: endpointsClosure(),
            requestClosure: AppNetworking.endpointResolver(),
            stubClosure: MoyaProvider.immediatelyStub,
            online: Just(true).eraseToAnyPublisher()
        )
        return AppNetworking(provider: provider)
    }
}

extension NetworkingType {
    static func endpointsClosure<T>(_ xAccessToken: String? = nil) -> (T) -> Endpoint where T: TargetType {
        return { target in
            let endpoint = MoyaProvider.defaultEndpointMapping(for: target)
            // Sign all non-XApp, non-XAuth token requests
            return endpoint
        }
    }

    static func APIKeysBasedStubBehaviour<T>(_: T) -> Moya.StubBehavior {
        return .never
    }
    
    static var networkLoggerPlugin: NetworkLoggerPlugin {
        var config = NetworkLoggerPlugin.Configuration()
        config.logOptions = .verbose
        config.formatter = NetworkLoggerPlugin.Configuration.Formatter(responseData: {
            do {
                let dataJSON = try JSONSerialization.jsonObject(with: $0)
                let prettyData =  try JSONSerialization.data(withJSONObject: dataJSON, options: .prettyPrinted)
                return String(data: prettyData, encoding: .utf8) ?? ""
            } catch {
                return ""
            }
        })
        return NetworkLoggerPlugin(configuration: config)
    }
    
    static var plugins: [PluginType] {
        var plugins: [PluginType] = []

        plugins.append(networkLoggerPlugin)

//        let authPlugin = AccessTokenPlugin { type in
//            let token: Token? = AuthManager.shared.token
//            return token?.accessToken ?? ""
//        }
//        plugins.append(authPlugin)
        
        return plugins
    }
    
    static var authProvider: MoyaProvider<AppAPI> {
        return MoyaProvider<AppAPI>(plugins: plugins)
    }
    
    static func endpointResolver() -> MoyaProvider<T>.RequestClosure {
        return { endpoint, closure in
            do {
                var request = try endpoint.urlRequest()
                request.httpShouldHandleCookies = false
                closure(.success(request))
//                guard let token = AuthManager.shared.token, token.isExpired else {
//                    closure(.success(request))
//                    return
//                }
//
//                authProvider.request(.refresh(token.refreshToken)) { result in
//                    switch result {
//                    case .success(let response):
//                        if response.statusCode == 401 {
//                            logError("response.statusCode == 401")
//                            AuthManager.removeToken()
//                            UserDefaultData.clearCache()
//                            Application.shared.presentInitialScreen(in: Application.shared.window)
//                            return
//                        }
//
//                        do {
//                            let newToken = try response.map(Token.self)
//                            AuthManager.shared.token = newToken
//                            closure(.success(request))
//                        } catch {
//                            logError("Refresh parse error: \(error)")
//                            AuthManager.removeToken()
//                            UserDefaultData.clearCache()
//                            Application.shared.presentInitialScreen(in: Application.shared.window)
//                            closure(.failure(MoyaError.objectMapping(error, response)))
//                        }
//                    case .failure(let error):
//                        logError("Refresh token error: \(error)")
//                        AuthManager.removeToken()
//                        UserDefaultData.clearCache()
//                        Application.shared.presentInitialScreen(in: Application.shared.window)
//                    }
//                }
            } catch {
//                logError("EndpointResolver error: \(error.localizedDescription)")
            }
        }
    }
}
