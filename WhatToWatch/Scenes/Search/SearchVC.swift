//
//  SearchVC.swift
//  WhatToWatch
//
//  Created by Fran on 04/10/2018.
//  Copyright © 2018 Fran. All rights reserved.
//

import UIKit

protocol SearchViewControllerInput {
    func displayList(_ viewModel: SearchViewModel)
    func displayLoadListError()
    func displayFilterList(_ list: [Item])
    func displayList()
    func displayImage(_ image: UIImage, forIndexPath: IndexPath)
    
}

protocol SearchViewControllerOutput {
    func loadMovieList()
    func loadMovieList(_ request: SearchRequest)
    func loadMovieListNextPage()
    func loadShowList()
    func loadShowList(_ request: SearchRequest)
    func loadShowListNextPage()
    func filterList(_ model: SearchViewModel, searhText: String)
    func loadImage(_ forItem: Item, fotIndexPath: IndexPath, withUrl: String)
}

class SearchVC: UIViewController, SearchViewControllerInput, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    @IBOutlet weak var table: UITableView!
    var pickerView = UIPickerView()
    var output: SearchViewControllerOutput!
    var router: SearchRouter!
    var filterItems = [Item]()
    var model: SearchViewModel!
    var filterActive = false
    @IBOutlet weak var searchController: UISearchBar!
    var tapGesture : UITapGestureRecognizer?
    
    // MARK: Object lifecycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        SearchConfigurator.sharedInstance.configure(self)
    }
    
    func displayList() {
        self.filterActive = false
        self.table.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpPickerView()
        loadList()
    }
    
    override func viewDidDisappear(_ animated:Bool) {
        super.viewDidDisappear(animated)
        doneWithPickerView()
    }

    func setUpNavigationBar() {
        let rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "Webp.net-resizeimage"), style: .plain, target: self, action: #selector(setMediaType))
        self.navigationItem.rightBarButtonItem = rightBarButtonItem
        self.navigationItem.title = "Search Movie"
        navigationController?.navigationBar.barTintColor = #colorLiteral(red: 0.06666666667, green: 0.1019607843, blue: 0.1882352941, alpha: 1)
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
    func setUpPickerView(){
        tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.doneWithPickerView))
        self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.pickerView.bounds.size.width, height: self.pickerView.bounds.size.height)
        self.view.addSubview(self.pickerView)
        pickerView.delegate = self
        pickerView.backgroundColor = #colorLiteral(red: 0.06666666667, green: 0.1019607843, blue: 0.1882352941, alpha: 1)
    }
    
    @objc func setMediaType(){
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.size.height - self.pickerView.bounds.size.height, width: self.view.bounds.size.width, height: self.pickerView.bounds.size.height)
        })
        view.addGestureRecognizer(tapGesture!)
    }
    
    @objc func doneWithPickerView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerView.frame = CGRect(x: 0, y: self.view.bounds.size.height, width: self.pickerView.bounds.size.width, height: self.pickerView.bounds.size.height)
        })
        view.removeGestureRecognizer(tapGesture!)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            searchBar.endEditing(true)
            if pickerView.selectedRow(inComponent: 0) == 0 {
                output.loadMovieList(SearchRequest(searchText))
            } else {
                output.loadShowList(SearchRequest(searchText))
            }
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        output.filterList(self.model, searhText: searchText.lowercased())
    }
    // MARK: Event handling
    
    func loadList() {
        if pickerView.selectedRow(inComponent: 0) == 0 {
            output.loadMovieList()
        } else {
            output.loadShowList()
        }
    }
    
    // MARK: Display logic
    
    func displayList(_ viewModel: SearchViewModel) {
        self.model = viewModel
        filterItems = [Item]()
        self.filterActive = false
        self.table.reloadData()
    }
    
    func displayNextPageList(_ viewModel: SearchViewModel) {
        self.model.items.append(contentsOf: viewModel.items)
        filterItems = [Item]()
        self.filterActive = false
        self.table.reloadData()
    }
    
    func displayFilterList(_ list: [Item]) {
        self.filterItems = list
        self.filterActive = true
        self.table.reloadData()
    }
    
    func displayLoadListError() {
        
        let alertController = UIAlertController(title: "Error getting data",
                                                message: "The search could not be performed.",
                                                preferredStyle: .alert)
        
        alertController.addAction( UIAlertAction(title: "Dismiss",
                                                 style: .default, handler: nil))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: tableView
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.filterActive {
            return filterItems.count
        }
        
        if self.model != nil {
            return self.model.items.count
        } else {
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell") as? SearchCell
        let item = self.getItem(indexPath)
        cell?.configWitItem(item)
        
        if item.posterImage  == nil && item.posterPath != nil {
            self.output.loadImage(item, fotIndexPath: indexPath, withUrl: item.posterPath!)
        } else if item.posterImage != nil {
            cell!.thumbnailView.image = item.posterImage
        }
        
        if (indexPath.row > (self.model.items.count - 5)){
            if pickerView.selectedRow(inComponent: 0) == 0 {
                self.output.loadMovieListNextPage()
            } else {
                self.output.loadShowListNextPage()
            }
        }
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = self.getItem(indexPath)
        if pickerView.selectedRow(inComponent: 0) == 0 {
            self.router.navigateToMovieDetail(item)
        } else {
            self.router.navigateToShowDetail(item)
        }
        
    }
    
    //MARK utilities
    
    func displayImage(_ image: UIImage, forIndexPath: IndexPath) {
        if self.filterActive {
            if forIndexPath.row > filterItems.count {
                return
            }
        }
        
        var item = self.getItem(forIndexPath)
        item.posterImage = image
        let cell = self.table.cellForRow(at: forIndexPath) as? SearchCell
        cell?.thumbnailView.image = item.posterImage
    }
    
    func getItem(_ indexPath: IndexPath) -> Item {
        if self.filterActive {
            return self.filterItems[indexPath.row]
        } else {
            return self.model.items[indexPath.row]
        }
    }
}

//PickerViewDelegate Delegate
extension SearchVC : UIPickerViewDelegate, UIPickerViewDataSource {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 2
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData: String
        if row == 0{
            titleData = "Movies"
            self.navigationItem.title = "Search Movie"
        }else{
            titleData = "Shows"
            self.navigationItem.title = "Search Shows"
        }
        let myTitle = NSAttributedString(string: titleData, attributes: [NSAttributedString.Key.font:UIFont(name: "Georgia", size: 15.0)!,NSAttributedString.Key.foregroundColor:UIColor.white])
        return myTitle
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.view.endEditing(true)
        loadList()
        doneWithPickerView()
    }
}
