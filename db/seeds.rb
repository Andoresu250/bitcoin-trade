

User.create!(email: "admin@admin.com", password: "12345678", password_confirmation: "12345678") { |u| u.profile = Admin.create!(name: "Admin") }

Country.create!(
    name: "Colombia", code: "57", locale: "es-CO", time_zone: "Bogota",
    money_code: "COP", symbol: "$",
    document_types_attributes: [
          { name: "Cedula", abbreviation: "CC" },
          { name: "Pasaporte", abbreviation: "PAS" }
        ]
    )
Country.create!(
    name: "España", code: "34", locale: "es-ES", time_zone: "Madrid",
    money_code: "EUR", symbol: "€",
    document_types_attributes: [
      { name: "DNI", abbreviation: "DNI" },
      { name: "Pasaporte", abbreviation: "PAS" }
        ]
    )

Country.create!(
    name: "Peru", code: "51", locale: "es-PE", time_zone: "Lima",
    money_code: "SOL", symbol: "S/.",
    document_types_attributes: [
      { name: "DNI", abbreviation: "DNI" },
      { name: "Pasaporte", abbreviation: "PAS" }
    ]
)
