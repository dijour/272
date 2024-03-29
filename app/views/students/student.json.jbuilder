json.array!(@students) do |student|
    json.extract! student, :id, :first_name, :last_name, :date_of_birth, :rating, :family_id, :active
    json.url student_url(student, format: :json)
end