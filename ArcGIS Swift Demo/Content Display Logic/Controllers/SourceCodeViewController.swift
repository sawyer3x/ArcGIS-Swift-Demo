//
//  SourceCodeViewController.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class SourceCodeViewController: UIViewController, UIWebViewDelegate, UIAdaptivePresentationControllerDelegate {

    @IBOutlet private weak var webView: UIWebView!
    @IBOutlet private weak var toolbarTitleButton: UIBarButtonItem!
    
    private var listViewController:ListViewController!
    private var selectedFilenameIndex = 0
    var filenames:[String]!
    
    private var isListViewContainerVisible = false
    private var isListViewContainerAnimating = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.webView.delegate = self
        
        if self.filenames != nil && self.filenames.count > 0 {
            self.loadHTMLPage(filename: self.filenames[0])
        }
    }

    func loadHTMLPage(filename:String) { //321加载网页了解一下
        if let content = self.contentOfFile(filename) {
            self.setupToolbarTitle(filename, arrowPointingDown: true)
            let htmlString = self.htmlStringForContent(content)
            self.webView.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
        }
    }
    
    func contentOfFile(_ name:String) -> String? {
        //find the path of the file
        if let path = Bundle.main.path(forResource: name, ofType: ".swift") {
            //read the content of the file
            if let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
                return content
            }
        }
        return nil
    }
    
    func htmlStringForContent(_ content:String) -> String {
        let cssPath = Bundle.main.path(forResource: "xcode", ofType: "css") ?? ""
        let jsPath = Bundle.main.path(forResource: "highlight.pack", ofType: "js") ?? ""
        let scale  = UIDevice.current.userInterfaceIdiom == .phone ? "0.5" : "1.0"
        let stringForHTML = "<html> <head>" +
            "<meta name='viewport' content='width=device-width, initial-scale='\(scale)'/> " +
            "<link rel=\"stylesheet\" href=\"\(cssPath)\">" +
            "<script src=\"\(jsPath)\"></script>" +
            "<script>hljs.initHighlightingOnLoad();</script> </head> <body>" +
            "<pre><code class=\"Swift\">\(content)</code></pre>" +
        "</body> </html>"
        //        println(stringForHTML)
        // style=\"white-space:initial;\"
        return stringForHTML
    }
    
    func setupToolbarTitle(_ filename:String, arrowPointingDown:Bool) {
        var titleString = filename
        if self.filenames.count > 1 {
            titleString = String(format: "%@ %@", (arrowPointingDown ? "▶︎" : " \u{25B4}"), filename)
        }
        else {
            self.toolbarTitleButton.setTitleTextAttributes([NSAttributedStringKey.foregroundColor : UIColor.black], for: UIControlState())
        }
        self.toolbarTitleButton.title = titleString
    }
    
    //MARK: - web view delegate
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return true
    }
    
    //MARK: - Actions
    
    
    //MARK: - Navigation
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if self.filenames.count > 1 {
            return true
        }
        return false
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FilenamesPopoverSegue" {
            let controller = segue.destination as! ListViewController
            controller.list = self.filenames
            controller.presentationController?.delegate = self
            controller.preferredContentSize = CGSize(width: 300, height: 200)
            
            controller.setSelectAction({ [weak self] (index:Int) -> Void in
                if let weakSelf = self {
                    weakSelf.selectedFilenameIndex = index
                    let filename = weakSelf.filenames[index]
                    weakSelf.loadHTMLPage(filename: filename)
                    weakSelf.dismiss(animated: true, completion: nil)
                }
            })
        }
    }
    
    //MARK: - UIAdaptivePresentationControllerDelegate //321这啥玩意儿
    
    func adaptivePresentationStyle(for controller: UIPresentationController, traitCollection: UITraitCollection) -> UIModalPresentationStyle {
        return UIModalPresentationStyle.none
    }
    
}