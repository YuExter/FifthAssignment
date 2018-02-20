//
//  RecentQueriesTableViewController.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class RecentQueriesTableViewController: UITableViewController {
    
    var recentQueries = {
        RecentQueries.getQuery()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentQueries().count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recentQueryCell", for: indexPath) as? RecentQueryTableViewCell else {
            return UITableViewCell()
        }
        cell.recentQuery = self.recentQueries()[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard
                let cell = tableView.cellForRow(at: indexPath) as? RecentQueryTableViewCell,
                let query = cell.recentQuery else { return }
            tableView.beginUpdates()
            RecentQueries.remove(query: query)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.endUpdates()
        }
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        performSegue(withIdentifier: SegueIds.doShowPopUsers, sender: cell)
    }
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == SegueIds.doShowTweets {
            guard
                let tweetTable = segue.destination as? TweetTableViewController,
                let recentQueryCell = sender as? RecentQueryTableViewCell,
                let recentQuery = recentQueryCell.recentQuery else {
                    assertionFailure()
                    return
            }
            tweetTable.searchText = recentQuery
        } else if segue.identifier == SegueIds.doShowPopUsers {
            guard
                let searchMentionCounterTVC = segue.destination as? SearchMentionCounterTableViewController,
                let recentQueryCell = sender as? RecentQueryTableViewCell,
                let recentQuery = recentQueryCell.recentQuery else {
                    assertionFailure()
                    return()
            }
            searchMentionCounterTVC.searchQuery = recentQuery
            searchMentionCounterTVC.container = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer
        }
    }
}

extension RecentQueriesTableViewController
{
    fileprivate struct SegueIds {
        static let doShowPopUsers = "doShowPopUsers"
        static let doShowTweets = "doShowTweets"
    }
}


