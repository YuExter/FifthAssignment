//
//  MentionKeywordTableViewCell.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class MentionKeywordTableViewCell: UITableViewCell {
    
    @IBOutlet fileprivate var keyWordLabel: UILabel!
    
    var label: String? {
        didSet {
            self.keyWordLabel.text = label
        }
    }
    
}
