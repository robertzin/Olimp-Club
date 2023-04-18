//
//  InfoView.swift
//  SportLocator
//
//  Created by Robert Zinyatullin on 08.03.2023.
//

import UIKit
import MapKit

class InfoView: UIView {

    @IBOutlet weak var whiteBackgroundView: UIView!
    @IBOutlet weak var locationImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var workingHoursLabel: UILabel!
    @IBOutlet weak var distanceLabel: UILabel!
    
    @IBOutlet weak var detailsLabelButton: UILabel!
    @IBOutlet weak var makeRouteButton: UIButton!
    
    @IBAction func makeRouteButtonAction(_ sender: Any) {
        guard let annotation = self.annotation else { return }
        buttonDelegate?.makeRouteButtonClicked(annotation: annotation)
    }
    
    var buttonDelegate:  InfoViewButtonsDelegate?
    var annotation: MKAnnotation?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
        setupUI()
    }
    
    private func commonInit() {
        let viewFromNib = Bundle.main.loadNibNamed("InfoView", owner: self)?.first as! UIView
        viewFromNib.frame = self.bounds
        addSubview(viewFromNib)
    }
    
    private func setupUI() {
        let underlineAttribute = [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.thick.rawValue]
        let underlineAttributedString = NSAttributedString(string: "Подробнее", attributes: underlineAttribute)
        detailsLabelButton.attributedText = underlineAttributedString
        let tap = UITapGestureRecognizer(target: self, action: #selector(detailsButtonOnTap))
        detailsLabelButton.addGestureRecognizer(tap)
    }
    
    func configure(annotation: MapLocation, distance: Double, completion: @escaping(() -> ())) -> Void {
        self.annotation = annotation
        
        whiteBackgroundView.corneredRadius(radius: 10)
        locationImageView.corneredRadius(radius: 10)
        
        self.titleLabel.text = annotation.title
        self.addressLabel.text = annotation.locationName
        
        if let wh = annotation.workingHours { self.workingHoursLabel.text = "\(wh.0) - \(wh.1)" }
        else { self.workingHoursLabel.text = "Не указано" }
        
        self.distanceLabel.text = "~ \(distance.parseToDistance())"
        self.locationImageView.image = annotation.image
        
        completion()
    }

    @objc private func detailsButtonOnTap() {
        guard let annotation = self.annotation else { return }
        buttonDelegate?.detailsButtonClicked(annotation: annotation)
    }
}
