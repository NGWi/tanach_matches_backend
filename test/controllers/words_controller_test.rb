require "test_helper"

class WordsControllerTest < ActionDispatch::IntegrationTest
  test "show" do
    get "/words/#{Word.first.id}.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal ["id", "verse_id", "text", "position", "created_at", "updated_at", "verse", "matches"], data.keys
  end
end
