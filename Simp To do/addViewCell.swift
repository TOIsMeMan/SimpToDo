//
//  addViewCell.swift
//  Simp To do
//
//  Created by MacBook Pro on 28/09/2023.
//

import UIKit

protocol addViewCellDelegate {
    func AddTask()
}

class addViewCell: UITableViewCell {

    var delegate: addViewCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func AddTaskButton(_ sender: Any) {
        self.delegate?.AddTask()
    }
    
}
