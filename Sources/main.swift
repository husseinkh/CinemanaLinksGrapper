// The Swift Programming Language
// https://docs.swift.org/swift-book
import Foundation


    var resolution : VideoInfoElement.Resolution = .fullHD

func fetchShowAndSave(showID : Int) {
        
            let folderULR = FileManager.default.urls(for: .moviesDirectory, in: .userDomainMask)[0].appendingPathComponent("Cinemana", isDirectory: true)
            print(folderULR)
            let cinemanaShowProcessor =  CinemanaShowProcessor(showID: showID,resolution: resolution ,renameFile: true , folderURL: folderULR) {  result in
                DispatchQueue.main.async {
                    
                print(result)
             
                }
               
            }
            cinemanaShowProcessor.startProcess()
        
        
    }
    
    
   




let TheWitcherBloodOriginID = 863872
var showID: Int = 0
print("Enter Show ID: ")
if let showIDSTR = readLine() {
    showID = Int(showIDSTR) ?? TheWitcherBloodOriginID
}
fetchShowAndSave( showID:showID)
dispatchMain()
