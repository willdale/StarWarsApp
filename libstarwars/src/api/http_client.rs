#[uniffi::export(with_foreign)]
#[async_trait::async_trait]
pub trait HttpClient: Send + Sync {
    async fn fetch(&self, url: String) -> Result<Vec<u8>, NetworkError>;
}

#[derive(thiserror::Error, uniffi::Error, Debug)]
pub enum NetworkError {
    #[error("Request failed: {reason}")]
    RequestFailed { reason: String },
    #[error("Timeout")]
    Timeout,
}