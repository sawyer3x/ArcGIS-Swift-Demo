//
//  CustomSearchHeaderView.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/11.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

protocol CustomSearchHeaderViewDelegate: class {
    func customSearchHeaderViewWillShowSuggestions(_ customSearchHeaderView:CustomSearchHeaderView)
    func customSearchHeaderViewWillHideSuggestions(_ customSearchHeaderView:CustomSearchHeaderView)
    func customSearchHeaderView(_ customSearchHeaderView:CustomSearchHeaderView, didFindSamples sampleNames:[String]?)
}

class CustomSearchHeaderView: UICollectionReusableView, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var suggestionsTableView: UITableView!
    
    private let cellIdentifier = "SuggestionCell"

    weak var delegate: CustomSearchHeaderViewDelegate?

    var nibView: UIView!
    let shrinkedViewHeight: CGFloat = 44
    let expandedViewHeight: CGFloat = 200
    var isShowingSuggestions = false
    
    var suggestions: [String]! {
        didSet {
            self.suggestionsTableView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.setup()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.setup()
    }
    
    func setup() {
        //set background color to clear color
        self.backgroundColor = .clear
        
        self.nibView = self.loadViewFromNib()
        
        self.nibView.frame = self.bounds
        nibView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, .flexibleWidth]
        
        if let searchTextField = self.searchBar.value(forKey: "searchField") as? UITextField {
            let placeholderAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont.systemFont(ofSize: UIFont.systemFontSize)]
            let attributedPlaceholder = NSAttributedString(string: "Search", attributes: placeholderAttributes)
            searchTextField.attributedPlaceholder = attributedPlaceholder
            searchTextField.textColor = .white
            searchTextField.borderStyle = .none
            searchTextField.layer.cornerRadius = 8
            searchTextField.backgroundColor = .secondaryBlue
            
            let imageV = searchTextField.leftView as! UIImageView
            imageV.image = imageV.image?.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
            imageV.tintColor = .white
        }
        
        self.addSubview(self.nibView)
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "CustomSearchHeaderView", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        
        return view
    }
    
    override func awakeFromNib() {
        //register table cell
        let nib = UINib(nibName: "SuggestionTableViewCell", bundle: Bundle(for: type(of: self)))
        self.suggestionsTableView.register(nib, forCellReuseIdentifier: cellIdentifier)
    }
    
    func showSuggestionsTable() {
        self.isShowingSuggestions = true
        self.delegate?.customSearchHeaderViewWillShowSuggestions(self)
    }
    
    func hideSuggestionsTable() {
        self.isShowingSuggestions = false
        self.delegate?.customSearchHeaderViewWillHideSuggestions(self)
    }
    
    func searchForString(_ string: String) {
        //hide suggestions
        self.hideSuggestionsTable()
        
        //hide keyboard
        self.searchBar.resignFirstResponder()
        
        //321用单例搜索？？？
        let sampleNames = SearchEngine.sharedInstance().searchForString(string)
        self.delegate?.customSearchHeaderView(self, didFindSamples: sampleNames)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
    }
    
}
