//
//  Reachability.swift
//  Networking
//
//  Created by Roman Syrota on 04.05.2022.
//

import Foundation
import Combine
import Network

class Reachability: NSObject {
    
    static let shared = Reachability()
    
    private let reachSubject = CurrentValueSubject<Bool, Never>(true)
    
    private let queue = DispatchQueue(label: "reachability.monitor")
    
    var reach: AnyPublisher<Bool, Never> {
        return reachSubject.eraseToAnyPublisher()
    }
    
    override init() {
        super.init()
        let monitor = NWPathMonitor()
        
        monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                if path.status == .satisfied {
                    self.reachSubject.send(true)
                } else {
                    self.reachSubject.send(false)
                }
            }
        }
        
        monitor.start(queue: queue)
    }
}
