//
//  TweetDataTableViewController.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 18.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import TwitterKit
import CoreData

class TweetDataTableViewController: TweetTableViewController {
    
    var container: NSPersistentContainer? =
        (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
    
    override func insertTweets(_ newTweets: [TweetStruct]) {
        super.insertTweets(newTweets);
        
        updateDatabase(with: newTweets)
    }
    
    private func updateDatabase(with newTweets: [TweetStruct]) {
        container?.performBackgroundTask  { [weak self] context in
            for twitterInfo in newTweets {
                if let query = self?.searchText {
                    _ = try? Tweet.findOrCreateTweet(searchQuery: query, matching: twitterInfo, in: context)
                }
            }
            try? context.save()
            self?.printDatabaseStatistics()
        }
    }
    
    private func printDatabaseStatistics() {
        if let context = container?.viewContext {
            context.perform {
                let request: NSFetchRequest<Tweet> = Tweet.fetchRequest()
                if let tweetCount = (try? context.count(for: request)) {
                    print ("\(tweetCount) tweets")
                }
                if let searchCount = (try? context.count(for: Search.fetchRequest())) {
                    print ("\(searchCount) searches")
                }
                if let mentionCount = (try? context.count(for:
                    Mention.fetchRequest())) {
                    print ("\(mentionCount) mentions")
                }
            }
        }
    }
}

