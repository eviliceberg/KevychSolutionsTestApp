//
//  FileManager+Ext.swift
//  KevychSolutionsTestApp
//
//  Created by Artem Golovchenko on 21.06.2025.
//

import Foundation

extension FileManager {
    
    static var cacheDirectory: URL {
        let paths = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        return paths[0]
    }
    
}
