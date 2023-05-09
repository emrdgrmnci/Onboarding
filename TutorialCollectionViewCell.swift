//
//  TutorialCollectionViewCell.swift
//  Tutorial
//
//  Created by Degirmenci Emre on 27.04.2023.
//

import UIKit

class TutorialCollectionViewCell: UICollectionViewCell {

    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var subtitleLabel: UILabel!
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        layer.cornerRadius = 8
    }

    func set(item: Onboarding)
    {
        titleLabel.text = item.title
        subtitleLabel.text = "Lorem ipsum dolor set amet, consectetuer Lorem ipsum dolor set amet, consectetuer"
        imageView.backgroundColor = item.color
    }
}
