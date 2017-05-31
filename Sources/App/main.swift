import Vapor
import Foundation

let drop = Droplet()
let path = "/Users/WEI/Documents/workspce/hello/UserList.plist"
var userArray = NSArray.init(contentsOfFile: path)

drop.get { _ in
    return try JSON(node:["message":"Hello,World","code":"1000"])
}
drop.get ("Register"){ requst in
    guard let name = requst.data["name"]?.string else{
        throw Abort.badRequest
    }
    guard let password = requst.data["password"]?.string else{
        throw Abort.badRequest
    }
    if name.count != 0 && password.count != 0 {
        
        for var dict in userArray! {
            let userDic = dict as! NSDictionary
            if name == userDic["name"] as! String {
                return try JSON(node:["message":"\(name) repead!","code":"1001"])
            }
        }
        var dic:NSDictionary = ["name":name,"password":password]
        let newArray = userArray?.adding(dic)
        let isWrite = (newArray! as NSArray).write(toFile: path, atomically: true)
        if isWrite{
           return try JSON(node:["message":"Success Register!","code":"1000"])
        }else{
            return try JSON(node:["message":"Failed Register!","code":"1002"])
        }
    }else{
        return try JSON(node:["message":"Lose name or password !","code":"1003"])
    }
}
drop.get ("Login"){ requst in
    guard let name = requst.data["name"]?.string else{
        throw Abort.badRequest
    }
    guard let password = requst.data["password"]?.string else{
        throw Abort.badRequest
    }
    
    for var dict in userArray! {
        
        let userDic = dict as! NSDictionary
        
        if name == userDic["name"] as! String && password == userDic["password"]
            as! String {
            let data = try JSONSerialization.data(withJSONObject: userDic, options: .prettyPrinted)
            let dataString = String.init(data: data, encoding:.utf8)
            return try JSON(node:["message":"Welcome \(name)!","code":"1000","data":dataString])
        }
    }
    return try JSON(node:["message":"User name or password error!","code":"1004"])
}
drop.get ("Forget"){ requst in
    guard let name = requst.data["name"]?.string else{
        throw Abort.badRequest
    }
    guard let verifyNumber = requst.data["verifyNumber"]?.string else{
        throw Abort.badRequest
    }
    
    if name.count != 0 && verifyNumber.count != 0 {
        
        var isRegister = Bool.init(false)
        
        for var dict in userArray! {
            let userDic = dict as! NSDictionary
            if name == userDic["name"] as! String {
                isRegister = true
                
            }
        }
        
        if isRegister {
            if verifyNumber == "1234" {
                return try JSON(node:["message":"Change Password Success!","code":"1000"])
            }
        }else{
             return try JSON(node:["message":"\(name) not register!","code":"1005"])
        }
        
    }else{
        return try JSON(node:["message":"Lose name or verifyNumber !","code":"1006"])
    }
    
    return try JSON(node:["name":"Hello \(name)!","code":"1000"])
}
drop.get ("verifyNumber"){ requst in
    guard let name = requst.data["name"]?.string else{
        throw Abort.badRequest
    }
    for var dict in userArray! {
        
        let userDic = dict as! NSDictionary
        
        if name == userDic["name"] as! String{
            let codeNu:String = String.init(format: "%d",(arc4random()%1000)+8999)
            
            return try JSON(node:["message":"Welcome \(name)!","code":"1000","data":codeNu])
        }
    }
    return try JSON(node:["message":"The name not register!","code":"1005"])
}
drop.run()



//drop.get { req in
//    return try drop.view.make("welcome", [
//        "message": drop.localization[req.lang, "welcome", "title"]
//        ])
//}
//
//drop.resource("posts", PostController())
