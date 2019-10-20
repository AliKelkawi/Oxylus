//
//  FireView.swift
//  FireWatch2.0
//
//  Created by Abdalwahab on 10/18/19.
//  Copyright © 2019 team. All rights reserved.
//

import UIKit

class FireView: UIView {

    @IBOutlet var contentView: UIView!
    
    @IBOutlet var firename: UILabel!
    @IBOutlet var area: UILabel!
    @IBOutlet var contain: UILabel!
    @IBOutlet var date: UILabel!
    @IBOutlet var cause: UILabel!
    @IBOutlet var lastUpdate: UILabel!
    @IBOutlet var image: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("FireView", owner: self, options: nil)
        contentView.frame.size.width = frame.size.width
        addSubview(contentView)
    }
    
    func setData(fire: Fire) {
        self.firename.text = fire.title
        self.lastUpdate.text = fire.lastUpdated
        self.date.text = fire.DateofOrigin // -mark: issue: you see the duplicate?
        self.area.text = "\(fire.size) acres"
        self.cause.text = fire.cause
        self.contain.text = fire.contained
        
        if fire.image != nil {
            print(fire.image)
            
            guard let url = URL(string: fire.image!) else {
                return
            }
            
            print("pass")
            
            URLSession.shared.dataTask(with: url, completionHandler: { (data, res, err) in
                if err != nil {
                    print(err)
                    return
                }
                
                DispatchQueue.main.async {
                    let iToC = UIImage(data: data!)
                    self.image.image = iToC
                }
            })
        }
    }

}
