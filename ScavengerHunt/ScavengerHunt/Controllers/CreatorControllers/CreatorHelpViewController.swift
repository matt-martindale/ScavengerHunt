//
//  CreatorHelpViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/29/21.
//

import UIKit

class CreatorHelpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    private func setupViews() {
        scrollView.layer.cornerRadius = 10
    }

}
