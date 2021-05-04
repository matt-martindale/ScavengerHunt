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
    let scrollView = UIScrollView()
    let contentView = UIView()
    
    let label: UILabel = {
        let label = UILabel()
        label.text =
                    """
                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
                    
                    
                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.

                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
                    
                    
                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.

                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
                    
                    
                    Works with any rewritable NDEF NFC tags type 1-5, or any that are compatible with “Amiibos”.
                    
                    Minimum 40 bytes of memory.
                    
                    Tags with adhesive are best when placing around!
                    
                    Avoid placing tags on metal surfaces, metal interferes with the scanning capabilities.
                    """
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScrollView()
        setupViews()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
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
    private func setupScrollView() {
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        scrollView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        scrollView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 150).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        scrollView.contentSize = CGSize(width: view.frame.size.width, height: 2000)
        
        contentView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        contentView.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
    }

    private func setupViews() {
        contentView.addSubview(label)
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
    }
    
}
