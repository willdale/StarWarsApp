use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Vehicles {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Vehicle>,
}

#[derive(Debug, Deserialize, Clone, uniffi::Record)]
pub struct Vehicle {
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
    pub vehicle_class: String,
    pub pilots: Vec<String>,
    pub films: Vec<String>,
    pub created: String,
    pub edited: String,
    pub url: String,
}

impl Vehicle {
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
            Vehicle Class:          {}\n\
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
            self.vehicle_class
        )
    }
}