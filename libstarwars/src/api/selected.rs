use crate::models::films::Film;
use crate::models::people::Person;
use crate::models::planets::Planet;
use crate::models::species::Species;
use crate::models::starships::Starship;
use crate::models::vehicles::Vehicle;

#[derive(Debug, uniffi::Enum)]
pub enum Selected {
    Film(Film),
    Person(Person),
    Planet(Planet),
    Species(Species),
    Starship(Starship),
    Vehicle(Vehicle),
}