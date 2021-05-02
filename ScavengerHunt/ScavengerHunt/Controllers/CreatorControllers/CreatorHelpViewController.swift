//
//  CreatorHelpViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/29/21.
//

import UIKit

class CreatorHelpViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var nfcTagSpecsLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        nfcTagSpecsLabel.text = """
        Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.

        Minimum 40 bytes of memory.

        Tags with adhesive are best when placing around!

        Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
        """
    }
    
    private func setupViews() {
        scrollView.layer.cornerRadius = 10
    }

}
