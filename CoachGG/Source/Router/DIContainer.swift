//
//  DIContainer.swift
//  CoachGG
//
//  Created by Gabriel on 06/08/25.
//

import Foundation

class DIContainer {
    static var shared = DIContainer()
    
    private var services: [String: Any] = [:]
    
    func register<T>(_ type: T.Type, service: T) {
        let key = String(describing: type)
        services[key] = service
    }
    
    func resolve<T>(_ type: T.Type) -> T {
        let key = String(describing: type)
        guard let service = services[key] as? T else {
            fatalError("Service \(key) not registered")
        }
        return service
    }
}
