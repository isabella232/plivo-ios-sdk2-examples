//
//  ContactsViewController.swift
//  SwiftVoiceCallingApp
//
//  Created by Siva  on 24/05/17.
//  Copyright © 2017 Plivo. All rights reserved.
//

import UIKit

class ContactsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, UISearchControllerDelegate, UISearchResultsUpdating {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
        
    }
    
    
    var searchController: UISearchController?
    var contactsSegmentControl: UISegmentedControl?
    var phoneSearchResults = [Any]()
    var isSearchControllerActive: Bool = false
    
    
    @IBOutlet weak var contactsTableView: UITableView!
    @IBOutlet weak var noContactsLabel: UILabel!
    
    
    // MARK: - Life cycle
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.contactsTableView.delegate = self
        self.contactsTableView.dataSource = self
        
        
        let label = UILabel(frame: CGRect(x: CGFloat(UIScreen.main.bounds.size.width * 0.28125), y: CGFloat(27), width: CGFloat(UIScreen.main.bounds.size.width * 0.4375), height: CGFloat(29)))
        label.text = "Contacts"
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: CGFloat(17))
        view.addSubview(label)
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self as? UISearchResultsUpdating
        searchController?.searchBar.sizeToFit()
        contactsTableView.tableHeaderView = searchController?.searchBar
        // We want ourselves to be the delegate for this filtered table so didSelectRowAtIndexPath is called for both tables.
        searchController?.delegate = self as? UISearchControllerDelegate
        searchController?.dimsBackgroundDuringPresentation = false
        // default is YES
        searchController?.searchBar.delegate = self as? UISearchBarDelegate
        // so we can monitor text changes + others
        // Search is now just presenting a view controller. As such, normal view controller
        // presentation semantics apply. Namely that presentation will walk up the view controller
        // hierarchy until it finds the root view controller or one that defines a presentation context.
        //
        definesPresentationContext = true
        
        // know where you want UISearchController to be displayed
        let plivoVC: PlivoCallController? = (tabBarController?.viewControllers?[2] as? PlivoCallController)
        Phone.sharedInstance.setDelegate(plivoVC!)
        
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        contactsTableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        isSearchControllerActive = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func handleSegmentControl(_ segment: UISegmentedControl) {
        contactsTableView.reloadData()
    }
    
    
    // MARK: - UISearchBarDelegate
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
    
    // MARK: - UISearchControllerDelegate
    // Called after the search controller's search bar has agreed to begin editing or when
    // 'active' is set to YES.
    // If you choose not to present the controller yourself or do not implement this method,
    // a default presentation is performed on your behalf.
    //
    // Implement this method if the default presentation is not adequate for your purposes.
    //
    func presentSearchController(_ searchController: UISearchController) {
    }
    
    func willPresentSearchController(_ searchController: UISearchController) {
        // do something before the search controller is presented
        isSearchControllerActive = true
    }
    
    func didPresentSearchController(_ searchController: UISearchController) {
        // do something after the search controller is presented
    }
    
    func willDismissSearchController(_ searchController: UISearchController) {
        // do something before the search controller is dismissed
    }
    
    func didDismissSearchController(_ searchController: UISearchController) {
        // do something after the search controller is dismissed
        isSearchControllerActive = false
    }
    
    
    
    // MARK: - UITableView
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60.0
    }
    


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let editprofileIdentifier: String = "CallHistory"
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: editprofileIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: editprofileIdentifier)
        }
        cell?.imageView?.image = UIImage(named: "TabbarIcon1")
        return cell!

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
    }
    
    
    // MARK: - UISearchResultsUpdating
    func updateSearchResults(for searchController: UISearchController) {
        
        
    }
    
    /*
     * Making a call by using Siri
     */
    
    func makeCall(withSiriName name: String) {
        
        let contactsArray: [Any] = (UserDefaults.standard.object(forKey: "PhoneContacts") as! [Any])
        
        for i in 0..<contactsArray.count
        {
            let contact: [AnyHashable: String] = contactsArray[i] as! [AnyHashable : String]
            if (contact["Name"]?.contains(name))! {
                let contactNumber: String = contact["Number"]!
                let plivoVC: PlivoCallController? = (tabBarController?.viewControllers?[2] as? PlivoCallController)
                self.tabBarController?.selectedViewController = self.tabBarController?.viewControllers?[2]
                Phone.sharedInstance.setDelegate(plivoVC!)
                CallKitInstance.sharedInstance.callUUID = UUID()
                
                var phoneNumber: String = (contactNumber as NSString).replacingOccurrences(of: "\\s", with: "", options: .regularExpression, range: NSRange(location: 0, length:contactNumber.characters.count))
                phoneNumber = phoneNumber.replacingOccurrences(of: "(", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: ")", with: "")
                phoneNumber = phoneNumber.replacingOccurrences(of: "-", with: "")
                
                plivoVC?.performStartCallAction(with: CallKitInstance.sharedInstance.callUUID!, handle: phoneNumber)
            }
        }
    
    }
    @IBAction func feedbackButtonTapped(_ sender: Any) {
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        let yesButton = UIAlertAction(title: "Yes", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //Handle your yes please button action here
            UtilClass.makeToastActivity()
            let plivoVC: PlivoCallController? = (self.tabBarController?.viewControllers?[2] as? PlivoCallController)
            Phone.sharedInstance.setDelegate(plivoVC!)
            plivoVC?.unRegisterSIPEndpoit()
        })
        let noButton = UIAlertAction(title: "No", style: .default, handler: {(_ action: UIAlertAction) -> Void in
            //Handle no, thanks button
        })
        alert.addAction(noButton)
        alert.addAction(yesButton)
        present(alert, animated: true, completion: { })
    }
    
}
