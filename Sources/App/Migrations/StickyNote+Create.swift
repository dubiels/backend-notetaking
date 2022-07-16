import Fluent

extension Note {
	struct Create: AsyncMigration {
		func prepare(on database: Database) async throws {
			try await database.schema(Note.schema)
				.id()
				.field(.title, .string, .required)
				.field(.content, .string, .required)
				.create()
		}

		func revert(on database: Database) async throws {
			try await database.schema(Note.schema).delete()
		}
	}
}
