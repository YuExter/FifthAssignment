//
//  TweetTableViewCell.swift
//  FifthAssignment
//
//  Created by Юля Пономарева on 20.02.2018.
//  Copyright © 2018 Юля Пономарева. All rights reserved.
//

import UIKit

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet fileprivate var profileImageView: UIImageView!
    @IBOutlet fileprivate var createdLabel: UILabel!
    @IBOutlet fileprivate var userLabel: UILabel!
    @IBOutlet fileprivate var textTweetLabel: UILabel!
    
    var tweet: TweetStruct? {
        didSet {
            self.update()
        }
    }
    
    fileprivate func update() {
        if let tweet = self.tweet {
            self.textTweetLabel?.attributedText = getColorizedTextLabel(tweet: tweet)
        }
        self.userLabel?.text = self.tweet?.user.description ?? ""
        
        if let profileImageURL = self.tweet?.user.profileImageURL {
            DispatchQueue.global(qos: .userInitiated).async { [weak self] in
                if let imageData = try? Data(contentsOf: profileImageURL) {
                    DispatchQueue.main.async {
                        self?.profileImageView?.image = UIImage(data: imageData)
                    }
                }
            }
        } else {
            self.profileImageView?.image = nil
        }
        
        if let created = self.tweet?.created {
            let formatter = DateFormatter()
            if Date().timeIntervalSince(created) > 24*60*60 {
                formatter.dateStyle = .short
            } else {
                formatter.timeStyle = .short
            }
            self.createdLabel?.text = formatter.string(from: created)
        } else {
            self.createdLabel?.text = nil
        }
    }
    
    private func getColorizedTextLabel(tweet: TweetStruct) -> NSAttributedString {
        let text = NSMutableAttributedString(string: tweet.text)
        text.setMentionColor(mentions: tweet.hashtags, color: Colors.hastag)
        text.setMentionColor(mentions: tweet.userMentions, color: Colors.user)
        text.setMentionColor(mentions: tweet.urls, color: Colors.url)
        return text
    }
}

private extension NSMutableAttributedString {
    func setMentionColor(mentions: [TweetMention], color: UIColor) {
        for mention in mentions {
            self.addAttribute(NSAttributedStringKey.foregroundColor, value: color, range: mention.nsrange)
        }
    }
}

fileprivate struct Colors {
    static let hastag = UIColor.blue
    static let user = UIColor.green
    static let url = UIColor.brown
}

