//
//  InitViewController.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 14.03.2023.
//

import UIKit

class InitViewController: UIViewController {

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1)) {

            let storyboard = UIStoryboard(name: "Onboarding", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "Onboarding") as! OnboardingViewController
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.navigationController?.setViewControllers([vc], animated: true)
        }
    }

}
