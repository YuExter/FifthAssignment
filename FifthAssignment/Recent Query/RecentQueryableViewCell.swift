//
//  RecentQueryableViewCell.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class RecentQueryTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate var recentQueryLabel: UILabel!
    
    var recentQuery: String? {
        didSet {
            self.update()
        }
    }
    
    private func update() {
        self.recentQueryLabel.text = recentQuery ?? ""
    }
}
