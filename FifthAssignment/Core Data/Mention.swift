//
//  Mention.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 18.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class Mention: NSManagedObject {
    
    class func findOrCreateMention(searchQuery query: String, matching mentionInfo: TweetMention, in context: NSManagedObjectContext) throws -> Mention {
        let request: NSFetchRequest<Mention> = Mention.fetchRequest()
        request.predicate = NSPredicate(format: "keyword = %@ AND query = %@", mentionInfo.keyword, query)
        
        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                matches[0].count = matches[0].count + 1;
                return matches[0]
            }
        } catch {
            throw error
        }
        
        let mention = Mention(context: context)
        mention.keyword = mentionInfo.keyword
        mention.query = query
        mention.count = 1
        return mention
    }
    
}

