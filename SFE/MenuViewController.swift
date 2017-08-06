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
    
    let kMinCells = 7
    let kMaxCells = 8
    var numCells = 7
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        self.checkAdmin()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}


// MARK: - Helpers

extension MenuViewController {
    func checkAdmin() {
        if AppDelegate.isAdmin {
            self.numCells = kMaxCells
        } else {
            self.numCells = kMinCells
        }
        if self.tableView != nil {
            self.tableView.reloadData()
        }
    }
    
    func presentContentView(_ type: ContentView) {
        switch type {
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
            let firstViewController = navigationController.viewControllers[0] as! StoriesViewController
            firstViewController.menuDelegate = self
            
            UIApplication.shared.setStatusBarHidden(false, with: .slide)
            self.hamburgerViewController?.contentViewController = navigationController
        case .About:
            let storyboard = UIStoryboard(name: "About", bundle: nil)
            let navigationController = storyboard.instantiateViewController(withIdentifier: "AboutNC") as! UINavigationController
            let firstViewController = navigationController.viewControllers[0] as! StoriesViewController
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
            cell = tableView.dequeueReusableCell(withIdentifier: "ProfileCell")!
        case 1:
            cell = tableView.dequeueReusableCell(withIdentifier: "ReelCell")!
        case 2:
            cell = tableView.dequeueReusableCell(withIdentifier: "AlertsCell")!
        case 3:
            cell = tableView.dequeueReusableCell(withIdentifier: "ChatCell")!
        /*
        case 4:
            cell = tableView.dequeueReusableCellWithIdentifier("AuxCell")!
        */
        case 4:
            cell = tableView.dequeueReusableCell(withIdentifier: "CalendarCell")!
        case 5:
            cell = tableView.dequeueReusableCell(withIdentifier: "MembersCell")!
        case 7:
            cell = tableView.dequeueReusableCell(withIdentifier: "AdminCell")!
        default:
            cell = tableView.dequeueReusableCell(withIdentifier: "SettingsCell")!
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
        
        var deltLoadingViewDeltColor = UIColor.black
        switch cellType {
        case .Profile:
            deltLoadingViewDeltColor = .white
        case .Reel:
            deltLoadingViewDeltColor = .red
        case .Alerts:
            deltLoadingViewDeltColor = .blue
        case .Chat:
            deltLoadingViewDeltColor = .blue
        case .Calendar:
            deltLoadingViewDeltColor = .red
        case .Members:
            deltLoadingViewDeltColor = .white
        case .Admin:
            deltLoadingViewDeltColor = .white
        case .Settings:
            deltLoadingViewDeltColor = .white
        }
        
        self.hamburgerViewController?.deltView.deltColor = deltLoadingViewDeltColor
        self.hamburgerViewController?.deltView.startAnimating()
        self.presentContentView(cellType)
    }
}


// MARK: - Menu Delegate

extension MenuViewController: MenuDelegate {
    func menuButtonTapped() {
        
        print("SHOW HIDE MENU")
        
        self.hamburgerViewController?.showOrHideMenu()
    }
}
