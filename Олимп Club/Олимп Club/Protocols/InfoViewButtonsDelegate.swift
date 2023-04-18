//
//  InfoViewButtonsDelegate.swift
//  Олимп Club
//
//  Created by Robert Zinyatullin on 13.03.2023.
//

import Foundation
import MapKit

protocol InfoViewButtonsDelegate {
    func makeRouteButtonClicked(annotation: MKAnnotation)
    func detailsButtonClicked(annotation: MKAnnotation)
}
