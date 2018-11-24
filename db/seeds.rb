

User.create!(email: "admin@admin.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Admin.create!(name: "Admin") }