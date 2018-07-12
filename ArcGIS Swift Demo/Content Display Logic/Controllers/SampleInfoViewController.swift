//
//  SampleInfoViewController.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/12.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit
import ArcGIS

class SampleInfoViewController: UIViewController {

    @IBOutlet private weak var webView: UIWebView!
   
    var folderName:String!

    override func viewDidLoad() {
        super.viewDidLoad()

        if self.folderName != nil {
            self.fetchFileContent(for: self.folderName)
        }
    }

    func fetchFileContent(for folderName:String) { //321读取文件了解一下
        if let path = Bundle.main.path(forResource: "README", ofType: "md", inDirectory: folderName) {
            //read the content of the file
            if let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
                //remove the images
                let pattern = "!\\[.*\\]\\(.*\\)"
                if let regex = try? NSRegularExpression(pattern: pattern, options: NSRegularExpression.Options.caseInsensitive) {
                    let newContent = regex.stringByReplacingMatches(in: content, options: NSRegularExpression.MatchingOptions(), range: NSMakeRange(0, content.count), withTemplate: "")
                    self.displayHTML(newContent)
                }
            }
        }
    }
    
    func displayHTML(_ readmeContent:String) {
        let cssPath = Bundle.main.path(forResource: "style", ofType: "css") ?? ""
        let string = "<!doctype html>" +
            "<html>" +
            "<head> <link rel=\"stylesheet\" href=\"\(cssPath)\">" +
            "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://cdnjs.cloudflare.com/ajax/libs/foundation/5.5.2/css/foundation.min.css\">" +
            "<link rel=\"stylesheet\" type=\"text/css\" href=\"https://maxcdn.bootstrapcdn.com/font-awesome/4.4.0/css/font-awesome.min.css\">" +
            "<meta name=\"viewport\" content=\"initial-scale=1, width=device-width, height=device-height, viewport-fit=cover\">" +
            "</head>" +
            " <div id=\"preview\" sd-model-to-html=\"text\">" +
            "<div id=\"content\">" +
            "\(readmeContent)" +
            "</div></div>" +
            "<script src=\"https://cdnjs.cloudflare.com/ajax/libs/showdown/1.1.0/showdown.js\"></script>" +
            "<script>" +
            "var conv = new showdown.Converter();" +
            "var txt = document.getElementById('content').innerHTML;" +
            "document.getElementById('content').innerHTML = conv.makeHtml(txt);" +
            "</script>" +
            "</body>" +
        "</html>"
        
        self.webView.loadHTMLString(string, baseURL: URL(fileURLWithPath: Bundle.main.bundlePath))
    }
    
}
