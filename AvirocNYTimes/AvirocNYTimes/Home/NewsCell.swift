//
//  NewsCell.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 9/4/2022.
//

import UIKit
// MARK: NewsCell
class NewsCell: UITableViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var byLineLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var logo: NetworkImageView!
    
    //MARK: - Setters
    var data: News? {
        didSet {
            self.titleLabel.text = data?.title
            self.byLineLabel.text = data?.byline
            self.dateLabel.text = data?.publishedDate
            self.logo.cornerRadius = self.logo.frame.width / 2
            self.sourceLabel.text = data?.source
            if let logourl = data?.thumbnailUrl {
                self.logo.loadImageWithUrl(logourl)
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override func prepareForReuse() {
        self.logo.image = nil
    }
}
