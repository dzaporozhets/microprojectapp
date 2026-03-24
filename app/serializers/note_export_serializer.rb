# frozen_string_literal: true

# Serializes a note for export
class NoteExportSerializer
  def initialize(note)
    @note = note
  end

  def as_json
    {
      'title' => @note.title,
      'content' => @note.content,
      'user_email' => @note.user.email
    }
  end
end
