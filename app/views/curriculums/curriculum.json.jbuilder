json.array!(@curriculums) do |curriculum|
    json.extract! curriculum, :id, :name, :descriptin, :min_rating, :max_rating, :active
    json.url curriculum_url(curriculum, format: :json)
end