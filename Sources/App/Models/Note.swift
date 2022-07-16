import Fluent
import Vapor

final class Note: Model, Content {
    static let schema = "sticky_notes"
    
    @ID(key: .id)
    var id: UUID?

    @Field(key: "title")
    var title: String

	@Field(key: "content")
	var content: String

    init() { }

	init(id: UUID? = nil, title: String, content: String) {
        self.id = id
        self.title = title
		self.content = content
    }
}
