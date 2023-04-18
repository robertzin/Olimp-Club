//
//  OnboardingViewController.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 14.03.2023.
//

import UIKit

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var continueButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func setupUI() {
        continueButton.corneredRadius(radius: 14)
//        navigationController?.isNavigationBarHidden = true
    }
    
    @IBAction func continueButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Map", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "Map") as! MapViewController
        self.navigationController?.setViewControllers([vc], animated: true)
    }
}
