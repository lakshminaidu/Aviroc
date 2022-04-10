//
//  NewsDetailController.swift
//  AvirocNYTimes
//
//  Created by Lakshminaidu on 9/4/2022.
//

import UIKit

class NewsDetailController: BaseViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var abstarctLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sourceLabel: UILabel!
    @IBOutlet weak var byLineLabel: UILabel!
    @IBOutlet weak var logo: NetworkImageView!
    
    //MARK: - Setters
    var seletedNews: News?

    override func viewDidLoad() {
        super.viewDidLoad()
        titleLabel?.text = seletedNews?.title
        abstarctLabel?.text = seletedNews?.abstract
        dateLabel?.text = seletedNews?.publishedDate
        sourceLabel?.text = seletedNews?.source
        byLineLabel.text = seletedNews?.byline
        if let logourl = seletedNews?.largeUrl {
            logo?.loadImageWithUrl(logourl)
        } else {
            logo.isHidden = true
        }
        
        // Do any additional setup after loading the view.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
