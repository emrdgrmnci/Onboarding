//
//  TutorialViewModel.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 9.05.2023.
//

import Foundation
import Combine
import UIKit.UIImage

final class TutorialViewModel {

    let images = CurrentValueSubject<[Onboarding], Never>([
        Onboarding(color: UIColor(named: "black")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "purple")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "yellow")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "cyan")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "red")!, title: "Lorem ipsum dolor set amet"),
        Onboarding(color: UIColor(named: "green")!, title: "Lorem ipsum dolor set amet"),
    ])

    func didTapClose() {}
}
