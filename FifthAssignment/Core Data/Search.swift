//
//  Search.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 18.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class Search: NSManagedObject {
    class func findOrCreateSearch(matching searchQuery: String, in context: NSManagedObjectContext) throws -> Search {
        let request: NSFetchRequest<Search> = Search.fetchRequest()
        request.predicate = NSPredicate(format: "query = %@", searchQuery)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let search = Search(context: context)
        search.query = searchQuery
        return search
    }
}

