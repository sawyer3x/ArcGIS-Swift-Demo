//
//  SearchEngine.swift
//  ArcGIS Swift Demo
//
//  Created by sawyer3x on 2018/7/11.
//  Copyright © 2018年 sawyer3x. All rights reserved.
//

import UIKit

class SearchEngine: NSObject {

    static private let singleton = SearchEngine()
    
    private var indexArray: [String]!
    private var wordsDictionary: [String: [String]]!
    private var isLoading = false
    
    override init() {
        super.init()
        
        self.commonInit()
    }
    
    static func sharedInstance() -> SearchEngine {
        return singleton
    }
    
    private func commonInit() { //321不太明白啥意思 还有方法
        if !self.isLoading {
            self.isLoading = true
            DispatchQueue.global(qos: .background).async { [weak self] () -> Void in
                guard let weakSelf = self else {
                    return
                }
                //get the directory URLs that contain readme files
                let readmeDirectoriesURLs = weakSelf.findReadmeDirectoriesURLs()
                //index the content of all the readme files
                weakSelf.indexAllReadmes(readmeDirectoriesURLs: readmeDirectoriesURLs)
                self?.isLoading = false
            }
        }
    }
    
    private func findReadmeDirectoriesURLs() -> [URL] {//321不太明白啥意思 还有方法
        var readmeDirectoriesURLs = [URL]()
        
        let fileManager = FileManager.default
        let bundleURL = Bundle.main.bundleURL
        
        //get all the directories from the bundle
        let directoryEnumerator = fileManager.enumerator(at: bundleURL, includingPropertiesForKeys: [URLResourceKey.nameKey, URLResourceKey.isDirectoryKey], options: FileManager.DirectoryEnumerationOptions.skipsHiddenFiles, errorHandler: nil)
        
        //check if the returned url is of a directory
        if let directoryEnumerator = directoryEnumerator {
            while let fileURL = directoryEnumerator.nextObject() as? URL {
                var isDirectory: AnyObject?
                do {
                    try(fileURL as NSURL).getResourceValue(&isDirectory, forKey: URLResourceKey.isDirectoryKey)
                } catch {
                    print("throws")
                }
                
                //check if the directory contains a readme file
                if let isDirectory = isDirectory as? NSNumber, isDirectory.boolValue == true {
                    let readmePath = "\(fileURL.path)/README.md"
                    if fileManager.fileExists(atPath: readmePath) {
                        readmeDirectoriesURLs.append(fileURL)
                    }
                }
            }
        }
        
        return readmeDirectoriesURLs
    }
    
    private func indexAllReadmes(readmeDirectoriesURLs: [URL]) {
        self.indexArray = [String]()
        self.wordsDictionary = [String: [String]]() //321何种形式的
        
        let tagger = NSLinguisticTagger(tagSchemes: [NSLinguisticTagScheme.tokenType, NSLinguisticTagScheme.nameType, NSLinguisticTagScheme.lexicalClass], options: 0)
        
        for directoryURL in readmeDirectoriesURLs {//321不太明白具体实现方法
            autoreleasepool {
                if let contentString = self.contentOfReadmeFile(directoryPath: directoryURL.path) {
                    //sample display name
                    let sampleDisplayName = directoryURL.path.components(separatedBy: "/").last!
                    
                    tagger.string = contentString
                    let range = NSMakeRange(0, contentString.count)
                    tagger.enumerateTags(in: range, scheme: NSLinguisticTagScheme.lexicalClass, options: [NSLinguisticTagger.Options.omitWhitespace, NSLinguisticTagger.Options.omitPunctuation], using: { (tag:NSLinguisticTag?, tokenRange:NSRange, sentenceRange:NSRange, _) -> Void in
                        
                        guard let tag = tag else {
                            return
                        }
                        
                        if tag == NSLinguisticTag.noun || tag == NSLinguisticTag.verb || tag == NSLinguisticTag.adjective || tag == NSLinguisticTag.otherWord {
                            let word = (contentString as NSString).substring(with: tokenRange) as String
                            
                            //trivial comparisons
                            if word != "`." && word != "```" && word != "`" {
                                var samples = self.wordsDictionary[word]
                                //if word already exists in the dictionary
                                if samples != nil {
                                    //add the sample display name to the list if not already present
                                    if !(samples!.contains(sampleDisplayName)) {
                                        samples!.append(sampleDisplayName)
                                        self.wordsDictionary[word] = samples
                                    }
                                }
                                else {
                                    samples = [sampleDisplayName]
                                    self.wordsDictionary[word] = samples
                                }
                                
                                //add to the index
                                if !self.indexArray.contains(word) {
                                    self.indexArray.append(word)
                                }
                            }
                        }
                    })
                }
            }
        }
    }
    
    private func contentOfReadmeFile(directoryPath: String) -> String? {
        //find the path of the file
        let path = "\(directoryPath)/README.md"
        //read the content of the file
        if let content = try? String(contentsOfFile: path, encoding: String.Encoding.utf8) {
            return content
        }
        return nil
    }
    
    //MARK: - Public methods
    
    func searchForString(_ string:String) -> [String]? {
        //if the resources where released because of memory warnings
        if self.indexArray == nil {
            self.commonInit()
            return nil
        }
        
        //check if the string exists in the index array
        let words = self.indexArray.filter({ $0.uppercased() == string.uppercased() })
        if words.count > 0 {
            if let sampleDisplayNames = self.wordsDictionary[words[0]] {
                return sampleDisplayNames
            }
        }
        
        return nil
    }
    
    func suggestionsForString(_ string:String) -> [String]? {
        //if the resources where released because of memory warnings
        if self.indexArray == nil {
            self.commonInit()
            return nil
        }
        
        let suggestions = self.indexArray.filter( { $0.uppercased().range(of: string.uppercased()) != nil } )
        return suggestions
    }
    
}
