//
//  HelpPageViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/10/21.
//

import UIKit

class HelpPageViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - Properties
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var button: UIButton!
    
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    
    var titles = ["Number 1", "Number 2", "Number 3"]
    
    // MARK: - Lifecycles
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: false)
        self.view.layoutIfNeeded()
        self.scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        
        setupScrollView()
        setupViews()
    }
    
    private func setupScrollView() {
        var frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        for index in 0..<titles.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            // subviews
            let text: UILabel = {
                let label = UILabel()
                label.frame = CGRect(x: 30, y: 100, width: scrollWidth-64, height: 30)
                label.textAlignment = .center
                label.text = titles[index]
                return label
            }()
            
            slide.addSubview(text)
            scrollView.addSubview(slide)
        }
        
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(titles.count), height: scrollHeight)
        self.scrollView.contentSize.height = 1.0
        
        pageControl.numberOfPages = titles.count
        pageControl.currentPage = 0
    }
    
    private func setupViews() {
        button.layer.cornerRadius = 20
    }

    @IBAction func pageChanged(_ sender: Any) {
        scrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(pageControl.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        navigationController?.popToRootViewController(animated: true)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView.contentOffset.x)/scrollWidth
        pageControl.currentPage = Int(page)
    }
    
}
