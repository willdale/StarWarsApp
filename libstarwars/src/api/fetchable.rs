const BASE_URL: &str = "https://swapi.dev/api/";

#[derive(Debug, uniffi::Enum)]
pub enum Fetchable {
    Planets,
    People,
    Films,
    Species,
    Starships,
    Vehicles,
}

#[uniffi::export]
pub fn all_fetchable()-> Vec<Fetchable> {
    vec![
        Fetchable::Planets,
        Fetchable::People,
        Fetchable::Films,
        Fetchable::Species,
        Fetchable::Starships,
        Fetchable::Vehicles,
    ]
}

#[uniffi::export]
impl Fetchable {
    pub fn display_name(&self) -> String {
        match self {
            Self::Planets => String::from("Planets"),
            Self::People => String::from("People"),
            Self::Films => String::from("Films"),
            Self::Species => String::from("Species"),
            Self::Starships => String::from("Starships"),
            Self::Vehicles => String::from("Vehicles"),
        }
    }
}

impl Fetchable {
    pub fn url(&self) -> String {
        match self {
            Self::Planets => format!("{BASE_URL}planets"),
            Self::People => format!("{BASE_URL}people"),
            Self::Films => format!("{BASE_URL}films"),
            Self::Species => format!("{BASE_URL}species"),
            Self::Starships => format!("{BASE_URL}starships"),
            Self::Vehicles => format!("{BASE_URL}vehicles"),
        }
    }
}
