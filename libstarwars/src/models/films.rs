use serde::Deserialize;

#[derive(Deserialize, Debug)]
pub struct Films {
    pub count: u32,
    pub next: Option<String>,
    pub previous: Option<String>,
    pub results: Vec<Film>,
}
#[derive(Deserialize, Clone, Debug, uniffi::Record)]
pub struct Film {
    pub title: String,
    pub episode_id: i32,
    pub opening_crawl: String,
    pub director: String,
    pub producer: String,
    pub release_date: String,
    pub characters: Vec<String>,
    pub planets: Vec<String>,
    pub starships: Vec<String>,
    pub vehicles: Vec<String>,
    pub species: Vec<String>,
    pub created: String,
    pub edited: String,
    pub url: String,
}

impl Film {
    pub fn description(&self) -> String {
        format!(
            "\n\
            -----------------\n\
            Title:          {}\n\
            Episode ID:     {}\n\
            Release Date:   {}\n\
            Director:       {}\n\
            Producer:       {}\n\
            ------------------\n",
            self.title, self.episode_id, self.release_date, self.director, self.producer
        )
    }
}