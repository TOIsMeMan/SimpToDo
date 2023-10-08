//
//  ViewController.swift
//  Simp To do
//
//  Created by MacBook Pro on 28/09/2023.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, simpCellDelegate, addViewCellDelegate, UITableViewDragDelegate, UITableViewDropDelegate {
    func tableView(_ tableView: UITableView, itemsForBeginning session: UIDragSession, at indexPath: IndexPath) -> [UIDragItem] {
        let task = tasks[indexPath.row]
        let itemProvider = NSItemProvider(object: task.title as NSItemProviderWriting)
        let dragItem = UIDragItem(itemProvider: itemProvider)
        dragItem.localObject = task
        return [dragItem]
    }
    
    func tableView(_ tableView: UITableView, performDropWith coordinator: UITableViewDropCoordinator) {
        print("o")
    }
    var i = 1
    @IBOutlet weak var CSHTButtonIU: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    var tasks: [task] = []
    var simpViewCellDone: Bool = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        LoadTasks()
        tableView.reloadData()
        
        tableView.dragInteractionEnabled = true
        
        tableView.dragDelegate = self
        tableView.dropDelegate = self
    }

    func STasks() {
        SaveTask()
    }
    
    func AddTask() {
        let newTask = task(done: false, title: "")
        tasks.append(newTask)
        tableView.reloadData()
    }
    
    func PassTaskTitle(text: String, indexPath: Int) {
        tasks[indexPath].title = text
    }
    
//    @IBAction func addTask(_ sender: Any) {
//        let newTask = task(done: false, title: "o")
//        for i in tasks {
//            print("o\(i.title)   \n")
//        }
//        tasks.append(newTask)
//        tableView.reloadData()
//    }
    
    
//MARK: TableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count + i
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if (indexPath.row != tasks.count) {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! simpTableViewCell
            cell.taskTextField.text = tasks[indexPath.row].title
            cell.delegate = self
            cell.indexPath = indexPath.row
            if (tasks[indexPath.row].done == true)
            {
                let imageTick = UIImage(named: "tickOn")
                cell.tickButton.setImage(imageTick, for: .normal)
                
                let attributedString = NSMutableAttributedString(string: tasks[indexPath.row].title ?? "")
                
                attributedString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: NSUnderlineStyle.single.rawValue, range: NSRange(location: 0, length: attributedString.length))
                
                cell.taskTextField.attributedText = attributedString
                
                cell.done = true
            } else {
                let imageTick = UIImage(named: "tickOff")
                cell.tickButton.setImage(imageTick, for: .normal)
                if let attributedText = cell.taskTextField.attributedText {
                    let mutableAttributedText = NSMutableAttributedString(attributedString: attributedText)
                    
                    
                    mutableAttributedText.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSRange(location: 0, length: mutableAttributedText.length))
                    
                    // Assign the updated attributed text to the UITextField
                    cell.taskTextField.attributedText = mutableAttributedText
                    cell.done = false
                }
            }
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "addCell", for: indexPath) as! addViewCell
            cell.delegate = self
            return cell
        }
    }
    
//MARK: func
    
    @IBAction func deleteTasks(_ sender: Any) {
        tasks.removeAll()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }

    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "Xoá"
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tasks.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        tasks.swapAt(sourceIndexPath.row, destinationIndexPath.row)
    }
    
    @IBAction func CSHTButton(_ sender: Any) {
        if tableView.isEditing {
            i = 1
            tableView.reloadData()
            tableView.isEditing = false
            CSHTButtonIU.title = "Chỉnh sửa"
            SaveTask()
        } else {
            tableView.isEditing = true
            i = 0
            tableView.reloadData()
            CSHTButtonIU.title = "Hoàn Thành Đi"
        }
    }
    
    func taskCell(_ cell: simpTableViewCell, didChangeDoneValue done: Bool) {
        simpViewCellDone = done
    }
    
    func doneDidChange(done: Bool, indexPath: Int) {
        tasks[indexPath].done = done
    }
    
    func textFieldDidChange(textField: UITextField, indexPath: Int) {
        tasks[indexPath].title = textField.text ?? ""
    }
    
    func SaveTask() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "Tasks")
        }
    }
    
    func LoadTasks() {
        if let data = UserDefaults.standard.data(forKey: "Tasks") {
            let decoder = JSONDecoder()
            if let decode = try? decoder.decode([task].self, from: data) {
                tasks = decode
                self.tableView.reloadData()
            }
        }
    }
    
}



        /*
//         1. tao model task?
//         2. => nen co ID => de minh delete va update va insert dua tren id do.
//         ID timestamp
//         3. update tasks theo thoi gian thuc (luc minh chay app, print ra task moi lan minh update, delete, insert)
//         4. NSUserDefault -> luu array vao nsuserdefault
//         5. load array tu user default
//         */
