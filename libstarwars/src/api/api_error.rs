use thiserror::Error;
use crate::api::http_client::NetworkError;

#[derive(Debug, Error, uniffi::Error)]
#[uniffi(flat_error)]
pub enum ApiError {
    #[error("HTTP error: status {status}")]
    HttpError { status: u16 },

    #[error("Network error: {0}")]
    NetworkError(#[from] NetworkError),

    #[error("JSON serialization error: {reason}")]
    SerializationError { reason: String },

    #[error("JSON deserialization error: {reason}")]
    DeserializationError { reason: String },

    #[error("Invalid response format")]
    InvalidResponse,

    #[error("Resource not found")]
    NotFound,

    #[error("Unauthorized")]
    Unauthorized,

    #[error("Rate limited")]
    RateLimited,

    #[error("Server error: {message}")]
    ServerError { message: String },
}

// Implement From for serde_json errors
impl From<serde_json::Error> for ApiError {
    fn from(err: serde_json::Error) -> Self {
        if err.is_syntax() || err.is_data() {
            ApiError::DeserializationError {
                reason: err.to_string(),
            }
        } else {
            ApiError::SerializationError {
                reason: err.to_string(),
            }
        }
    }
}