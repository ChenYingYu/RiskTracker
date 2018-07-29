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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        activateChatbot()
    }

    func activateChatbot() {
        let username = "681ad1db-ad92-4885-8833-63190dec864e"
        let password = "WvREbOy1Exb4"
        let version = "2018-07-29" // use today's date for the most recent version
        let assistant = Assistant(username: username, password: password, version: version)
        
        let workspaceID = "14c5902c-f1de-4c75-b8ee-537b6ed2bd99"
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
        let input = InputData(text: "2")
        let request = MessageRequest(input: input, context: context)
        assistant.message(workspaceID: workspaceID, request: request, failure: failure) {
            response in
            print(response.output.text)
            context = response.context
        }
    }
}
