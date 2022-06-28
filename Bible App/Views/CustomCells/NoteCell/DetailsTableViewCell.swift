//
//  DetailsTableViewCell.swift
//  RowInsideTableViewCellDemo
//
//  Created by webwerk on 14/07/21.
//

import UIKit

class DetailsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var noteTitle: UILabel!
    
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
