//
//  Tweet.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 18.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData
import TwitterKit

class Tweet: NSManagedObject {

    class func findOrCreateTweet(searchQuery query: String, matching twitterInfo: TweetStruct, in context: NSManagedObjectContext) throws -> Tweet {
        let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
        request.predicate = NSPredicate(format: "identifier = %@", twitterInfo.identifier)

        do {
            let matches = try context.fetch(request)
            if matches.count > 0 {
                return matches[0]
            }
        } catch {
            throw error
        }

        let tweet = Tweet(context: context)
        tweet.identifier = twitterInfo.identifier
        if let search = try? Search.findOrCreateSearch(matching: query, in: context) {
            tweet.addToSearches(search)
        }
        for mention in twitterInfo.userMentions {
            if let dbMention = try? Mention.findOrCreateMention(searchQuery: query, matching: mention, in: context) {
                tweet.addToMentions(dbMention)
            }
        }
        return tweet
    }
}


