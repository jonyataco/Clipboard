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
    var items: [Clip] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupData()
    }
    
    func setupSearchBar() -> Void {
        navigationItem.searchController = UISearchController(searchResultsController: nil)
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    func setupData() {
        for _ in 1...10 {
            items.append(Clip(title: "Hello", link: "www.youtube.com"))
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        // Configuring the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipCell", for: indexPath) as! ClipCell
        cell.titleLabel.text = items[indexPath.row].title
        cell.linkLabel.text = items[indexPath.row].link
        cell.faviconImage.image = items[indexPath.row].favicon
        
        // The URL String to fetch the favicon
        let faviconURLString = "https://s2.googleusercontent.com/s2/favicons?domain_url=" + items[indexPath.row].link
        
        // Network call to get the favicon item.
        if let _ = URL(string: faviconURLString) {
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
        copyLinkToClipboard(link: items[indexPath.row].link)
        createPopUp()
    }
    
    @IBAction func unwindToClipboard(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! AddItemViewController
        
        if let clip = sourceViewController.newClip {
            let newIndexPath = IndexPath(row: items.count, section: 0)
            items.append(clip)
            tableView.insertRows(at: [newIndexPath], with: .automatic)
        }
    }
    
    func copyLinkToClipboard(link: String) {
        let pasteboard = UIPasteboard.general
        pasteboard.string = link
    }
    
    func createPopUp() {
        let visibleRect = CGRect(x: tableView.contentOffset.x, y: tableView.contentOffset.y, width: tableView.bounds.size.width, height: tableView.bounds.size.height)
        
        let popupText: UILabel = {
            let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 30))
            label.text = "Copied to clipboard!"
            label.textAlignment = .center
            label.layer.masksToBounds = true
            label.layer.cornerRadius = 10
            label.layer.borderWidth = 1
            label.alpha = 0
            label.center = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            return label
        }()
    
        self.view.addSubview(popupText)
        
        UIView.animate(withDuration: 0.6, animations: {
            popupText.alpha = 1
        }) { (_) in
            UIView.animate(withDuration: 0.6, animations: {
                popupText.alpha = 0
            }) { (_) in
                UIView.animate(withDuration: 0.1, animations: {
                    popupText.removeFromSuperview()
                })
            }
        }
    }
}
