//
//  HistoryCell.swift
//  CoreDataPractice(ToDo)
//
//  Created by Elexoft on 12/12/2024.
//

import UIKit

class HistoryCell: UITableViewCell {

    @IBOutlet weak var toDoTextLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
