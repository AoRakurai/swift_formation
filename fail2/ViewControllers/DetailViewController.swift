//
//  DetailViewController.swift
//  fail2
//
//  Created by Guillaume Malo on 2018-07-20.
//  Copyright © 2018 Guillaume Malo. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var detailNameLabel: UILabel!
    @IBOutlet weak var detailIconImage: UIImageView!
    @IBOutlet weak var detailLoreLabel: UILabel!

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            if let label = detailNameLabel {
                label.text = detail.name + " " + detail.title
            }
            if let label = detailLoreLabel {
                label.text = detail.lore
            }
            if let image = detailIconImage {
                image.image = detail.image
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    var detailItem: Champion? {
        didSet {
            // Update the view.
            configureView()
        }
    }


}

