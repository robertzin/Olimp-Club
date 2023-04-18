//
//  DetailsViewController.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 20.03.2023.
//

import UIKit
import MapKit

final class DetailsViewController: UIViewController {
    
    @IBOutlet weak var exitButton: UIButton!
    @IBOutlet weak var bookingButton: UIButton!
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var webSiteTextView: UITextView!
    
    var annotation: MapLocation!
    var distance: Double!
    
    @IBAction func exitButtonAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func bookingButtonAction(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Booking", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "BookingVC")
        
        navigationController?.pushViewController(vc, animated: true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    private func setupUI() {
        locationImageView.corneredRadius(radius: 10)
        bookingButton.corneredRadius(radius: 14)
        
        webSiteTextView.textContainer.lineFragmentPadding = 0
        webSiteTextView.textContainerInset = .zero
        
        titleLabel.text = annotation.title
        addressLabel.text = annotation.locationName
        locationImageView.image = annotation.image
        descriptionLabel.text = annotation.info
        distanceLabel.text = "~ \(distance.parseToDistance())"
        
        if let wh = annotation.workingHours {
            self.workingHoursLabel.text = "\(wh.0) - \(wh.1)"
        } else { self.workingHoursLabel.text = "Не указано" }
        
        if let phoneNo = annotation.phone {
            self.phoneNumberLabel.text = phoneNo
        } else { self.phoneNumberLabel.text = "Не указано" }
        
        if let webSite = annotation.webSite {
            let attributedString = NSMutableAttributedString(string: webSite)
            attributedString.addAttribute(.link, value: webSite, range: NSRange(location: 0, length: webSite.count))
            webSiteTextView.attributedText = attributedString
        } else { self.webSiteTextView.text = "Не указано" }
    }
    
}

extension DetailsViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        UIApplication.shared.open(URL)
        return false
    }
}
