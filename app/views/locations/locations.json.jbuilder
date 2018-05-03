json.array!(@locations) do |location|
    json.extract! location, :id, :street_1, :street_2, :city, :state, :zip, :max_capacity, :active
    json.url location_url(location, format: :json)
end
