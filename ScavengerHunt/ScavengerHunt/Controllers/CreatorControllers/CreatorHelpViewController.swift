//
//  CreatorHelpViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 4/29/21.
//

import UIKit

class CreatorHelpViewController: UIViewController {

    // MARK: - IBOutlets
    
    // MARK: - Properties
    var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        scrollView.frame = CGRect(x: 20, y: 150, width: view.frame.size.width-40, height: 2000)
        scrollView.contentSize = CGSize(width: view.frame.size.width-40, height: 2000)
        scrollView.backgroundColor = .gray
        scrollView.layer.cornerRadius = 10
        view.addSubview(scrollView)
        
//        """
//        Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
//
//        Minimum 40 bytes of memory.
//
//        Tags with adhesive are best when placing around!
//
//        Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
//
//
//        Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
//
//        Minimum 40 bytes of memory.
//
//        Tags with adhesive are best when placing around!
//
//        Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
//        """
    }
    
    // MARK: - Methods
    private func setupViews() {
    }

}
