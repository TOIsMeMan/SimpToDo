//
//  simpTableViewCell.swift
//  Simp To do
//
//  Created by MacBook Pro on 28/09/2023.
//

import UIKit

protocol simpCellDelegate: AnyObject {
    func doneDidChange(done: Bool, indexPath: Int)
    func textFieldDidChange(textField: UITextField, indexPath: Int)
    func PassTaskTitle(text: String, indexPath: Int)
    func STasks()
}

class simpTableViewCell: UITableViewCell {
    
    var delegate: simpCellDelegate?
    var indexPath: Int = 0
    var tableView: UITableView?
    @IBOutlet weak var tickButton: UIButton!
    @IBOutlet weak var taskTextField: UITextField! {
        didSet {
            self.delegate?.textFieldDidChange(textField: taskTextField, indexPath: indexPath)
        }
    }
    
    var done: Bool = false {
        didSet {
            self.delegate?.doneDidChange(done: done, indexPath: indexPath)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.taskTextField.returnKeyType = .done
        self.taskTextField.delegate = self
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func tappedTick(_ sender: Any) {
        
        if (done == false) {
            let imageTick = UIImage(named: "tickOn")
            tickButton.setImage(imageTick, for: .normal)
            
            let attributedString = NSMutableAttributedString(string: taskTextField.text ?? "")
                   
            attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
            
            taskTextField.attributedText = attributedString
            
            done = true
        } else {
            let imageTick = UIImage(named: "tickOff")
            tickButton.setImage(imageTick, for: .normal)
            if let attributedText = taskTextField.attributedText {
                        let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                        

                        mutableAttributedText.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: mutableAttributedText.length))
                        
                        // Assign the updated attributed text to the UITextField
                        taskTextField.attributedText = mutableAttributedText
                done = false
                    }
        }
    }
}

extension simpTableViewCell: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        self.delegate?.PassTaskTitle(text: textField.text ?? "", indexPath: indexPath)
        self.delegate?.STasks()
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        self.delegate?.PassTaskTitle(text: textField.text ?? "", indexPath: indexPath)
        self.delegate?.STasks()
        textField.resignFirstResponder()
    }
}
