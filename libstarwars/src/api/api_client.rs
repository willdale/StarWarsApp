use super::http_client::HttpClient;
use std::sync::Arc;
use serde::de::DeserializeOwned;
use crate::api::fetchable::Fetchable;
use crate::api::repository::DataRepository;
use super::api_error::ApiError;

#[derive(uniffi::Object)]
pub struct ApiClient {
    http_client: Arc<dyn HttpClient>,
    pub repository: Arc<DataRepository>,
}

#[uniffi::export]
impl ApiClient {
    #[uniffi::constructor]
    pub fn new(http_client: Arc<dyn HttpClient>, repository: Arc<DataRepository>) -> Self {
        Self { http_client, repository }
    }
}

impl ApiClient {
    pub async fn fetch_page<T: DeserializeOwned>(&self, fetch: Fetchable) -> Result<T, ApiError> {
        let response = self.http_client.fetch(fetch.url()).await?;
        let object: T = serde_json::from_slice(&response)?;
        Ok(object)
    }

    pub async fn fetch_url<T: DeserializeOwned>(&self, url: String) -> Result<T, ApiError> {
        // Call the foreign-implemented HTTP client
        let response = self.http_client.fetch(url).await?;

        // Deserialize with serde
        let object: T = serde_json::from_slice(&response)?;
        Ok(object)
    }
}