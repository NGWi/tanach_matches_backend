require "test_helper"

class VersesControllerTest < ActionDispatch::IntegrationTest
  test "index" do
    get "/verses.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal Verse.count, data.length
  end

  test "show" do
    get "/verses/#{Verse.first.id}.json"
    assert_response 200

    data = JSON.parse(response.body)
    assert_equal ["id", "book", "chapter", "verse_number", "text", "created_at", "updated_at", "words"], data.keys
  end
end
