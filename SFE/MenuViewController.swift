//
//  MenuViewController.swift
//  XCHAT
//
//  Created by Mateo Garcia on 5/13/15.
//  Copyright (c) 2015 Mateo Garcia. All rights reserved.
//

import UIKit
import Parse

protocol MenuDelegate {
    func menuButtonTapped()
}

// NOTE: Aux Admin code commented out.

class MenuViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var hamburgerViewController: HamburgerViewController?
    
    let kProfileCellHeight: CGFloat = 172
    let kMenuCellHeight: CGFloat = 55
    
    var numCells = 3
    
    enum ContentView: String {
        case Stories
        case ContactUs
        case About
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.tableFooterView = UIView(frame: CGRect.zero)
        
        self.tableView.canCancelContentTouches = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Helpers

extension MenuViewController {
    func presentContentView(_ type: ContentView) {
        switch type {
        case .About:
            let storyboard = UIStoryboard(name: "About", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "AboutNC") as! UINavigationController
            let firstViewController = navigationController.viewControllers[0] as! AboutViewController
            firstViewController.menuDelegate = self
            
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            self.hamburgerViewController?.contentViewController = navigationController
        case .Stories:
            let storyboard = UIStoryboard(name: "Stories", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "StoriesNC") as! UINavigationController
            let firstViewController = navigationController.viewControllers[0] as! StoriesViewController
            firstViewController.menuDelegate = self
            
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            self.hamburgerViewController?.contentViewController = navigationController
        case .ContactUs:
            let storyboard = UIStoryboard(name: "ContactUs", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "ContactUsNC") as! UINavigationController
            let firstViewController = navigationController.viewControllers[0] as! ContactUsViewController
            firstViewController.menuDelegate = self
            
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            self.hamburgerViewController?.contentViewController = navigationController
        }
    }
}

    
// MARK: Table View

extension MenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        switch indexPath.row {
        case 0:
            cell = tableView.dequeueReusableCell(withIdentifier: "AboutCell")!
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "StoriesCell")!
        default: // case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "ContactUsCell")!
        }
        
        cell.frame.size.height = self.kMenuCellHeight
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.numCells
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0:
            return self.kProfileCellHeight
        default:
            return self.kMenuCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        print(indexPath.row)
        
        let cellType = ContentView.init(rawValue: tableView.cellForRow(at: indexPath)!.reuseIdentifier!.replacingOccurrences(of: "Cell", with: ""))!
        self.presentContentView(cellType)
    }
}


// MARK: - Menu Delegate

extension MenuViewController: MenuDelegate {
    func menuButtonTapped() {
        
        print("SHOW/HIDE MENU")
        
        self.hamburgerViewController?.showOrHideMenu()
    }
}
