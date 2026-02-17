use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Planets {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Planet>,
}

#[derive(Deserialize, Clone, Debug, uniffi::Record)]
pub struct Planet {
    pub name: String,
    pub rotation_period: String,
    pub orbital_period: String,
    pub diameter: String,
    pub climate: String,
    pub gravity: String,
    pub terrain: String,
    pub surface_water: String,
    pub population: String,
    pub residents: Vec<String>,
    pub films: Vec<String>,
    pub created: String,
    pub edited: String,
    pub url: String,
}

impl Planet {
    pub fn description(&self) -> String {
        format!(
            "\n\
            ---------------------\n\
            Name:              {}\n\
            Rotation Period:   {}\n\
            Orbital Period:    {}\n\
            Diameter:          {}\n\
            Climate:           {}\n\
            Gravity:           {}\n\
            Terrain:           {}\n\
            Surface Water:     {}\n\
            Population:        {}\n\
            ---------------------\n",
            self.name,
            self.rotation_period,
            self.orbital_period,
            self.diameter,
            self.climate,
            self.gravity,
            self.terrain,
            self.surface_water,
            self.population
        )
    }
}