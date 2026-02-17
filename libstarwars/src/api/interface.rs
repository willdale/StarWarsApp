use crate::api::api_client::ApiClient;
use crate::api::api_error::ApiError;
use crate::api::fetchable::Fetchable;
use crate::models::films::{Film, Films};
use crate::models::people::{Person, People};
use crate::models::planets::{Planet, Planets};
use crate::models::species::{Species, SpeciesList};
use crate::models::starships::{Starship, Starships};
use crate::models::vehicles::{Vehicle, Vehicles};

// ========================================================================
// Films
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_films(&self, ignore_cache: bool) -> Result<Vec<Film>, ApiError> {
        if !ignore_cache {
             if let Some(cached_films) = self.repository.get_films() {
                return Ok(cached_films);
            }
        }
        let films = self.fetch_page::<Films>(Fetchable::Films).await?.results;
        for film in &films {
            self.repository.insert_film(film);
        }
        Ok(films)
    }

    pub async fn fetch_film(&self, url: String) -> Result<Film, ApiError> {
        if let Some(item) = self.repository.get_film(url.as_str()) {
            return Ok(item);
        }
        let film = self.fetch_url::<Film>(url).await?;
        self.repository.insert_film(&film);
        Ok(film)
    }
}

// ========================================================================
// People
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_people(&self, ignore_cache: bool) -> Result<Vec<Person>, ApiError> {
        if !ignore_cache {
            if let Some(cached_people) = self.repository.get_people() {
                return Ok(cached_people);
            }
        }
        let people = self.fetch_page::<People>(Fetchable::People).await?.results;
        for person in &people {
            self.repository.insert_person(person);
        }
        Ok(people)
    }

    pub async fn fetch_person(&self, url: String) -> Result<Person, ApiError> {
        if let Some(item) = self.repository.get_person(url.as_str()) {
            return Ok(item);
        }
        let person = self.fetch_url::<Person>(url).await?;
        self.repository.insert_person(&person);
        Ok(person)
    }
}

// ========================================================================
// Planets
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_planets(&self, ignore_cache: bool) -> Result<Vec<Planet>, ApiError> {
        if !ignore_cache {
            if let Some(cached_planets) = self.repository.get_planets() {
                return Ok(cached_planets);
            }
        }
        let planets = self.fetch_page::<Planets>(Fetchable::Planets).await?.results;
        for planet in &planets {
            self.repository.insert_planet(planet);
        }
        Ok(planets)
    }

    pub async fn fetch_planet(&self, url: String) -> Result<Planet, ApiError> {
        if let Some(item) = self.repository.get_planet(url.as_str()) {
            return Ok(item);
        }
        let planet = self.fetch_url::<Planet>(url).await?;
        self.repository.insert_planet(&planet);
        Ok(planet)
    }
}

// ========================================================================
// Species
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_species_list(&self, ignore_cache: bool) -> Result<Vec<Species>, ApiError> {
        if !ignore_cache {
            if let Some(cached_species) = self.repository.get_species_list() {
                return Ok(cached_species);
            }
        }
        let species_list = self.fetch_page::<SpeciesList>(Fetchable::Species).await?.results;
        for species in &species_list {
            self.repository.insert_species(species);
        }
        Ok(species_list)
    }

    pub async fn fetch_species(&self, url: String) -> Result<Species, ApiError> {
        if let Some(item) = self.repository.get_species(url.as_str()) {
            return Ok(item);
        }
        let species = self.fetch_url::<Species>(url).await?;
        self.repository.insert_species(&species);
        Ok(species)
    }
}

// ========================================================================
// Starships
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_starships(&self, ignore_cache: bool) -> Result<Vec<Starship>, ApiError> {
        if !ignore_cache {
            if let Some(cached_starships) = self.repository.get_starships() {
                return Ok(cached_starships);
            }
        }
        let starships = self.fetch_page::<Starships>(Fetchable::Starships).await?.results;
        for starship in &starships {
            self.repository.insert_starship(starship);
        }
        Ok(starships)
    }

    pub async fn fetch_starship(&self, url: String) -> Result<Starship, ApiError> {
        if let Some(item) = self.repository.get_starship(url.as_str()) {
            return Ok(item);
        }
        let starship = self.fetch_url::<Starship>(url).await?;
        self.repository.insert_starship(&starship);
        Ok(starship)
    }
}

// ========================================================================
// Vehicles
// ========================================================================

#[uniffi::export]
impl ApiClient {
    pub async fn fetch_vehicles(&self, ignore_cache: bool) -> Result<Vec<Vehicle>, ApiError> {
        if !ignore_cache {
            if let Some(cached_vehicles) = self.repository.get_vehicles() {
                return Ok(cached_vehicles);
            }
        }
        let vehicles = self.fetch_page::<Vehicles>(Fetchable::Vehicles).await?.results;
        for vehicle in &vehicles {
            self.repository.insert_vehicle(vehicle);
        }
        Ok(vehicles)
    }

    pub async fn fetch_vehicle(&self, url: String) -> Result<Vehicle, ApiError> {
        if let Some(item) = self.repository.get_vehicle(url.as_str()) {
            return Ok(item);
        }
        let vehicle = self.fetch_url::<Vehicle>(url).await?;
        self.repository.insert_vehicle(&vehicle);
        Ok(vehicle)
    }
}
