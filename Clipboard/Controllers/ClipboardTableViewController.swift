//
//  ClipboardTableViewController.swift
//  Clipboard
//
//  Created by Jonathan Yataco  on 5/24/20.
//  Copyright © 2020 JonYataco. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ClipboardTableViewController: UITableViewController {

    var container: NSPersistentContainer!
    var items: [Clip] = []
    var filteredClips: [Clip] = []
    let search = UISearchController(searchResultsController: nil)
    var isSearchBarEmpty: Bool {
        return search.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return search.isActive && !isSearchBarEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupSearchBar()
        setupData()
        if container != nil {
            print("The data container has been setup correctly")
        }
    }
    
    func setupSearchBar() -> Void {
        navigationItem.searchController = search
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController?.searchResultsUpdater = self
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
        if isFiltering {
            return filteredClips.count
        } else {
            return items.count
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Configuring the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "clipCell", for: indexPath) as! ClipCell
        if isFiltering {
            cell.titleLabel.text = filteredClips[indexPath.row].title
            cell.linkLabel.text = filteredClips[indexPath.row].link
            cell.faviconImage.image = filteredClips[indexPath.row].favicon
        } else {
            cell.titleLabel.text = items[indexPath.row].title
            cell.linkLabel.text = items[indexPath.row].link
            cell.faviconImage.image = items[indexPath.row].favicon
        }
        // The URL String to fetch the favicon
        let faviconURLString = "https://s2.googleusercontent.com/s2/favicons?domain_url=" + cell.linkLabel.text!
        
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

extension ClipboardTableViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(search.searchBar.text!)
    }
    
    func filterContentForSearchText(_ searchText: String) {
        filteredClips = items.filter( {(item: Clip) -> Bool in
            return item.title.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
}
