//
//  TweetTableViewController.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class TweetTableViewController: UITableViewController, UITextFieldDelegate
{
    fileprivate var tweets = [Array<TweetStruct>]()
    fileprivate var lastTwitterRequest: Request?

    var searchText: String? {
        didSet {
            self.searchTextField?.text = self.searchText
            self.searchTextField?.resignFirstResponder()
            self.lastTwitterRequest = nil
            self.tweets.removeAll()
            self.tableView.reloadData()
            self.searchForTweets()
            self.title = searchText
            
            if let query = self.searchText {
                RecentQueries.add(query: query)
            }
        }
    }
    
    @IBOutlet fileprivate var searchTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.estimatedRowHeight = tableView.rowHeight
        self.tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    func insertTweets(_ newTweets: [TweetStruct]) {
        self.tweets.insert(newTweets, at:0)
        self.tableView.insertSections([0], with: .fade)
    }
    
    fileprivate func twitterRequest() -> Request? {
        if var query = self.searchText, !query.isEmpty {
            if query.hasPrefix("@") {
                query.remove(at: query.startIndex)
                query = "from: \(query) OR @\(query)"
            }
            return Request(search: query, count: 100)
        }
        return nil
    }
    
    
    
    fileprivate func searchForTweets() {
        if let request = self.lastTwitterRequest?.newer ?? self.twitterRequest() {
            self.lastTwitterRequest = request
            request.fetchTweets { [weak self] newTweets in
                DispatchQueue.main.async {
                    if request == self?.lastTwitterRequest {
                        self?.insertTweets(newTweets)
                    }
                    self?.refreshControl?.endRefreshing()
                }
            }
        } else {
            self.refreshControl?.endRefreshing()
        }
    }
    
    @IBAction fileprivate func refresh(_ sender: UIRefreshControl) {
        self.searchForTweets()
    }
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.searchTextField {
            self.searchText = searchTextField.text
        }
        return true
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.tweets.count
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets[section].count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "tweetCell", for: indexPath) as? TweetTableViewCell else { return UITableViewCell() }
        let tweet: TweetStruct = self.tweets[indexPath.section][indexPath.row]
        cell.tweet = tweet
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "\(self.tweets.count-section)"
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.showTweetDetailed {
            guard
                let vc = segue.destination as? MentionTableViewController,
                let cell = sender as? TweetTableViewCell else {
                    assertionFailure()
                    return
            }
            let tweet = cell.tweet
            vc.tweet = tweet
        }
    }
}

extension TweetTableViewController
{
    fileprivate struct SegueIds {
        static let showTweetDetailed = "showTweetDetailed"
    }
}


