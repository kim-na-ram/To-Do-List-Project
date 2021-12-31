//
//  ViewController.swift
//  ToDoListProject
//
//  Created by 김나람 on 2021/12/31.
//

import UIKit

var list = [ToDoList]()

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var toDoListTableView: UITableView!
    @IBOutlet weak var editBarButton: UIBarButtonItem!
    
    let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneButtonTap))
    
    override func viewDidAppear(_ animated: Bool) {
        saveAllData()
        toDoListTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        toDoListTableView.delegate = self
        toDoListTableView.dataSource = self
        
        loadAllData()
        print(list.description)
        
        doneButton.style = .plain
        doneButton.target = self
        
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return list.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        cell.textLabel?.text = list[indexPath.row].title
        cell.detailTextLabel?.text = list[indexPath.row].content
        if list[indexPath.row].isComplete {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }

    @IBAction func editAction(_ sender: Any) {
        // list가 비어있을 때 return
        guard !list.isEmpty else {
            return
        }
        self.navigationItem.leftBarButtonItem = doneButton
        toDoListTableView.setEditing(true, animated: true)
    }
    
    @objc
    func doneButtonTap() {
        self.navigationItem.leftBarButtonItem = editBarButton
        toDoListTableView.setEditing(false, animated: true)
    }
    
    // 수정 모드
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        list.remove(at: indexPath.row)
        
        saveAllData()
        toDoListTableView.reloadData()
    }
    
    // 리스트 선택 시 완료된 일로 표시
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard !list[indexPath.row].isComplete else {
            return
        }
        
        list[indexPath.row].isComplete = true
        let item = list[indexPath.row]
        
        let dialog = UIAlertController(title: item.title, message: "\(item.content)을(를) 완료했습니다.", preferredStyle: .alert)
        let action = UIAlertAction(title: "확인", style: UIAlertAction.Style.default)
        dialog.addAction(action)
        self.present(dialog, animated: true, completion: nil)
        
        saveAllData()
        toDoListTableView.reloadData()
    }
    
    func saveAllData() {
        let data = list.map {
            [
                "title": $0.title,
                "content": $0.content!,
                "isComplete": $0.isComplete
            ]
        }
        
        let userDefaults = UserDefaults.standard
        userDefaults.set(data, forKey: "items")
        userDefaults.synchronize()
    }
    
    func loadAllData() {
        let userDefaults = UserDefaults.standard
        guard let data = userDefaults.object(forKey: "items") as? [[String: AnyObject]] else {
            return
        }
        
        print(type(of: data))
        list = data.map {
            var title = $0["title"] as? String
            var content = $0["content"] as? String
            var isComplete = $0["isComplete"] as? Bool
            
            return ToDoList(title: title!, content: content!, isComplete: isComplete!)
        }
        
    }
}