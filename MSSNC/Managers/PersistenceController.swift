//
//  PersistenceController.swift
//  MSSNC
//
//  Created by Trevor Bays on 8/4/21.
//

import CoreData

/// Controller for accessing CoreData
struct PersistenceController {

    static let shared = PersistenceController()
    let def           = DefaultsManager.shared
    let container     : NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "StickyNotesModel")

        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error: \(error)")
            }
        })
    }

    /// Saves currently used CoreData context
    /// - Parameter context: NSManagedObjectContext
    public func saveContext(context: NSManagedObjectContext) {
        do {
            try context.save()
        } catch {
            let error = error as NSError
            fatalError("Unresolved \"saveContext\" Error: \(error)")
        }
    }

    /// Create new default Note and save CoreData model context
    /// - Parameter context: Currently used CoreData context, NSManagedObjectContext
    /// - Returns: StickyNote
    public func addStickyNote(context: NSManagedObjectContext, save: Bool, originWindow: CGRect) -> StickyNote {
//        let newStickNote = StickNote(title: "Untitled", lastOpened: Date(), open: false, accent: NoteColors.Yellow, content: "", x: 0, y: 0, w: 350, h: 600)

//        Use origin windows x, y, w, h to position new note window to the right
        let newX = originWindow.origin.x + originWindow.size.width + 8
        let newY = originWindow.origin.y
        let newW = originWindow.size.width
        let newH = originWindow.size.height

        let newSNote        = StickyNote(context: context)
        newSNote.id         = UUID()
        newSNote.title      = "local_untitlednote".localized()
        newSNote.lastOpened = Date()
        newSNote.open       = true
        newSNote.accent     = def.defaultAccent
        newSNote.content    = ""
        newSNote.posX       = Float(newX)
        newSNote.posY       = Float(newY)
        newSNote.sizeW      = Float(newW)
        newSNote.sizeH      = Float(newH)

        if (save) {
            saveContext(context: context)
        }

        return newSNote
    }

    /// Create new copy Note and save CoreData model context
    /// - Parameter context: Currently used CoreData context, NSManagedObjectContext
    /// - Returns: StickyNote
    public func duplicateStickyNote(context: NSManagedObjectContext, title: String, open: Bool, accent: Float, content: String, posX: Float, posY: Float, sizeW: Float, sizeH: Float, save: Bool) -> StickyNote {
//        let newStickNote = StickNote(title: "Untitled", lastOpened: Date(), open: false, accent: NoteColors.Yellow, content: "", x: 0, y: 0, w: 350, h: 600)
        let dupNote        = StickyNote(context: context)
        dupNote.id         = UUID()
        dupNote.title      = title
        dupNote.lastOpened = Date()
        dupNote.open       = open
        dupNote.accent     = accent
        dupNote.content    = content
        dupNote.posX       = posX
        dupNote.posY       = posY
        dupNote.sizeW      = sizeW
        dupNote.sizeH      = sizeH

        if (save) {
            saveContext(context: context)
        }

        return dupNote
    }

    /// Batch deletes entire CoreData model of all StickyNotes, then saves context
    public func clearAllStickyNotes() {
        let deleteFetch   = NSFetchRequest<NSFetchRequestResult>(entityName: "StickyNote") // <- use "StickyNote" object name directly here
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

        do {
            try container.viewContext.execute(deleteRequest)
        } catch {
            print ("Error clearing all StickyNote's")
        }
        
        saveContext(context: container.viewContext)
    }
}
