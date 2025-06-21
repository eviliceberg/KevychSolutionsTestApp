//
//  LocalFileManager.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 21.06.2025.
//

import Foundation

final class LocalFileManager {
    
    static func saveToFileManager<T>(data: T, path: URL) where T : Encodable {
        do {
            let data = try JSONEncoder().encode(data)
            try data.write(to: path)
        } catch {
            print(error)
        }
    }
    
    static func retrieveFromFileManager<T>(path: URL, type: T.Type) throws -> T where T : Decodable {
        let data = try Data(contentsOf: path)
        
        let result = try JSONDecoder().decode(T.self, from: data)
        
        return result
    }
    
}
