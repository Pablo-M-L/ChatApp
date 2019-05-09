//
//  ChatViewController.swift
//  ChatApp
//
//  Created by admin on 05/05/2019.
//  Copyright © 2019 admin. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework

class ChatViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UITextFieldDelegate {
    
    
    @IBOutlet weak var messagesTableView: UITableView!
    
    
    @IBOutlet weak var messageTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    
    @IBOutlet weak var textBoxHeight: NSLayoutConstraint!
    
    //inicializamos el array en vacio
    var messageArray: [Message] = [ Message]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.messagesTableView.delegate = self
        self.messagesTableView.dataSource = self
        
        self.messageTextField.delegate = self
        
        //reconocimiento de gestos en pantalla.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(messageTableViewTapped))
        //añade la reconocimiento de gestos al tableView, para que al pulsar en el se oculte el teclado
        // si está desplegado.
        self.messagesTableView.addGestureRecognizer(tapGesture)
        
        //registra la celda creada con el xib
        self.messagesTableView.register(UINib(nibName: "MessageCell", bundle: nil), forCellReuseIdentifier: "MessageCellID")
        
        self.messagesTableView.separatorStyle = .none
        
        configureTableView()
        
        // la subscripcion a la base de datos de firebase hay que hacerla una sola vez al final de didviewload.
        retrieveMessagesFromFirebase()
        
    }
    
    func configureTableView(){
        //asigna las propiedades de altura y altura estimada.
        self.messagesTableView.rowHeight = UITableView.automaticDimension
        self.messagesTableView.estimatedRowHeight = 120
    }
    
    @IBAction func logoutPressed(_ sender: Any) {
        /*
        let alertaController = UIAlertController(title: "CERRAR SESION", message: """
                                Está seguro que desea
                                cerrar la sesion y volver
                                a la pantalla principal.
                                """, preferredStyle: UIAlertController.Style.alert)
        
        //botones alert
        let btnAction = UIAlertAction(title: "OK", style: .default, handler: {(alert: UIAlertAction!) in
            self.cerrarSesion()})
        let btnCancelar = UIAlertAction(title: "cancelar", style: .default) { (alert: UIAlertAction!) in
            return
        }
        
        alertaController.addAction(btnAction)
        alertaController.addAction(btnCancelar)
        
        self.show(alertaController, sender: nil)
        */
        cerrarSesion()
        
        
        
    }
    
    func cerrarSesion()
    {
        do{
            try  Auth.auth().signOut()
        }
        catch{
            print("error al hacer signout")
        }
        
        //volver a la pantalla de inicio
        guard navigationController?.popToRootViewController(animated: true) != nil else{
            //en el caso de que ya este en el rootviewcontroller daria error.
            print("no hay viewcontroles que eliminar en la stack")
            return
        }
    }
    
    @IBAction func sendPressed(_ sender: UIButton) {
        //fuerza el cierre de la edicion de texto, y llama a resignFirstResponder para que pierda el foco para que quite el teclado.
        messageTextField.endEditing(true)
        
        messageTextField.isEnabled = false
        sendButton.isEnabled = false
        
        //referenciamos la base de datos firebas creando en ella una rama o hijo si no existe.
        let messagesDB = Database.database().reference().child("Messages")
        
        //creamos un diccionario a partir del objeto message.
        // el sender será el emai del usuario actual.
        // el mensaje (body) será el textfield .
        let messageDict = ["sender": Auth.auth().currentUser?.email,
                           "body": self.messageTextField.text!]
        messagesDB.childByAutoId().setValue(messageDict) { (error, ref) in
            if error != nil{
                print(error!)
            }
            else{
                print("mensaje guardado")
                
                self.messageTextField.isEnabled = true
                self.sendButton.isEnabled = true
                self.messageTextField.text = ""
                
            }
        }
        
    }
    
    //recibimos los datos y lo pasamos a un diccionario para pasarlo al array.
    func retrieveMessagesFromFirebase(){
        let messagesDB = Database.database().reference().child("Messages")
        //nos avisa cuando hay algun cambio en la tabla de firebase, con el metodo observe,
        //que realiza una "subcripcion" a la base de datos.
        //en este caso avisa cuando se añade un registo. (.chilAdded)
        //de la firebase recibimos la informacion del registro añadido en el objeto snapshot.
        
        messagesDB.observe(.childAdded) { (snapshot) in
            // el valor recibido a traves del snapshot es de tipo any? por eso le forzamos un cast a diccionario.
            let snpValue = snapshot.value as! Dictionary<String,String>
            //pasamos la clave y el valor del diccionario a una variable.
            let sender = snpValue["sender"]!
            let body = snpValue["body"]!
            
            //cramos el objeto de tipo Message.
            let message = Message(sender: sender, body: body)
            //añadimos el objeto al final de array.
            self.messageArray.append(message)
            
            //reconfigura el tamaño de las celdas.
            self.configureTableView()
            //repinta la tableview.
            self.messageArray = self.messageArray.suffix(20)
            self.messagesTableView.reloadData()
        }
    }
    
    
    
    // MARK: - funciones sistema
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MessageCellID", for: indexPath) as! MessageCell
        
        cell.userNameLabel.text = messageArray[indexPath.row].sender
        cell.messageLabel.text = messageArray[indexPath.row].body
        cell.messageImageVew.image = UIImage(named: "megaphone")
        
        //cambia el color dependiendo si es el mensaje es propio o de otro usuario.
        if cell.userNameLabel.text == Auth.auth().currentUser?.email {
            //color de la libreria chameleon
            cell.messageImageVew.backgroundColor = UIColor.flatLime()
            cell.messageBackground.backgroundColor = UIColor.flatSkyBlue()
        }
        else{
            cell.messageImageVew.backgroundColor = UIColor.flatWatermelon()
            cell.messageBackground.backgroundColor = UIColor.flatWhite()
        }
        
        return cell
        
    }
    
    /* //MARK: - UITextFieldDelegate methos*/
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        /*
         //sin animacion
         // 258 puntos es el tamaño aprox del teclado.
         self.textBoxHeight.constant = 677 - 300
         
         //recalcula y repinta si algun elemento ha variado.
         self.view.layoutIfNeeded()
         */
        //con animacion
        UIView.animate(withDuration: 0.5){
            self.textBoxHeight.constant = 677 - 300
            self.view.layoutIfNeeded()
        }
    }
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        /*
         //sin animacion
         self.textBoxHeight.constant = 677
         self.view.layoutIfNeeded()
         */
        messageTableViewTapped()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        var texto1 = self.messageTextField.text
        texto1 = texto1! + "\n"
        self.messageTextField.text = texto1!
        print(texto1!)
        return true
    }
    
    //oculta el teclado y pone el view deltextfiled en tamaño original.
    @objc func messageTableViewTapped(){
        //pierde el foco el textField.
        self.messageTextField.resignFirstResponder()
        
        //animacion que hace el constraint del view que contiene el textfield vuelva al
        //tamaño original.
        UIView.animate(withDuration: 0.5){
            self.textBoxHeight.constant = 677
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
