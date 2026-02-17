use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct People {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Person>,
}

#[derive(Deserialize, Clone, Debug, uniffi::Record)]
pub struct Person {
    pub birth_year: String,
    pub eye_color: String,
    pub films: Vec<String>,
    pub gender: String,
    pub hair_color: String,
    pub height: String,
    pub homeworld: Option<String>,
    pub mass: String,
    pub name: String,
    pub skin_color: String,
    pub created: String,
    pub edited: String,
    pub species: Vec<String>,
    pub starships: Vec<String>,
    pub url: String,
    pub vehicles: Vec<String>,
}

impl Person {
    pub fn description(&self) -> String {
        format!(
            "\n\
            -----------------\n\
            Name:           {}\n\
            Birth Year:     {}\n\
            Eye Color:      {}\n\
            Hair Color:     {}\n\
            Skin Color:     {}\n\
            Height:         {}\n\
            Mass:           {}\n\
            Gender:         {}\n\
            Homeworld:      {}\n\
            ------------------\n",
            self.name,
            self.birth_year,
            self.eye_color,
            self.hair_color,
            self.skin_color,
            self.height,
            self.mass,
            self.gender,
            self.homeworld
                .as_ref()
                .map_or_else(|| "Unknown".to_string(), |s| s.clone()),
        )
    }
}