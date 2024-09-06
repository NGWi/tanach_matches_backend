json.array!(@verses) do |verse|
  json.extract! verse, :id, :chapter, :verse_number, :text
end
