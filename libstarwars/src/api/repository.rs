use crate::models::films::Film;
use crate::models::people::Person;
use crate::models::planets::Planet;
use crate::models::species::Species;
use crate::models::starships::Starship;
use crate::models::vehicles::Vehicle;
use std::collections::HashMap;
use std::sync::Mutex;

#[derive(uniffi::Object)]
pub struct DataRepository {
    planets: Mutex<HashMap<String, Planet>>,
    people: Mutex<HashMap<String, Person>>,
    films: Mutex<HashMap<String, Film>>,
    species: Mutex<HashMap<String, Species>>,
    starships: Mutex<HashMap<String, Starship>>,
    vehicles: Mutex<HashMap<String, Vehicle>>,
}

#[uniffi::export]
impl DataRepository {
    #[uniffi::constructor]
    pub fn new() -> Self {
        Self {
            planets: Mutex::new(HashMap::new()),
            people: Mutex::new(HashMap::new()),
            films: Mutex::new(HashMap::new()),
            species: Mutex::new(HashMap::new()),
            starships: Mutex::new(HashMap::new()),
            vehicles: Mutex::new(HashMap::new()),
        }
    }
}

impl Default for DataRepository {
    fn default() -> Self {
        Self::new()
    }
}

// ========================================================================
// Planets
// ========================================================================

#[uniffi::export]
impl DataRepository {
    pub fn insert_planet(&self, planet: &Planet) {
        let mut planets = self.planets.lock().unwrap();
        planets.insert(planet.url.clone(), planet.clone());
    }

    pub fn get_planet(&self, url: &str) -> Option<Planet> {
        let planets = self.planets.lock().unwrap();
        planets.get (url).cloned()
    }

    pub fn get_planets(&self) -> Option<Vec<Planet>> {
        let planets = self.planets.lock().unwrap();
        if planets.is_empty() {
            return None;
        }
        let mut sorted_planets = planets.values().cloned().collect::<Vec<Planet>>();
        sorted_planets.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_planets)
    }
}

// ========================================================================
// People
// ========================================================================

impl DataRepository {
    pub fn insert_person(&self, person: &Person) {
        let mut people = self.people.lock().unwrap();
        people.insert(person.url.clone(), person.clone());
    }

    pub fn get_person(&self, url: &str) -> Option<Person> {
        let people = self.people.lock().unwrap();
        people.get(url).cloned()
    }

    pub fn get_people(&self) -> Option<Vec<Person>> {
        let people = self.people.lock().unwrap();
        if people.is_empty() {
            return None;
        }
        let mut sorted_people = people.values().cloned().collect::<Vec<Person>>();
        sorted_people.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_people)
    }
}

// ========================================================================
// Films
// ========================================================================

impl DataRepository {
    pub fn insert_film(&self, film: &Film) {
        let mut films = self.films.lock().unwrap();
        films.insert(film.url.clone(), film.clone());
    }

    pub fn get_film(&self, url: &str) -> Option<Film> {
        let films = self.films.lock().unwrap();
        films.get(url).cloned()
    }

    pub fn get_films(&self) -> Option<Vec<Film>> {
        let films = self.films.lock().unwrap();
        if films.is_empty() {
            return None;
        }
        let mut sorted_films = films.values().cloned().collect::<Vec<Film>>();
        sorted_films.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_films)
    }
}

// ========================================================================
// Species
// ========================================================================

impl DataRepository {
    pub fn insert_species(&self, species: &Species) {
        let mut species_map = self.species.lock().unwrap();
        species_map.insert(species.url.clone(), species.clone());
    }

    pub fn get_species(&self, url: &str) -> Option<Species> {
        let species = self.species.lock().unwrap();
        species.get(url).cloned()
    }

    pub fn get_species_list(&self) -> Option<Vec<Species>> {
        let species = self.species.lock().unwrap();
        if species.is_empty() {
            return None;
        }
        let mut sorted_species = species.values().cloned().collect::<Vec<Species>>();
        sorted_species.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_species)
    }
}

// ========================================================================
// Starships
// ========================================================================

impl DataRepository {
    pub fn insert_starship(&self, starship: &Starship) {
        let mut starships = self.starships.lock().unwrap();
        starships.insert(starship.url.clone(), starship.clone());
    }

    pub fn get_starship(&self, url: &str) -> Option<Starship> {
        let starships = self.starships.lock().unwrap();
        starships.get(url).cloned()
    }

    pub fn get_starships(&self) -> Option<Vec<Starship>> {
        let starships = self.starships.lock().unwrap();
        if starships.is_empty() {
            return None;
        }
        let mut sorted_starships = starships.values().cloned().collect::<Vec<Starship>>();
        sorted_starships.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_starships)
    }
}

// ========================================================================
// Vehicles
// ========================================================================

impl DataRepository {
    pub fn insert_vehicle(&self, vehicle: &Vehicle) {
        let mut vehicles = self.vehicles.lock().unwrap();
        vehicles.insert(vehicle.url.clone(), vehicle.clone());
    }

    pub fn get_vehicle(&self, url: &str) -> Option<Vehicle> {
        let vehicles = self.vehicles.lock().unwrap();
        vehicles.get(url).cloned()
    }

    pub fn get_vehicles(&self) -> Option<Vec<Vehicle>> {
        let vehicles = self.vehicles.lock().unwrap();
        if vehicles.is_empty() {
            return None;
        }
        let mut sorted_vehicles = vehicles.values().cloned().collect::<Vec<Vehicle>>();
        sorted_vehicles.sort_by(|a, b| a.url.cmp(&b.url));
        Some(sorted_vehicles)
    }
}
