//
//  ClipboardTableViewController.swift
//  Clipboard
//
//  Created by Jonathan Yataco  on 5/24/20.
//  Copyright © 2020 JonYataco. All rights reserved.
//

import UIKit
import Foundation

class ClipboardTableViewController: UITableViewController {
    var items: [Clip] = [Clip(title: "Reinforcement Learning Reference", link: URL(string: "www.google.com")!.absoluteString), Clip(title: "COD Plays", link: URL(string: "www.youtube.com")!.absoluteString)]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.tableFooterView = UIView()
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
//        for _ in 1...10 {
//            items.append(Clip(title: "Reinforcement Learning Reference", link: URL(string: "www.google.com")!.absoluteString))
//        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipCell", for: indexPath) as! ClipCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.linkLabel.text = items[indexPath.row].link
        cell.faviconImage.image = UIImage(named: "default_favicon")
        
        let faviconURLString = "https://s2.googleusercontent.com/s2/favicons?domain_url=" + items[indexPath.row].link
        if let url = URL(string: faviconURLString) {
            let task = URLSession.shared.dataTask(with: URL(string: faviconURLString)!, completionHandler: { (data, response, error) in
                guard let data = data, let image = UIImage(data: data) else { return }
                DispatchQueue.main.async {
                    cell.faviconImage.image = image
                }
            })
            task.resume()
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let pasteboard = UIPasteboard.general
        pasteboard.string = items[indexPath.row].link
        createPopUp()
    }
    
    @IBAction func unwindToClipboard(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddItemViewController
        
        if let clip = sourceViewController.clip {
            let newIndexPath = IndexPath(row: items.count, section: 0)
            items.append(clip)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func createPopUp() {
        let appView = UIApplication.shared.keyWindow?.bounds
        print(appView)
    
        let popupView = UIView(frame: CGRect(x: 0, y: 0, width: 100, height: 50))
        popupView.backgroundColor = .red
        popupView.center = self.view.center
        popupView.alpha = 0
        UIView.animate(withDuration: 0.4, animations: {
            self.view.addSubview(popupView)
            popupView.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.4, animations: {
                popupView.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    popupView.removeFromSuperview()
                })
            }
        }
        
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

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
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
