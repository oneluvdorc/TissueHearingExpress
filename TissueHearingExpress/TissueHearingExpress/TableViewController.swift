//
//  TableViewController.swift
//  TissueHearingExpress
//
//  Created by Jenny Wu on 10/7/18.
//  Copyright © 2018 Jenny Wu. All rights reserved.
//

import UIKit

class TableViewController: UITableViewController {
    var usersLi = Array<User>()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "我的檢測紀錄"
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        let defaults = UserDefaults.standard
        if let savedUsers = defaults.object(forKey: "users") as? Data {
            let jsonDecoder = JSONDecoder()
            do {
                usersLi = try jsonDecoder.decode([User].self, from: savedUsers)
            } catch {
                print("Failed to load users")
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return usersLi.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let name = usersLi[indexPath.row].getName()
        let time = usersLi[indexPath.row].getTime()
        cell.textLabel?.text = "\(name) (時間：\(time))"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let type = usersLi[indexPath.row].getType()
        if type == 0 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Final") as? FinalViewController
            vc?.selectedUser = usersLi[indexPath.row]
            navigationController?.pushViewController(vc!, animated: true)
        } else if type == 1 {
            let vc = storyboard?.instantiateViewController(withIdentifier: "Detail") as? DetailViewController
            vc?.selectedUser = usersLi[indexPath.row]
            vc?.selectedIndex = indexPath.row
            navigationController?.pushViewController(vc!, animated: true)
        }
    }

    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            let ac = UIAlertController(title: "警告", message: "確認刪除？",preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "取消", style: .cancel))
            ac.addAction(UIAlertAction(title: "刪除", style: .default) {[unowned self] _ in
                self.usersLi.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
                self.save()
            })
            present(ac, animated: true)
        }
    }
    
    func save() {
        let jsonEncoder = JSONEncoder()
        if let savedData = try? jsonEncoder.encode(usersLi) {
            let defaults = UserDefaults.standard
            defaults.set(savedData, forKey: "users")
        } else {
            print("Failed to save users")
        }
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
