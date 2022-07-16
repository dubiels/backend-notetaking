import Fluent
import Vapor

extension Note {
	/// A version of Note suitable for uploading.
	struct Upload: Content {
		/// The title of the note.
		var title: String
		/// The content of the note.
		var content: String
	}

	convenience init(_ upload: Upload) throws {
		self.init(
			title: upload.title,
			content: upload.content
		)
	}
}

struct NoteController: RouteCollection {
	static var idParameter: String = "noteID"

    func boot(routes: RoutesBuilder) throws {
        let notes = routes.grouped("notes")
        notes.get(use: index)
        notes.post(use: create)
		notes.group(":\(Self.idParameter)") { note in
			note.put(use: update)
            note.delete(use: delete)
        }
    }

    func index(req: Request) async throws -> [Note] {
        try await Note.query(on: req.db).all()
    }

    func create(req: Request) async throws -> Note {
		let note = try Note(req.content.decode(Note.Upload.self))
        try await note.save(on: req.db)
        return note
    }

	func update(req: Request) async throws -> Note {
		// Get the note we want to update
		guard let note = try await Note.find(req.parameters.get(Self.idParameter), on: req.db) else {
			throw Abort(.notFound)
		}

		let updateNote = try req.content.decode(Note.Upload.self)

		note.title = updateNote.title
		note.content = updateNote.content

		try await note.update(on: req.db)

		return note
	}

    func delete(req: Request) async throws -> HTTPStatus {
		guard let note = try await Note.find(req.parameters.get(Self.idParameter), on: req.db) else {
            throw Abort(.notFound)
        }
        try await note.delete(on: req.db)
        return .noContent
    }
}
