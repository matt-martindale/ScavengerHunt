//
//  MarkerDetailViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/28/21.
//

import UIKit

class MarkerDetailViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var clueLabel: UILabel!
    
    // MARK: - Properties
    var marker: Marker?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        guard let marker = marker else { return }
        titleLabel.text = marker.title
        clueLabel.text = marker.clue
    }

}
