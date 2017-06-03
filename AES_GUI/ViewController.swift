//
//  ViewController.swift
//  AES_GUI
//
//  Created by 李文坤 on 2017/6/3.
//  Copyright © 2017年 李文坤. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var mainWindow: NSWindow!
    
    @IBOutlet weak var selectInputFileButton: NSButton!
    @IBOutlet weak var selectOutputButton: NSButton!
    @IBOutlet weak var startButton: NSButton!
    @IBOutlet weak var inputFilePathTextField: NSTextField!
    @IBOutlet weak var passwordTextField: NSTextField!
    @IBOutlet weak var outputFilePathTextField: NSTextField!
    
    @IBOutlet weak var paddingTypeSelection: NSPopUpButton!
    @IBOutlet weak var encryptionModeSelection: NSPopUpButton!
    @IBOutlet weak var typeSelection: NSPopUpButton!
    @IBOutlet weak var indicator: NSProgressIndicator!
    
    
    @IBOutlet weak var noticeTextField: NSTextField!
    var open: NSOpenPanel!
    let alert = NSAlert();
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        typeSelection.removeAllItems()
        typeSelection.addItems(withTitles: ["加密", "解密"])
        
        encryptionModeSelection.removeAllItems()
        encryptionModeSelection.addItem(withTitle: "ECB")
        
        passwordTextField.placeholderString = "00000000000000000000000000000000"
        
        paddingTypeSelection.removeAllItems()
        paddingTypeSelection.addItem(withTitle: "PKCS5")
        
        indicator.isHidden = true
        
        alert.alertStyle = NSAlertStyle.warning;
        alert.messageText = "错误！"
        
    }
    
    @IBAction func selectInputFile(_ sender: Any) {
        
        let dialog = NSOpenPanel();
        
        dialog.title                   = "Choose a .txt file";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = false;
        dialog.canChooseDirectories    = false;
        dialog.canCreateDirectories    = true;
        dialog.allowsMultipleSelection = false;
        dialog.allowedFileTypes        = nil;
        
        if dialog.runModal() == NSModalResponseOK {
            let result = dialog.url // Pathname of the file
            if result != nil {
                let path = result!.path
                inputFilePathTextField.stringValue = path
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    @IBAction func selectOutputFile(_ sender: Any) {
        let dialog = NSSavePanel();
        
        dialog.allowedFileTypes = nil
        dialog.canCreateDirectories = true;
        if dialog.runModal() == NSModalResponseOK {
            let result = dialog.url;
            if result != nil {
                let path = result!.path
                outputFilePathTextField.stringValue = path
            }
        } else  {
            return
        }
    }
    
    @IBAction func startTask(_ sender: Any) {
        print("task started !");
        let inputFilePath = inputFilePathTextField.stringValue
        let outputFilePath = outputFilePathTextField.stringValue
        let hexKey = passwordTextField.stringValue.isEmpty ? passwordTextField.placeholderString : passwordTextField.stringValue
        
        var error: String!
        if !FileManager.default.fileExists(atPath: inputFilePath) {
            error = "输入文件不存在！"
        } else if !isDirectoryValid(key: outputFilePath) {
            error = "输出目录不存在！"
        } else if !isKeyValid(key: hexKey!) {
            error = "请输入有效的密钥！"
        }
        
        if error != nil {
            alert.informativeText = error
            alert.beginSheetModal(for: NSApplication.shared().mainWindow!, completionHandler: { (modalResponse) -> Void in
                if modalResponse == NSAlertFirstButtonReturn {
                    print("Document deleted")
                }
            })
            return
        }
        
        startButton.isEnabled = false
        if typeSelection.selectedItem?.title == "加密" {
            onTaskStart(encrypt: true)
            Thread(block: {() -> () in
                self.encrypt(inputFilePath: inputFilePath, outputFilePath: outputFilePath, hexKey: hexKey!)
                self.onTaskOver(encrypt: true)
            }).start()
        } else {
            onTaskStart(encrypt: false)
            Thread(block: {() -> () in
                self.decrypt(inputFilePath: inputFilePath, outputFilePath: outputFilePath, hexKey: hexKey!)
                self.onTaskOver(encrypt: false)
            }).start()
        }
    }
    
    func isDirectoryValid(key: String) -> Bool {
        let range = key.range(of: "/", options: String.CompareOptions.backwards, range: nil, locale: Locale.current)
        if range == nil {
            return false
        }
        let directory = key.substring(to: (range?.lowerBound)!)
        return FileManager.default.fileExists(atPath: directory)
    }
    
    func isKeyValid(key: String) -> Bool {
        if (key.utf8.count != 32) {
            return false
        }
        for a:Character in key.characters {
            if (a < "a" || a > "f") && (a < "A" || a > "F") && (a < "0" || a > "9") {
                return false
            }
        }
        return true
    }
    
    func onTaskStart(encrypt: Bool) -> Void {
        noticeTextField.stringValue = encrypt ? "正在加密..." : "正在解密..."
        indicator.isHidden = false
        indicator.startAnimation(nil)
    }
    
    func onTaskOver(encrypt: Bool) -> Void {
        noticeTextField.stringValue = encrypt ? "加密成功!" : "解密成功!";
        startButton.isEnabled = true
        indicator.isHidden = true
    }
    
    func encrypt(inputFilePath: String, outputFilePath: String, hexKey: String) -> Void {
        OCAesBridge.encrypt(inputFilePath, outputFilePath, hexKey)
    }
    
    func decrypt(inputFilePath: String, outputFilePath: String, hexKey: String) -> Void {
        OCAesBridge.decrypt(inputFilePath, outputFilePath, hexKey)
    }
    
}


