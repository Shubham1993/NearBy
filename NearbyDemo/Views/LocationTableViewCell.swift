//
//  TableViewCell.swift
//  nearbyDemo
//
//  Created by shubham gupta on 11/05/24.
//

import Foundation
import UIKit

final class TableViewCell: UITableViewCell{
    
    @IBOutlet weak var titleLbl: UILabel!
    
    @IBOutlet weak var subtitleLbl: UILabel!
    
    @IBOutlet weak var iconImageView: UIImageView!
    
    func configure( model: Venues ){
        
        titleLbl.text = model.name
        subtitleLbl.text = model.nameV2
    }
    
}
