

User.create!(email: "admin@admin.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Admin.create!(name: "Admin") }

Country.create!(
    name: "Colombia", code: "57", locale: "es-CO", time_zone: "Bogota", 
    money_code: "COP", symbol: "$",
    document_types_attributes: [
        {name: "cedula", abbreviation: "cc"}
        ]
    )
Country.create!(
    name: "Chile", code: "56", locale: "es-CL", time_zone: "Santiago", 
    money_code: "CLP", symbol: "$",
    document_types_attributes: [
        {name: "cedula", abbreviation: "cc"}
        ]
    )