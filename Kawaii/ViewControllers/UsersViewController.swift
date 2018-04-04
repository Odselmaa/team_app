//
//  UsersViewController.swift
//  Kawaii
//
//  Created by Odselmaa Dorjsuren on 4/2/18.
//  Copyright © 2018 Odselmaa Dorjsuren. All rights reserved.
//
import UIKit
import Hero

class UsersViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    let db = KawaiiDB.getInstance()
    var users = [User]()

    override func viewWillAppear(_ animated: Bool) {
        users = db.getUsers()
    }
    
    override func viewDidLoad() {
        addFirstUsers()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshList), name:NSNotification.Name(rawValue: "refresh_users"), object: nil)

    }
    
    // refresh tableview when new user info came
    @objc func refreshList(notification: NSNotification){
        users = db.getUsers()
        tableView.reloadData()
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "segue_user_show"){
            if let currentCell = sender as? UserCell,
               let vc = segue.destination as? CurrentUserController {
               vc.user = currentCell.user
            
            }
        }else if(segue.identifier == "segue_user_add"){
            if  let vc = segue.destination as? AddUserController {
                vc.update_needed = false
            }
        }
        
    }
    
    //When program starts first time, it inserts the team members' info
    func addFirstUsers(){
        let preferences = UserDefaults.standard
        let installed = "installed"
        if preferences.object(forKey: installed) == nil {
            let user_list = [
                User(firstname: "Odselmaa",
                     lastname: "Dorjsuren",
                     image: #imageLiteral(resourceName: "odko"),
                     group: "IU7I-47M",
                     desc: "\"Do or not, there is no try!\""),
                
                User(firstname: "Baasanbayar",
                     lastname: "Mendbayar",
                     image: #imageLiteral(resourceName: "baaska"),
                     group: "IU6I-31B",
                     desc: "\"She always quotes Yoda\""),
                ]
            
                for user in user_list{
                    _ = db.addUser(user: user)
                }
                preferences.set(true, forKey: installed)
        }
    }
}

extension UsersViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = (tableView.dequeueReusableCell(withIdentifier: "item", for: indexPath) as? UserCell)!
        cell.user = users[indexPath.item]
        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 180

    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if(editingStyle==UITableViewCellEditingStyle.delete){
            db.deleteUser(u_id: users[indexPath.row].id!)
            users.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)

        }
    }

//  func collectionView(_ collectionView: UITableView, layout collectionViewLayout: UITableViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//    return CGSize(width: view.bounds.width, height: view.bounds.height / CGFloat(cities.count))
//  }
}
