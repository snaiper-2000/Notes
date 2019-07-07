import Foundation
import CocoaLumberjack

class FileNotebook {
    private(set) var notes: [String: Note] = [:]
    
    private var notesJson: [[String: Any]] {
        return notes.values.map { $0.json }
    }
    
    private let dirname = "Notes"
    private let filename = "notes.json"
    private var filepath: String {
        let path = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
        let dirurl = path.appendingPathComponent(dirname)
        if !FileManager.default.fileExists(atPath: dirurl.path) {
            try! FileManager.default.createDirectory(at: dirurl, withIntermediateDirectories: true, attributes: nil)
        }
        return dirurl.appendingPathComponent(filename).path
    }
    
    public func add(_ note: Note) {
        DDLogInfo("Use func add")
		var checkOnRepeat: Bool = false
		for (_, value) in notes {	
			guard value.uid == note.uid else {
				checkOnRepeat = true
                break
			}			
		}
		if checkOnRepeat != true {
			notes[note.uid] = note
		}
    }
    
    public func remove(with uid: String) {
        notes[uid] = nil
    }
    
    public func saveToFile() {
		DDLogInfo("Use func saveToFile")
        guard let data = try? JSONSerialization.data(withJSONObject: notesJson, options: []) else {
            DDLogError("Eror JSON")
            fatalError("Eror JSON") }
        FileManager.default.createFile(atPath: filepath, contents: data)
    }
    
    public func loadFromFile() {
        guard let data = FileManager.default.contents(atPath: filepath) else { return }
        guard let jsonArray = try? JSONSerialization.jsonObject(with: data, options: []) as? [[String: Any]] else {
            DDLogError("Eror JSON")
            fatalError("Error JSON") }
        
        notes.removeAll()
        
        for json in jsonArray {
            if let note = Note.parse(json: json) {
                add(note)
            }
        }
    }
}
