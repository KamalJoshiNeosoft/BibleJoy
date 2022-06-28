//
//  NotesTableViewCell.swift
//  Bible App
//
//  Created by webwerks on 17/01/21.
//  Copyright © 2021 webwerks. All rights reserved.
//

import UIKit

class NotesTableViewCell: UITableViewCell {
    
    // MARK:- IBOutlets
    @IBOutlet weak var bookTitleLbl: UILabel!
    @IBOutlet weak var bookDescLbl: UILabel!
    @IBOutlet weak var notesDescLbl: UILabel!
    
    var onDeleteClick: (() -> ())?
     
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func deleteButtonClick(_ sender: UIButton) {
        onDeleteClick?()
    }
    
     
    
}
