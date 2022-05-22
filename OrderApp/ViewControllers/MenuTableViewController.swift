//
//  MenuTableViewController.swift
//  OrderApp
//
//  Created by Duliba Sviatoslav on 17.05.2022.
//

import UIKit

@MainActor
class MenuTableViewController: UITableViewController {

    let category: String
    //let menuController = MenuController()
    var menuItems = [MenuItem]()
    var imageLoadTasks: [IndexPath: Task<Void, Never>] = [:]

    init?(coder: NSCoder, category: String) {
        self.category = category
        super.init(coder: coder)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        title = category.capitalized
        canThrowErrors()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        imageLoadTasks.forEach { key , value in
            value.cancel()
        }
    }
//        Task.init {
//            do {
//                let menuItems = try await
//                menuController.fetchMenuItems(forCategory: category)
//                updateUI(with: menuItems)
//            } catch {
//                displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
//            }
//        }
//    }
    func updateUI(with menuItems: [MenuItem]) {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    
        func displayError(_ error: Error, title: String) {
            guard let _ = viewIfLoaded?.window else { return }
            let alert = UIAlertController(title: title, message:
               error.localizedDescription, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Dismiss",
               style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    

    @IBSegueAction func showMenuItem(_ coder: NSCoder, sender: Any?) -> MenuItemDetailViewController? {
        guard let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) else {
                return nil
    }
        let menuItem = menuItems[indexPath.row]
            return MenuItemDetailViewController(coder: coder, menuItem: menuItem)
        }
        
    func canThrowErrors() {
        Task.init {
            do {
                let menuItems = try await MenuController.shared.fetchMenuItems(forCategory: category)
                updateUI(with: menuItems)
            } catch {
                displayError(error, title: "Failed to Fetch Menu Items for \(self.category)")
            }
        }
    }
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath:
                   IndexPath) {
        let menuItem = menuItems[indexPath.row]
        
        var content = cell.defaultContentConfiguration()
        content.text = menuItem.name
        content.secondaryText = "$\(menuItem.price)"
        cell.contentConfiguration = content
        content.secondaryText = menuItem.price.formatted(.currency(code: "usd"))
        content.image = UIImage(systemName: "photo.on.rectangle")
        cell.contentConfiguration = content
//        Task.init {
//            if let image = try? await
//                MenuController.shared.fetchImage(from: menuItem.imageURL) {
//                if let currentIndexPath = self.tableView.indexPath(for:
//                                                                        cell),
//                   currentIndexPath == indexPath {
//                    var content = cell.defaultContentConfiguration()
//                    content.text = menuItem.name
//                    content.secondaryText =
//                    menuItem.price.formatted(.currency(code: "usd"))
//                    content.image = image
//                    cell.contentConfiguration = content
//                }
//            }
//        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItem", for: indexPath)
     
    configure(cell, forItemAt: indexPath)
     return cell
     }
    
    override func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
            imageLoadTasks[indexPath]?.cancel()
        }
    }
