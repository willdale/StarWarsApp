use crate::models::people::Person;

#[derive(Debug, uniffi::Enum)]
pub enum ListItems {
    Planets(Vec<String>),
    People(Vec<String>),
    Films(Vec<String>),
    Species(Vec<String>),
    Starships(Vec<String>),
    Vehicles(Vec<String>),
    Homeworld(String),
}

#[uniffi::export]
pub fn person_related_items(person: &Person) -> Vec<ListItems> {
    let mut items: Vec<ListItems> = Vec::new();

    if !person.films.is_empty() {
        items.push(ListItems::Films(person.films.clone()));
    }
    if !person.species.is_empty() {
        items.push(ListItems::Species(person.species.clone()));
    }
    if !person.starships.is_empty() {
        items.push(ListItems::Starships(person.starships.clone()));
    }
    if !person.vehicles.is_empty() {
        items.push(ListItems::Vehicles(person.vehicles.clone()));
    }
    if let Some(hw) = &person.homeworld {
        items.push(ListItems::Homeworld(hw.clone()));
    }

    items
}
