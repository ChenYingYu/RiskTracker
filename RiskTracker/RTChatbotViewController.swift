//
//  RTChatbotViewController.swift
//  RiskTracker
//
//  Created by ChenAlan on 2018/7/29.
//  Copyright © 2018年 ChenAlan. All rights reserved.
//

import UIKit
import AssistantV1

class RTChatbotViewController: UIViewController {
    @IBOutlet weak var firstChatbotLabel: UILabel!
    @IBOutlet weak var userChatLabel: UILabel!
    @IBOutlet weak var secondChatbotLabel: UILabel!
    @IBAction func getBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    @IBOutlet weak var chatTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        chatTextField.delegate = self
        activateChatbot()
    }

    func activateChatbot() {
        let username = RTConstants.chatbotUserName 
        let password = RTConstants.chatbotPassword
        let version = "2018-07-29" // use today's date for the most recent version
        let assistant = Assistant(username: username, password: password, version: version)
        
        let workspaceID = RTConstants.chatbotWorkspaceID
        let failure = { (error: Error) in print(error) }
        var context: Context? // save context to continue conversation
        assistant.message(workspaceID: workspaceID, failure: failure) {
            [weak self]
            response in
            print(response.output.text)
            DispatchQueue.main.async {
                self?.firstChatbotLabel.text = response.output.text[0]
            }
            context = response.context
        }
    }
}

extension RTChatbotViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == chatTextField {
            textField.resignFirstResponder()
            userChatLabel.text = textField.text
            userChatLabel.isHidden = false
            let username = RTConstants.chatbotUserName
            let password = RTConstants.chatbotPassword
            let version = "2018-07-29" // use today's date for the most recent version
            let workspaceID = RTConstants.chatbotWorkspaceID
            let assistant = Assistant(username: username, password: password, version: version)
            let failure = { (error: Error) in print(error) }
            var context: Context? // save context to continue conversation
            if let text = textField.text {
                let input = InputData(text: text)
                let request = MessageRequest(input: input, context: context)
                assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
                    [weak self] response in
                    print(response.output.text)
                    context = response.context
                    DispatchQueue.main.async {
                        self?.secondChatbotLabel.text = response.output.text[0]
                        self?.secondChatbotLabel.isHidden = false
                    }
                }
            }
            return false
        }
        return true
    }
}
