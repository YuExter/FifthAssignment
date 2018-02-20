//
//  RecentQueries.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import Foundation

struct RecentQueries {
    private static let queriesLimit = 100
    private static let key = "recentQueries"
    
    public static func add(query: String) {
        var recentQueries = self.getQuery()
        let lowercaseQuery = query.lowercased()
        for recentQuery in recentQueries {
            if recentQuery == lowercaseQuery {
                return
            }
        }
        
        recentQueries.insert(query, at: 0)
        
        if recentQueries.count > self.queriesLimit {
            recentQueries.removeLast()
        }
        UserDefaults.standard.set(recentQueries, forKey: key)
    }
    
    public static func getQuery() -> [String] {
        return UserDefaults.standard.stringArray(forKey: key) ?? []
    }
    
    public static func remove(query: String) {
        var recentQueries = self.getQuery()
        
        if let index = recentQueries.index(of: query) {
            recentQueries.remove(at: index)
            UserDefaults.standard.set(recentQueries, forKey: key)
        }
    }
}
