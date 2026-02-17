use serde::Deserialize;

#[derive(Debug, Deserialize)]
pub struct SpeciesList {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Species>,
}

#[derive(Debug, Clone, Deserialize, uniffi::Record)]
pub struct Species {
    pub name: String,
    pub classification: String,
    pub designation: String,
    pub average_height: String,
    pub skin_colors: String,
    pub hair_colors: String,
    pub eye_colors: String,
    pub average_lifespan: String,
    pub homeworld: Option<String>,
    pub language: String,
    pub people: Vec<String>,
    pub films: Vec<String>,
    pub created: String,
    pub edited: String,
    pub url: String,
}

impl Species {
    pub fn description(&self) -> String {
        format!(
            "\n\
            ---------------------\n\
            Name:               {}\n\
            Classification:     {}\n\
            Designation:        {}\n\
            Average Height:     {}\n\
            Skin Colors:        {}\n\
            Hair Colors:        {}\n\
            Eye Colors:         {}\n\
            Average Lifespan:   {}\n\
            Homeworld:          {}\n\
            Language:           {}\n
            ---------------------\n",
            self.name,
            self.classification,
            self.designation,
            self.average_height,
            self.skin_colors,
            self.hair_colors,
            self.eye_colors,
            self.average_lifespan,
            self.homeworld
                .as_ref()
                .map_or_else(|| "Unknown".to_string(), |s| s.clone()),
            self.language
        )
    }
}