json.array!(@users) do |user|
    json.extract! user, :id, :username, :role, :email, :password, :password_confirmation, :phone, :active
    json.url user_url(user, format: :json)
end