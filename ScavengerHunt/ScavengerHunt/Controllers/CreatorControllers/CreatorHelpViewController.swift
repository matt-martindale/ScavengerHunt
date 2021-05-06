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
    
    let introLabel: UILabel = {
        let label = UILabel()
        label.text = "To create a Treasure Hunt, all you’ll need are NFC tags and this app!"
        label.font = UIFont(name: "Avenir Next", size: 16)
        label.numberOfLines = 0
        label.sizeToFit()
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nfcTagSpecsTitle: UILabel = {
        let label = UILabel()
        label.text = "NFC TAG SPECS"
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let nfcTagSpecsLabel: UILabel = {
        let label = UILabel()
        label.text = """
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
    
    let minimumReqTitle: UILabel = {
        let label = UILabel()
        label.text = "MINIMUM REQUIREMENTS"
        label.font = UIFont(name: "Avenir Next", size: 18)
        label.font = UIFont.systemFont(ofSize: 18, weight: .medium)
        label.numberOfLines = 0
        label.textAlignment = .center
        label.sizeToFit()
        label.textColor = .orange
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let minimumReqLabel: UILabel = {
        let label = UILabel()
        label.text = """
                        To scan NFC tags and play the game: iPhone 7 and iOS 11 or newer.

                        To write NFC tags and create Treasure Hunts: iPhone 7 and iOS 13 or newer.
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
        // Intro label
        contentView.addSubview(introLabel)
        introLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        introLabel.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        introLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        // NFC Tag specs labels
        contentView.addSubview(nfcTagSpecsTitle)
        nfcTagSpecsTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nfcTagSpecsTitle.topAnchor.constraint(equalTo: introLabel.bottomAnchor, constant: 30).isActive = true
        nfcTagSpecsTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(nfcTagSpecsLabel)
        nfcTagSpecsLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        nfcTagSpecsLabel.topAnchor.constraint(equalTo: nfcTagSpecsTitle.bottomAnchor, constant: 12).isActive = true
        nfcTagSpecsLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        // Minimum Req labels
        contentView.addSubview(minimumReqTitle)
        minimumReqTitle.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        minimumReqTitle.topAnchor.constraint(equalTo: nfcTagSpecsLabel.bottomAnchor, constant: 30).isActive = true
        minimumReqTitle.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
        
        contentView.addSubview(minimumReqLabel)
        minimumReqLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        minimumReqLabel.topAnchor.constraint(equalTo: minimumReqTitle.bottomAnchor, constant: 12).isActive = true
        minimumReqLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 3/4).isActive = true
    }
    
}
