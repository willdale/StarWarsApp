use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Starships {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Starship>,
}

#[derive(Deserialize, Clone, Debug, uniffi::Record)]
pub struct Starship {
    pub name: String,
    pub model: String,
    pub manufacturer: String,
    pub cost_in_credits: String,
    pub length: String,
    pub max_atmosphering_speed: String,
    pub crew: String,
    pub passengers: String,
    pub cargo_capacity: String,
    pub consumables: String,
    pub hyperdrive_rating: String,
    #[serde(rename = "MGLT")]
    pub mglt: String,
    pub starship_class: String,
    pub pilots: Vec<String>,
    pub films: Vec<String>,
    pub created: String,
    pub edited: String,
    pub url: String,
}

impl Starship {
    pub fn description(&self) -> String {
        format!(
            "\n\
            ---------------------\n\
            Name:                   {}\n\
            Model:                  {}\n\
            Manufacturer:           {}\n\
            Cost in Credits:        {}\n\
            Length:                 {}\n\
            Max Atmosphering Speed: {}\n\
            Crew:                   {}\n\
            Passengers:             {}\n\
            Cargo Capacity:         {}\n\
            Consumables:            {}\n\
            Hyperdrive Rating:      {}\n\
            MGLT:                   {}\n\
            Starship Class:         {}\n\
            ---------------------\n",
            self.name,
            self.model,
            self.manufacturer,
            self.cost_in_credits,
            self.length,
            self.max_atmosphering_speed,
            self.crew,
            self.passengers,
            self.cargo_capacity,
            self.consumables,
            self.hyperdrive_rating,
            self.mglt,
            self.starship_class
        )
    }
}
