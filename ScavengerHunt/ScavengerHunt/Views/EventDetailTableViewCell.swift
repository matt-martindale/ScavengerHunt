//
//  EventDetailTableViewCell.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/6/21.
//

import UIKit

class EventDetailTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    @IBOutlet weak var nextLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cellView.layer.shadowRadius = 5
    }

}
