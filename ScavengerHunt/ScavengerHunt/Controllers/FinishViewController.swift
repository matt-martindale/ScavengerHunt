//
//  FinishViewController.swift
//  ScavengerHunt
//
//  Created by Matthew Martindale on 3/28/21.
//

import UIKit

class FinishViewController: UIViewController {
    
    // MARK: - IBOutlets
    @IBOutlet weak var congratsImageView: UIImageView!
    @IBOutlet weak var homeBtn: UIButton!
    
    
    let particleEmitter = CAEmitterLayer()
    
    // MARK: - Lifecycles
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        createParticles()
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - IBActions
    @IBAction func homeBtnTapped(_ sender: UIButton) {
        Utilites.shared.playSound(sender.tag)
        particleEmitter.emitterCells?.removeAll()
        navigationController?.popToRootViewController(animated: true)
    }
    
    // MARK: - Methods
    func setupViews() {
        homeBtn.layer.cornerRadius = 20
        homeBtn.layer.borderWidth = 2.0
        homeBtn.layer.borderColor = UIColor.orange.cgColor
    }
    
    func createParticles() {

        particleEmitter.emitterPosition = CGPoint(x: view.center.x, y: -20)
        particleEmitter.emitterShape = .line
        particleEmitter.emitterSize = CGSize(width: view.frame.size.width, height: 1)

        let blue = makeEmitterCell(color: #colorLiteral(red: 0.3694034219, green: 0.761762321, blue: 0.896699369, alpha: 1))
        let orange = makeEmitterCell(color: #colorLiteral(red: 1, green: 0.5419902205, blue: 0.2283754647, alpha: 1))
        let purple = makeEmitterCell(color: #colorLiteral(red: 0.5471776128, green: 0.3385567665, blue: 0.7818789482, alpha: 1))
        let yellow = makeEmitterCell(color: #colorLiteral(red: 0.9198206067, green: 0.8792296648, blue: 0.3015590906, alpha: 1))
        let red = makeEmitterCell(color: #colorLiteral(red: 0.8214911819, green: 0.2103256583, blue: 0.264827013, alpha: 1))

        particleEmitter.emitterCells = [blue, orange, purple, yellow, red]

        view.layer.addSublayer(particleEmitter)
    }

    func makeEmitterCell(color: UIColor) -> CAEmitterCell {
        let cell = CAEmitterCell()
        cell.birthRate = 3
        cell.lifetime = 7.0
        cell.lifetimeRange = 0
        cell.color = color.cgColor
        cell.velocity = 200
        cell.velocityRange = 50
        cell.emissionLongitude = CGFloat.pi
        cell.emissionRange = CGFloat.pi / 4
        cell.spin = 2
        cell.spinRange = 3
        cell.scaleRange = 0.5
        cell.scaleSpeed = -0.05
        

        cell.contents = UIImage(named: "confetti")?.cgImage
        return cell
    }
}
