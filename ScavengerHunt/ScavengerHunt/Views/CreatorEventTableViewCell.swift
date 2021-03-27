//
//  CreatorEventTableViewCell.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/27/21.
//

import UIKit

class CreatorEventTableViewCell: UITableViewCell {
    
    // MARK: - IBOutlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var finishLabel: UILabel!
    @IBOutlet weak var numberOfMarkersLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellView.layer.cornerRadius = 10
        cellView.layer.shadowColor = UIColor.black.cgColor
        cellView.layer.shadowOpacity = 0.3
        cellView.layer.shadowOffset = CGSize(width: 5, height: 5)
        cellView.layer.shadowRadius = 5
    }
    
}
