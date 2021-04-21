//
//  HelpPageViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/10/21.
//

import UIKit

class HelpPageViewController: UIViewController, UIScrollViewDelegate {

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var button: UIButton!
    
    // MARK: - Properties
    var scrollWidth: CGFloat = 0.0
    var scrollHeight: CGFloat = 0.0
    var images = ["step1", "step2"]
    
    // MARK: - Lifecycles
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollWidth = scrollView.frame.size.width
        scrollHeight = scrollView.frame.size.height
        navigationController?.isNavigationBarHidden = true
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

    // MARK: - IBActions
    @IBAction func pageChanged(_ sender: Any) {
        scrollView.scrollRectToVisible(CGRect(x: scrollWidth * CGFloat(pageControl.currentPage), y: 0, width: scrollWidth, height: scrollHeight), animated: true)
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    private func setupScrollView() {
        var frame = CGRect(x: 0.0, y: 0.0, width: 0.0, height: 0.0)
        for index in 0..<images.count {
            frame.origin.x = scrollWidth * CGFloat(index)
            frame.size = CGSize(width: scrollWidth, height: scrollHeight)
            
            let slide = UIView(frame: frame)
            
            //subviews
            let imageView = UIImageView.init(image: UIImage.init(named: images[index]))
            imageView.frame = CGRect(x: 0, y: 0, width: 300, height: 500)
            imageView.contentMode = .scaleAspectFit
            imageView.center = CGPoint(x: scrollWidth/2, y: scrollHeight/2)
            
            slide.addSubview(imageView)
            scrollView.addSubview(slide)
        }
        
        scrollView.contentSize = CGSize(width: scrollWidth * CGFloat(images.count), height: scrollHeight)
        self.scrollView.contentSize.height = 1.0
        
        pageControl.numberOfPages = images.count
        pageControl.currentPage = 0
    }
    
    private func setupViews() {
        button.layer.cornerRadius = 20
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        setIndicatorForCurrentPage()
    }
    
    func setIndicatorForCurrentPage() {
        let page = (scrollView.contentOffset.x)/scrollWidth
        pageControl.currentPage = Int(page)
    }
    
}
