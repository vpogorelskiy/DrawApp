//
//  ServiceLocator.swift
//  DrawApp
//
//  Created by Vyacheslav Pogorelskiy on 04.11.2024.
//

import Foundation

open class ServiceLocator {
    static var sharedInstance = ServiceLocator()
    
    private var storedReferences: [String: Any] = .init()
    
    func getInstanceOf<T>(type: T.Type) -> T? {
        let typeName = stringFrom(type: type)
        if let storedInstance = storedReferences[typeName] as? T {
            return storedInstance
        }
        if let resolved = Resolver.sharedInstance.resolve(type) {
            saveInstance(resolved)
            return resolved
        }
        
        return nil
    }
    
    func saveInstance<T>(_ instance: T) {
        let typeName = stringFrom(type: type(of: instance).self)
        storedReferences[typeName] = instance
    }
    
    private func stringFrom<T>(type: T.Type) -> String {
        return type == Any.self ? "Any" : String(describing: type.self)
    }
}
