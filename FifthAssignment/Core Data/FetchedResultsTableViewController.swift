//
//  FetchedResultsTableViewController.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 18.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit
import CoreData

class FetchedResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate
{
    public func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert: self.tableView.insertSections([sectionIndex], with: .fade)
        case .delete: self.tableView.deleteSections([sectionIndex], with: .fade)
        default: break
        }
    }
    
    public func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        guard let path = newIndexPath else { return }
        switch type {
        case .insert:
            self.tableView.insertRows(at: [path], with: .fade)
        case .delete:
            self.tableView.deleteRows(at: [path], with: .fade)
        case .update:
            self.tableView.reloadRows(at: [path], with: .fade)
        case .move:
            self.tableView.deleteRows(at: [path], with: .fade)
            self.tableView.insertRows(at: [path], with: .fade)
        }
    }
    
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.endUpdates()
        let tweet: Tweet = Tweet()
    }
}

