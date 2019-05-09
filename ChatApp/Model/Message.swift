//
//  Message.swift
//  ChatApp
//
//  Created by admin on 08/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

class Message{
    //emisor del mensaje (sender) y el mensaje (body)
    var sender: String = ""
    var body: String = ""
    
    init(sender: String, body: String) {
        self.sender = sender
        self.body = body
    }
    
    init(){
        sender = "pablo millan"
        body = "este es un mensaje de prueba \n para la aplicacion chatapp del curso ios"
    }
}
