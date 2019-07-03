import UIKit

extension Note {
    static func parse(json: [String: Any]) -> Note? {
        guard let uid = json["uid"] as? String,
            let title = json["title"] as? String,
            let content = json["content"] as? String
            else {
                return nil
        }
        
        let colorUI = json["color"] as? String
    
        let importance = json["importance"] as? Importance
        return Note(uid: uid,
                    title: title,
                    content: content,
                    color: convertStringToUI(str: colorUI!),
                    importance: importance!,
                    selfDestructionDate: Date())
    }
    
    var json: [String: Any] {
        return ["uid": uid,
                "title": title,
                "content": content,
                "color": (color == .white ? nil : convertUIToString(color: color)) as Any,
                "importance": (importance == .normal) as Any,
                "selfDestructionDate": selfDestructionDate?.timeIntervalSince1970 as Any]
    }
}

func convertStringToUI(str: String) -> UIColor {
    var color: UIColor
    switch str {
    case "white": color =  UIColor.white
    case "red": color =  UIColor.red
    case "green": color =  UIColor.green
    case "yellow": color =  UIColor.yellow
    default:
        color =  UIColor.white
    }
 return color
}

func convertUIToString(color: UIColor) -> String {
    var str: String
    switch color {
    case UIColor.white: str =  "white"
    case UIColor.red: str =  "red"
    case UIColor.green: str =  "green"
    case UIColor.yellow: str =  "yellow"
    default:
        str =  "white"
    }
    return str
}
